/**
 * Blyp User creation and deletion maintenance
 */

import * as functions from "firebase-functions";
import admin = require("firebase-admin");

const userProfiles = "userProfiles";
const userDisplayNames = "userDisplayNames";

admin.initializeApp(functions.config().firebase);

exports.createUserProfileDocumentOnAccountCreation = functions.auth.user().onCreate((user) => {
  return admin.firestore().collection(userProfiles).doc(user.uid).create({
    friends: [],
    blyps: [],
    legacyContact: {},
  });
});

exports.updateUserDisplayNameOnDisplayNameChange = functions.firestore
  .document(`${userDisplayNames}/{uid}`)
  .onUpdate((snap, context) => {
    const updateData = snap.after.data();
    if (!updateData) {
      return;
    }

    // Add searchable username (this will get HUGE and will be replaced with something like algolia soon)
    const splitName = updateData.displayName.split(" ");
    const searchable: Array<String> = [];
    splitName.forEach((section: String) => {
      let current = "";
      section.split("").forEach((char: String) => {
        current += char;
        searchable.push(current);
      });
    });

    return admin
      .firestore()
      .collection(userDisplayNames)
      .doc(context.params.uid)
      .set({ displayName: updateData.displayName, searchable: searchable });
  });

exports.deleteUserDocumentOnAccountDeletion = functions.auth.user().onDelete((user) => {
  return admin.firestore().collection(userProfiles).doc(user.uid).delete();
});

exports.deleteUserDisplayNameOnAccountDeletion = functions.auth.user().onDelete((user) => {
  return admin.firestore().collection(userDisplayNames).doc(user.uid).delete();
});
