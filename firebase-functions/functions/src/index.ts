/**
 * Blyp User creation and deletion maintenance
 */

import * as functions from "firebase-functions";
import admin = require("firebase-admin");
const algoliasearch = require("algoliasearch");

const userProfiles = "userProfiles";
const userDisplayNames = "userDisplayNames";

// Algolia stuff
const ALGOLIA_ID = functions.config().algolia.app_id;
const ALGOLIA_ADMIN_KEY = functions.config().algolia.api_key;
const ALGOLIA_INDEX_NAME = "prod_DISPLAY_NAMES";
const client = algoliasearch(ALGOLIA_ID, ALGOLIA_ADMIN_KEY);

admin.initializeApp(functions.config().firebase);

// Create a user profile document when an account is created
exports.createUserProfileDocumentOnAccountCreation = functions.auth.user().onCreate((user) => {
  let hasDisplayName = user.displayName !== undefined
  // Create the user profile document
  return admin.firestore().collection(userProfiles).doc(user.uid).create({
    friends: [],
    blyps: {},
    legacyContact: {},
    uid: user.uid
  }).then((result: FirebaseFirestore.WriteResult) => {
    // Create the display name document if one is given (typically only on creating fake users )
    if (hasDisplayName) {
      return admin.firestore().collection(userDisplayNames).doc(user.uid).create({
        displayName: user.displayName
      })
    }
    return;
  });
});

// Update the search index every time a username is written.
exports.updateSearchableInAlgolia = functions.firestore
  .document(`${userDisplayNames}/{uid}`)
  .onUpdate((snap: any, context: any) => {
    const oldUsername = snap.before.data();
    const newUsername = snap.after.data();
    if (oldUsername.displayName === newUsername.displayName) {
      return "just updating uuid"; // probably just updating UUID, ignore it
    }

    // Store new object ID
    return admin
      .firestore()
      .collection(userDisplayNames)
      .doc(context.params.uid)
      .set({ objectID: context.params.uid, displayName: newUsername.displayName })
      .then(() => {
        const index = client.initIndex(ALGOLIA_INDEX_NAME);
        console.log("object ID: " + "`" + oldUsername.objectID + "`");
        // Delete old username if applicable
        if (oldUsername.objectID !== undefined) {
          index.deleteObject(oldUsername.objectID);
        }
        // Create new username in Algolia
        return index.saveObject(newUsername);
      });
  });

exports.createSearchableInAlgolia = functions.firestore
  .document(`${userDisplayNames}/{uid}`)
  .onCreate((snap: any, context: any) => {
    const username = snap.data();
    username.objectID = context.params.uid
    return admin
      .firestore()
      .collection(userDisplayNames)
      .doc(context.params.uid)
      .set({ objectID: username.objectID, displayName: username.displayName }) // uid is objectID
      .then(() => {
        const index = client.initIndex(ALGOLIA_INDEX_NAME);
        // Create new username in Algolia
        return index.saveObject(username);
      });
  });

exports.deleteSearchableInAlgolia = functions.firestore
  .document(`${userDisplayNames}/{uid}`)
  .onDelete((snap: any, _context: any) => {
    const username = snap.data();
    const index = client.initIndex(ALGOLIA_INDEX_NAME);
    return index.deleteObject(username.objectID);
  });

exports.deleteUserDocumentOnAccountDeletion = functions.auth.user().onDelete((user) => {
  return admin.firestore().collection(userProfiles).doc(user.uid).delete();
});

exports.deleteUserDisplayNameOnAccountDeletion = functions.auth.user().onDelete((user) => {
  return admin.firestore().collection(userDisplayNames).doc(user.uid).delete();
});