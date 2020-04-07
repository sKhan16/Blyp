var admin = require("firebase-admin");

var serviceAccount = require(process.env.GOOGLE_APPLICATION_CREDENTIALS);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://blyp-ae6e4.firebaseio.com",
});

admin.firestore().collection("fakeUsers").doc("list").get().then(snap => {
    console.log(snap)
    var fakeUsers = snap.data().fakeUsers

    fakeUsers.forEach(uid => {
        admin.auth().deleteUser(uid).then(() => {
            console.log("removed " + uid)
        }).catch(err => {
            console.log("couldn't remove " + uid)
        })
    });
})