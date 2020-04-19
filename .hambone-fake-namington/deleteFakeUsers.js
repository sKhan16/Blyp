let admin = require("firebase-admin");
let sleep = require("sleep");

let serviceAccount = require(process.env.GOOGLE_APPLICATION_CREDENTIALS);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://blyp-ae6e4.firebaseio.com",
});

let firestore = admin.firestore();

firestore
  .collection("fakeUsers")
  .doc("list")
  .get()
  .then((snap) => {
    let fakeUsers = snap.data().fakeUsers;
    fakeUsers.forEach((uid) => {
      admin
        .auth()
        .deleteUser(uid)
        .then(() => {
          console.log("removed " + uid);
          admin
            .firestore()
            .collection("fakeUsers")
            .doc("list")
            .update("fakeUsers", admin.firestore.FieldValue.arrayRemove(uid))
            .then(() => {
              console.log(`also removed ${uid} from fake users list`);
            })
            .catch((err) => {
              console.error(`couldn't remove ${uid} from fake users list: ${err}`);
            });
        })
        .catch((err) => {
          console.error(`couldn't remove ${uid}: ${err}`);
        });
    });
  });
