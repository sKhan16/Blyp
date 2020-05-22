# Blyp Handoff Documentation

## Closing and Open Sourcing -- Reasoning

Blyp will remain open source because it is a unique engineering project that several tools that are not often seen together: [SwiftUI](https://developer.apple.com/xcode/swiftui/) and [Firebase](https://firebase.google.com/).

Because examples of SwiftUI and Firebase code are (as of writing) few due to SwiftUI only supporting iOS 13 and being immature, this project stands as a great example for how to use [Combine](https://developer.apple.com/documentation/combine), how to interface with UIKit, and how to use continuous integration with [GitHub Actions](https://github.com/features/actions) for continuous integration with a modern iOS project.

Blyp's online services, as configured, will be shut down eventually due to Firebase Blaze plan and Algolia search costs.

## Stakeholder Notification

**6 months** before closure of Blyp, a notification will be sent to users describing:

* The closure date of Blyp
* How to retrieve your data for safe keeping
  * An export tool will be created to migrate Blyps and profile information off of Firebase
* Competing solutions that might interest users.

This notification will be provided in the form of a [push notification](https://developer.apple.com/notifications/) and an [Action Sheet](https://developer.apple.com/documentation/swiftui/actionsheet) that displays upon login every day until closure.

## Landing Page Notice

[blyp.info](blyp.info) will be updated with a notice **6 months** before closure of Blyp describing the same information listed under [Stakeholder Notification](#stakeholder-notification).

After Blyp is taken offline, the webpage will be migrated to [GitHub Pages](https://pages.github.com/) and the domain blyp.info will be released for others to purchase if they want in order to save on hosting and registrar costs.

## System Shutdown and Deletion of Data

The two third-party services used for Blyp are:

* [Firebase](https://firebase.google.com/)
* Algolia

These two services do not automatically collect user data, all data included in Blyp is provided by users.

Regardless, these services will be disabled and deleted upon the Blyp closure date.

## Convert the Code Repository to a Public Repository

This step was part of Blyp from the beginning. In fact, you are reading this on our open source repository right now.

We are supporters of free and open source software and Blyp will remain open on [sKhan16's GitHub account](https://github.com/sKhan16/Blyp) and a fork on [AFRUITPIE's GitHub account](https://github.com/AFRUITPIE/Blyp) at a later date. We intend to transfer ownership of the repository to Hayden.

## README

Our [README](../README.md) will be updated with finalized instructions for hosting Firebase and Algolia.

There are already build instructions, intentionally made as easy as possible for all iOS developers.
