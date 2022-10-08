# SwiftyContacts

[![Language: Swift 5](https://img.shields.io/badge/language-Swift%205-f48041.svg?style=flat-square)](https://developer.apple.com/swift)
[![License](https://img.shields.io/cocoapods/l/SwiftyContacts.svg?style=flat-square)](http://cocoapods.org/pods/SwiftyContacts)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg?style=flat-square)](https://github.com/apple/swift-package-manager)

A Swift library for Contacts framework.

- [SwiftyContacts](#swiftycontacts)
  - [Requirements](#requirements)
  - [Installation](#installation)
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
      - [Update contact to the contact store.](#update-contact-to-the-contact-store)
      - [Delete contact to the contact store.](#delete-contact-to-the-contact-store)
      - [Adds a group to the contact store.](#adds-a-group-to-the-contact-store)
      - [Fetches all groups in the contact store.](#fetches-all-groups-in-the-contact-store)
      - [Updates an existing group in the contact store.](#updates-an-existing-group-in-the-contact-store)
      - [Deletes a group from the contact store.](#deletes-a-group-from-the-contact-store)
      - [Find the contacts that are members in the specified group.](#find-the-contacts-that-are-members-in-the-specified-group)
      - [Add a new member to a group.](#add-a-new-member-to-a-group)
      - [Removes a contact as a member of a group.](#removes-a-contact-as-a-member-of-a-group)
  - [Author](#author)
  - [License](#license)

## Requirements

- iOS 15+ / Mac OS X 12+
- Xcode 14.0+

## Installation
The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but SwiftyContacts does support its use on supported platforms.

Once you have your Swift package set up, adding SwiftyContacts as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/SwiftyContacts/SwiftyContacts.git", .upToNextMajor(from: "4.0.0"))
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

## Author
Satish Babariya, satish.babariya@gmail.com

## License
SwiftyContacts is available under the MIT license. See the LICENSE file for more info.
