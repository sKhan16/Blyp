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

exports.createUserProfileDocumentOnAccountCreation = functions.auth.user().onCreate((user) => {
  return admin.firestore().collection(userProfiles).doc(user.uid).create({
    friends: [],
    blyps: [],
    legacyContact: {},
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
    const newObjectID = uuidv4();
    // Add an 'objectID' field which Algolia requires
    newUsername.objectID = newObjectID;
    // Store new object ID
    return admin
      .firestore()
      .collection(userDisplayNames)
      .doc(context.params.uid)
      .set({ objectID: newObjectID, displayName: newUsername.displayName })
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
    const uuid = uuidv4();
    username.objectID = uuid;
    return admin
      .firestore()
      .collection(userDisplayNames)
      .doc(context.params.uid)
      .set({ objectID: username.objectID, displayName: username.displayName })
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

// UUIDV4 generator
function uuidv4() {
  return "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, function (c) {
    let r = (Math.random() * 16) | 0,
      v = c == "x" ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}
