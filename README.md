# Blyp
![Test Commit](https://github.com/sKhan16/Blyp/workflows/Test%20Commit/badge.svg)

Informatics capstone project from Team Sonar

## Handoff Documentation 

[See here](./Documentation/Handoff.md)

## Project Engineering Info

[See here](./Documentation/README.md)

## Getting Started

Blyp is separated into two projects both at the top level: an iOS project defined in `blyp.xcodeproj` and the folder `blyp-landing-page`.

### Prerequisites
* [Xcode 11+](https://developer.apple.com/xcode/)
* [Firebase Project](https://firebase.google.com/)

### Installing

Clone the repository and ensure that pods are installed with:
```bash
$ pod install
```
Then follow [Firebase's instructions for adding a Firebase project to iOS](https://firebase.google.com/docs/ios/setup). 

### Deployment

Deployment for iOS applications is done exclusively through the App Store using Xcode.
Deployment for this application for a single device can be done through Xcode by running the application.

## Built With
* [Cocoapods](https://cocoapods.org/) for package management
* [Firebase](https://firebase.google.com/) for backend management
* [Algolia](https://www.algolia.com/) for search management
* [SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI) for image management
* [ObjectMapper](https://github.com/tristanhimmelman/ObjectMapper) for JSON parsing
* [Introspect](https://github.com/siteline/SwiftUI-Introspect) for access to legacy UIKit features
* [SwiftLocation](https://github.com/malcommac/SwiftLocation) for easy user location management
* [Pastel](https://github.com/cruisediary/Pastel) for a pretty login screen

## Contributing

Please read [CONTRIBUTING.md](./CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

* **Kassandra Franco** — *UI/UX Designer* – kfranco@uw.edu
* **Hayden Hong** – *iOS Development* – hahong@uw.edu
* **Shakeel Khan** – *Full-Stack Development* – khansk97@uw.edu
* **Vanely Ruiz** – *iOS Development* – vanely@uw.edu

## License

This project is licensed under the MIT License - see the [LICENSE.md](./LICENSE.md) for details

