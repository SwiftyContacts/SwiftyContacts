# SwiftyContacts

[![Language: Swift 5](https://img.shields.io/badge/language-Swift%205-f48041.svg?style=flat-square)](https://developer.apple.com/swift)
[![Version](https://img.shields.io/cocoapods/v/SwiftyContacts.svg?style=flat-square)](http://cocoapods.org/pods/SwiftyContacts)
[![License](https://img.shields.io/cocoapods/l/SwiftyContacts.svg?style=flat-square)](http://cocoapods.org/pods/SwiftyContacts)
[![Platform](https://img.shields.io/badge/platforms-iOS%209.0+%20%7C%20macOS%2010.12+%20%7C%20watchOS%203.0+-333333.svg?style=flat-square)](http://cocoapods.org/pods/SwiftyContacts)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg?style=flat-square)](https://github.com/apple/swift-package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/SwiftyContacts.svg?style=flat-square)](https://cocoapods.org/pods/SwiftyContacts)
[![RxSwift: Supported](https://img.shields.io/badge/RxSwift-Supported-f48041.svg?style=flat-square)](https://github.com/ReactiveX/RxSwift)
[![Read the Docs](https://img.shields.io/readthedocs/pip.svg?style=flat-square)](https://swiftycontacts.firebaseapp.com/)



A Swift library for Contacts framework.

- [Requirements](#requirements)
- [Installation](#installation)
- [Get started](#get-started)
    - [async-await](#async-await)
    - [closures](#closures) 
- [License](#license)

## Requirements

- iOS 11.0+ / Mac OS X 10.13+ /  watchOS 4.0+
- Xcode 13.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate SwiftyContacts into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'SwiftyContacts'
```

Then, run the following command:

```bash
$ pod install
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but SwiftyContacts does support its use on supported platforms.

Once you have your Swift package set up, adding SwiftyContacts as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/Alamofire/SwiftyContacts.git", .upToNextMajor(from: "4.0.0"))
]
```


## Get started


### async-await

#### [Requests access to the user's contacts](/Documentation/Reference/methods/requestAccess().md)
```swift
let access = try await requestAccess()
```

#### [Fetch all contacts from device](/Documentation/Reference/methods/fetchContacts(keysToFetch_order_unifyResults___).md)
```swift
let contacts = try await fetchContacts()
```

### closures

#### [Requests access to the user's contacts](/Documentation/Reference/methods/requestAccess(__).md)
```swift
requestAccess { result in
    switch result {
    case let .success(bool):
        print(bool)
    case let .failure(error):
        print(error.localizedDescription)
    }
}
```

#### [Fetch all contacts from device](/Documentation/Reference/methods/fetchContacts(keysToFetch_order_unifyResults_).md)
```swift
fetchContacts { result in
    switch result {
    case let .success(contacts):
        print(contacts)
    case let .failure(error):
        print(error.localizedDescription)
    }
}
```

## Author

Satish Babariya, satish.babariya@gmail.com

## License

SwiftyContacts is available under the MIT license. See the LICENSE file for more info.
