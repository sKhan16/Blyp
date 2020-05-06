var admin = require("firebase-admin");
var faker = require("faker");

var serviceAccount = require(process.env.GOOGLE_APPLICATION_CREDENTIALS);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://blyp-ae6e4.firebaseio.com",
});

let firestore = admin.firestore();

console.log("Creating a fake blyp for every single user");

firestore
  .collection("userProfiles")
  .doc("test-blyps")
  .get()
  .then((fakeBlypsSnap) => {
    console.log("Got fake blyps")
    firestore
      .collection("fakeUsers")
      .doc("list")
      .get()
      .then((snap) => {
        let testBlyps = fakeBlypsSnap.data().blyps;
        let fakeUsers = snap.data().fakeUsers;
        fakeUsers.forEach((uid) => {
          admin.firestore().collection("userProfiles").doc(uid).update("blyps", generateFakeBlyps(testBlyps));
        });
        process.exit()
      });
  });

  function generateFakeBlyps(testBlyps) {
    let fakeBlyps = []
    // convert to array
    var testBlypsArr = []
    for (let key in testBlyps) {
      testBlypsArr.push(testBlyps[key])
    }
    testBlyps = testBlypsArr
    for (let i = 0; i < 10; i++) {
      let index = faker.random.number(testBlyps.length - 1)  
      let selectedImage = testBlyps[index]

        fakeBlyps.push({
            id: faker.random.uuid(),
            name: faker.lorem.words(faker.random.number(3)),
            description: faker.lorem.words(faker.random.number(10)),
            imageBlurHash: selectedImage.imageBlurHash,
            imageBlurHashHeight: selectedImage.imageBlurHashHeight,
            imageBlurHashWidth: selectedImage.imageBlurHashWidth, 
            imageUrl: selectedImage.imageUrl
        })
    }

    return fakeBlyps;
}