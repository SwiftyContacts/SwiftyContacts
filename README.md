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

- [SwiftyContacts](#swiftycontacts)
  - [Requirements](#requirements)
  - [Installation](#installation)
    - [CocoaPods](#cocoapods)
    - [Swift Package Manager](#swift-package-manager)
  - [Get started](#get-started)
    - [async-await](#async-await)
      - [Requests access to the user's contacts](#requests-access-to-the-users-contacts)
      - [Request the current authorization status](#request-the-current-authorization-status)
      - [Fetch all contacts from device](#fetch-all-contacts-from-device)
      - [Fetch contacts matching a name.](#fetch-contacts-matching-a-name)
      - [Fetch contacts matching an email address.](#fetch-contacts-matching-an-email-address)
      - [Fetch contacts matching a phone number.](#fetch-contacts-matching-a-phone-number)
      - [To fetch contacts matching contact identifiers.](#to-fetch-contacts-matching-contact-identifiers)
      - [To fetch contacts matching group identifier](#to-fetch-contacts-matching-group-identifier)
      - [find the contacts in the specified container.](#find-the-contacts-in-the-specified-container)
      - [Fetch a contact with a given identifier.](#fetch-a-contact-with-a-given-identifier)
      - [Add contact to the contact store.](#add-contact-to-the-contact-store)
    - [closures](#closures)
      - [Requests access to the user's contacts](#requests-access-to-the-users-contacts-1)
      - [Fetch all contacts from device](#fetch-all-contacts-from-device-1)
  - [Author](#author)
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

#### Requests access to the user's contacts
```swift
let access = try await requestAccess()
```

#### Request the current authorization status
```swift
let status = authorizationStatus()
print(status == CNAuthorizationStatus.authorized)
```

#### Fetch all contacts from device
```swift
let contacts = try await fetchContacts()
```

#### Fetch contacts matching a name.
```swift
let contacts = try await fetchContacts(matchingName: "Satish Babariya")
```


#### Fetch contacts matching an email address.
```swift
let contacts = try await fetchContacts(matchingEmailAddress: "satish.babariya@gmail.com")
```

#### Fetch contacts matching a phone number.
```swift
let contacts = try await fetchContacts(matching: CNPhoneNumber(stringValue: "+919426678969"))
```

#### To fetch contacts matching contact identifiers.
```swift
let contacts = try await fetchContacts(withIdentifiers: ["id1", "id2" ... ])
```

#### To fetch contacts matching group identifier
```swift
let contacts = try await fetchContacts(withGroupIdentifier: "")
```

#### find the contacts in the specified container.
```swift
let contacts = try await fetchContacts(withContainerIdentifier: "")
```

#### Fetch a contact with a given identifier.
```swift
let contact = try await fetchContact(withIdentifier: "")
```

#### Add contact to the contact store.
```swift
let contact = CNMutableContact()
contact.givenName = "Satish"
try addContact(contact)
```

### closures

#### Requests access to the user's contacts
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

#### Fetch all contacts from device
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
