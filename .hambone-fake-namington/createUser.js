var admin = require("firebase-admin");
var faker = require("faker");

var serviceAccount = require(process.env.GOOGLE_APPLICATION_CREDENTIALS);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://blyp-ae6e4.firebaseio.com",
});

let user = {
  email: faker.internet.email(),
  emailVerified: false,
  password: faker.internet.password(),
  displayName: faker.name.findName(),
  disabled: false,
};

console.log("Creating user");
admin
  .auth()
  .createUser(user)
  .then((createdUser) => {
    return admin
      .firestore()
      .collection("fakeUsers")
      .doc("list")
      .update({ fakeUsers: admin.firestore.FieldValue.arrayUnion(createdUser.uid) })
      .then(() => {
        console.log("done");
        process.exit();
      });
  });
