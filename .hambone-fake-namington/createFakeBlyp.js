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
    console.log("Got fake blyps");
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
        // process.exit()
      });
  });

function generateFakeBlyps(testBlyps) {
  let fakeBlyps = {};
  // convert to array
  var testBlypsArr = [];
  for (let key in testBlyps) {
    testBlypsArr.push(testBlyps[key]);
  }
  let previouslySelected = [];
  testBlyps = testBlypsArr;
  for (let i = 0; i < 10; i++) {
    let index = faker.random.number(testBlyps.length - 1);
    while (previouslySelected.includes(index)) {
      index = faker.random.number(testBlyps.length - 1);
    }
    previouslySelected.push(index);
    let selectedImage = testBlyps[index];
    let id = faker.random.uuid();
    fakeBlyps[id] = {
      id: faker.random.uuid(),
      name: faker.lorem.words(faker.random.number({ min: 1, max: 3 })),
      createdOn: faker.date.recent(),
      description: faker.lorem.words(faker.random.number({ min: 1, max: 10 })),
      imageBlurHash: selectedImage.imageBlurHash,
      imageBlurHashHeight: selectedImage.imageBlurHashHeight,
      imageBlurHashWidth: selectedImage.imageBlurHashWidth,
      imageUrl: selectedImage.imageUrl,
    };
  }

  return fakeBlyps;
}
