/**
 * Blyp User creation and deletion maintenance
 */

import * as functions from "firebase-functions";
import admin = require("firebase-admin");

const userProfiles = "userProfiles";
const userDisplayNames = "userDisplayNames";

exports.createUserProfileDocumentOnAccountCreation = functions.auth.user().onCreate(user => {
  if (!admin.apps.length) {
    admin.initializeApp();
  }
  return admin
    .firestore()
    .collection(userProfiles)
    .doc(user.uid)
    .create({
      friends: [],
      blyps: [],
      legacyContact: {}
    });
});

exports.updateUserDisplayNameOnDisplayNameChange = functions.firestore
  .document(`${userProfiles}/{uid}`)
  .onUpdate(snap => {
    if (!admin.apps.length) {
      admin.initializeApp();
    }
    const updateData = snap.after.data();
    if (!updateData) {
      return;
    }
    return admin
      .firestore()
      .collection(userDisplayNames)
      .doc(updateData.uid)
      .set({ displayName: updateData.displayName });
  });

exports.deleteUserDocumentOnAccountDeletion = functions.auth.user().onDelete(user => {
  if (!admin.apps.length) {
    admin.initializeApp();
  }
  return admin
    .firestore()
    .collection(userProfiles)
    .doc(user.uid)
    .delete();
});

exports.deleteUserDisplayNameOnAccountDeletion = functions.auth.user().onDelete(user => {
  if (!admin.apps.length) {
    admin.initializeApp();
  }
  return admin
    .firestore()
    .collection(userDisplayNames)
    .doc(user.uid)
    .delete();
});
