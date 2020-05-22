# Blyp 

**If you have any questions, feel free to contact Hayden Hong at hello@haydenhong.com**

------------------------------------------------------------

## App Structure

### Frontend: SwiftUI
Blyp is built in [SwiftUI](https://developer.apple.com/xcode/swiftui/) which is great for multiple reasons, including:

* Easier to code 
* Better accessibility support
* Dark mode support for little extra effort

There are downsides to this, however, including:

* SwiftUI is new and lots of components have to be hand-built rather than added
* There are certain bugs that have not been fixed yet in SwiftUI
* SwiftUI is lacking in some functionality that UIKit has had for a long time.

### Backend: Firebase

[Firebase](https://firebase.google.com/) is the backend of the project. The paid Blaze plan is unfortunately required for the Firebase Functions (see: [Algolia > Functions](#algolia-firebase-functions)).

Firestore is used for storage of user profiles, public-facing profile information, and a list of fake users ()


### The Code

#### Combine

The meat of Blyp is contained in `UserObservable.swift`, a [Combine](https://developer.apple.com/documentation/combine) `ObservableObject` that is used as an environment object for nearly every view within the application.

`UserObservable` handles many things, including (but not limited to):
* Tracking login state
* Configures event listeners for new blyps, friends, and other profile changes
* Contains functionality for modifying one's profile

`UserObservable` is tightly coupled with `BlypsObservable`, another `ObservableObject` which handles the state of Blyps.

#### Blyps

As of the end of this project, a blyp follows this data structure:

```swift
struct Blyp {
    // REQUIRED: Information about Blyp
    var id: UUID = UUID()               // Generate a new id
    var name: String                    // Title of the Blyp
    var description: String             // Story about the Blyp
    var createdOn: Date = Date()        // Default to now
    var createdBy: String?              // UID of user who created this blyp

    // OPTIONAL: Values regarding Blyp Image
    var imageUrl: String?               // Cloud Storage download URL
    var imageBlurHash: String?          // Blur Hash
    var imageBlurHashWidth: CGFloat?    // Height of blur hash
    var imageBlurHashHeight: CGFloat?   // Height of blur hash

    // OPTIONAL: Values regarding Blyp location
    var longitude: Double?              // Longitude of location
    var latitude: Double?               // Latitude of location
}
```
<sup>See `Blyp.swift` for the full data structure</sup>

Note that the optional values are in chunks. If an Image is supplied to the blyp, ALL fields should be populated. **This is *not ideal* and should be refactored out to an optional `BlypImage` object, `BlypLocation` object, and so on where these objects have required fields.**

Blyps are created in `AddBlypView.swift` and viewed in `MainView.swift`.

[BlurHash](https://blurha.sh/) is the library used for ensuring that loading images don't look horrible.

#### Users

User profiles are stored as such in `UserProfile.swift`:

```swift
struct UserProfile: Codable {
    var blyps: [String: Blyp]   // UUID : Blyp
    var friends: [String]       // UIDs of friends
    var legacyContact: String   // UID of legacy contact
    var uid: String             // UID of user
}
```
 

------------------------------------------------------------

## Firebase

### Authentication

Sign-in-With-Apple is the only option for users to sign into Blyp. This is managed in `Views/Authentication` and `SignInWithAppleFirebase`.

### Firestore

Firestore is the database that holds three collections:

* fakeUsers
* userDisplayNames
* userProfiles

In order to keep userProfiles readable only by friends, these rules must be applied:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /userProfiles/{possiblyUserId} {
      // Do anything if it's your own profile
      allow list, read, write, delete: if request.auth.uid == possiblyUserId

      // Who cares about test blyps
      allow read: if possiblyUserId == "test-blyps"

      // Only read if it's a friend accessing your blyps or write if legacycontactg
      allow read: if resource.data.uid in get(/databases/$(database)/documents/userProfiles/$(request.auth.uid)).data.friends
      allow write: if resource.data.uid == get(/databases/$(database)/documents/userProfiles/$(request.auth.uid)).data.legacyContact
    }

    match /userDisplayNames/{possiblyUserId} {
    	allow read, write: if request.auth.uid == possiblyUserId
    	allow read: if request.auth != null
    }
  }
}
```
**This is currently not working correctly** for reasons beyond me, and allowing full read access for userProfiles is required for the demo to work.

### Cloud Storage

Cloud storage is using the default bucket and each folder is named after its user's UID supplied by Firebase authentication.

### Functions

[Firebase Functions](https://firebase.google.com/docs/functions) are doing a lot of work maintaining profiles. There are currently these Functions:


* createUserProfileDocumentOnAccountCreation
  * Creates a user profile in Firestore's userProfile collection for the user's UID
  * Called when an account is created
* updateSearchableInAlgolia
  * Updates the user display name in Firestore's userDisplayNames collection for the user's UID and updates the existing searchable in the Algolia search database
  * Called when a user creates a display name
* createSearchableInAlgolia
  * Updates the same information for updateSearchableInAlgolia
  * Called when a user changes their display name
* deleteSearchableInAlgolia
  * Deletes the searchable for the UID in Algolia and the userDisplayNames
  * Called on account deletion
* deleteUserDisplayNameOnAccountDeletion
  * Deletes userDisplayName when account is deleted
  * Called on account deletion 

Functions for managing images are desperately needed.


------------------------------------------------------------
## Aglolia

[Algolia](https://www.algolia.com/) is the search engine that is used for searching for users. This search engine is great to use because it allows for typo tolerance, its free student tier is enormous, and the `InstantSearchClient` for iOS is easy to use.

Blyps were supposed to be searchable too but adding that functionality was not feasible for the timeline.

### User Index

`prod_DISPLAY_NAMES` is the name for the user index in Algolia. This stores just the `displayName` and `objectID` for the user, same as stored in Firestore userDisplayName.

Searchable attributes should *only* include `displayName` as searching for `objectID` makes no sense.

**Word Proximity** should be increased to 2, 3, or 4 to ensure that full names can be searched (for example, "Hayden Hong" can be found by searching "hng" because of typo tolerance and last name)

------------------------------------------------------------

## Hambone Fake Namington

Showing off the app is no fun if there's no data. The hidden folder `.hambone-fake-namington` is a mocking library that utilizes the Firebase Admin tools to create fake users, fake Blyps for those users, and delete all the fake users. This way it is not empty when showing the app off.

------------------------------------------------------------

## If I had more time...

### Error Handling

Error handling in Blyp is almost non-existent. There should be a lot more in the way of error handling.

### Searchable Algolia Blyps

This is a large project because it needs to be secure for users while also allowing for searchable Blyps. I'm not 100% sure how to go about doing this.

### Get it on the App Store

We never got around to completely publishing the application.