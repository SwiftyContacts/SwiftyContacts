# SwiftyContacts

[![Language: Swift 5.9](https://img.shields.io/badge/language-Swift%205.9-f48041.svg?style=flat-square)](https://developer.apple.com/swift)
[![Version](https://img.shields.io/cocoapods/v/SwiftyContacts.svg?style=flat-square)](http://cocoapods.org/pods/SwiftyContacts)
[![License](https://img.shields.io/cocoapods/l/SwiftyContacts.svg?style=flat-square)](http://cocoapods.org/pods/SwiftyContacts)
[![Platform](https://img.shields.io/badge/platforms-iOS%2015.0+%20%7C%20macOS%2012.0+%20%7C%20watchOS%208.0+%20%7C%20tvOS%2015.0+-333333.svg?style=flat-square)](http://cocoapods.org/pods/SwiftyContacts)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg?style=flat-square)](https://github.com/apple/swift-package-manager)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/SwiftyContacts.svg?style=flat-square)](https://cocoapods.org/pods/SwiftyContacts)

A modern Swift library for the Contacts framework with full async/await support, type-safe APIs, and comprehensive contact management capabilities.

## Features

- ✅ **Modern Swift Concurrency**: Full async/await support with Swift 5.9+
- ✅ **Thread-Safe**: Actor-based implementation for safe concurrent access
- ✅ **Dual API Support**: Both async/await and closure-based APIs for maximum flexibility
- ✅ **Type-Safe**: Strongly typed APIs with comprehensive error handling
- ✅ **Cross-Platform**: Support for iOS, macOS, watchOS, and tvOS
- ✅ **Comprehensive**: Full CRUD operations for contacts and groups
- ✅ **vCard Support**: Encode and decode contacts to/from vCard format
- ✅ **Backward Compatible**: Maintains compatibility with existing code

## Requirements

- iOS 15.0+ / macOS 12.0+ / watchOS 8.0+ / tvOS 15.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is the recommended way to install SwiftyContacts.

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/SwiftyContacts/SwiftyContacts.git", from: "5.0.0")
]
```

Or add it through Xcode:
1. File → Add Packages...
2. Enter the repository URL: `https://github.com/SwiftyContacts/SwiftyContacts.git`
3. Select the version you want to use

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. To integrate SwiftyContacts:

```ruby
pod 'SwiftyContacts', '~> 5.0'
```

Then run:
```bash
$ pod install
```

## Quick Start

### Request Access

```swift
import SwiftyContacts

// Async/await
let hasAccess = try await requestAccess()

// Closures
requestAccess { result in
    switch result {
    case .success(let hasAccess):
        print("Access granted: \(hasAccess)")
    case .failure(let error):
        print("Error: \(error)")
    }
}
```

### Fetch Contacts

```swift
// Fetch all contacts
let contacts = try await fetchContacts()

// Fetch with specific keys
let keysToFetch: [CNKeyDescriptor] = [
    CNContactGivenNameKey as CNKeyDescriptor,
    CNContactEmailAddressesKey as CNKeyDescriptor
]
let contacts = try await fetchContacts(keysToFetch: keysToFetch)

// Fetch with sorting
let contacts = try await fetchContacts(
    order: .givenName,
    unifyResults: true
)
```

### Search Contacts

```swift
// Search by name
let contacts = try await fetchContacts(matchingName: "John Doe")

// Search by email
let contacts = try await fetchContacts(matchingEmailAddress: "john@example.com")

// Search by phone number
let phoneNumber = CNPhoneNumber(stringValue: "+1234567890")
let contacts = try await fetchContacts(matching: phoneNumber)

// Search by identifiers
let contacts = try await fetchContacts(withIdentifiers: ["id1", "id2"])
```

### Manage Contacts

```swift
// Create a new contact
let contact = CNMutableContact()
contact.givenName = "Jane"
contact.familyName = "Doe"
contact.emailAddresses = [
    CNLabeledValue(label: CNLabelHome, value: "jane@example.com")
]

// Add contact
try await addContact(contact)

// Update contact
contact.givenName = "Jane Updated"
try await updateContact(contact)

// Delete contact
try await deleteContact(contact)
```

### Work with Groups

```swift
// Fetch all groups
let groups = try await fetchGroups()

// Create a group
try await addGroup("My Group")

// Fetch contacts in a group
let contacts = try await fetchContacts(in: "My Group")

// Add contact to group
try await addContact(contact, to: group)

// Remove contact from group
try await removeContact(contact, from: group)

// Delete group
try await deleteGroup(group)
```

### vCard Support

```swift
// Encode contacts to vCard
let contacts = try await fetchContacts()
let vCardData = try encode(contacts: contacts)

// Decode vCard to contacts
let decodedContacts = try decode(data: vCardData)
```

## API Reference

### Authorization

- `requestAccess() async throws -> Bool` - Request access to contacts
- `authorizationStatus() -> CNAuthorizationStatus` - Get current authorization status

### Fetching Contacts

- `fetchContacts(keysToFetch:order:unifyResults:) async throws -> [CNContact]` - Fetch all contacts
- `fetchContact(withIdentifier:keysToFetch:) async throws -> CNContact` - Fetch a single contact
- `fetchContacts(matchingName:keysToFetch:) async throws -> [CNContact]` - Search by name
- `fetchContacts(matchingEmailAddress:keysToFetch:) async throws -> [CNContact]` - Search by email
- `fetchContacts(matching:keysToFetch:) async throws -> [CNContact]` - Search by phone number
- `fetchContacts(withIdentifiers:keysToFetch:) async throws -> [CNContact]` - Fetch by identifiers
- `fetchContacts(withGroupIdentifier:keysToFetch:) async throws -> [CNContact]` - Fetch by group
- `fetchContacts(withContainerIdentifier:keysToFetch:) async throws -> [CNContact]` - Fetch by container
- `fetchContacts(in:keysToFetch:) async throws -> [CNContact]` - Fetch contacts in a group

### Managing Contacts

- `addContact(_:toContainerWithIdentifier:) async throws` - Add a contact
- `updateContact(_:) async throws` - Update a contact
- `deleteContact(_:) async throws` - Delete a contact

### Managing Groups

- `fetchGroups(matching:) async throws -> [CNGroup]` - Fetch groups
- `addGroup(_:toContainerWithIdentifier:) async throws` - Add a group
- `updateGroup(_:) async throws` - Update a group
- `deleteGroup(_:) async throws` - Delete a group
- `addContact(_:to:) async throws` - Add contact to group
- `removeContact(_:from:) async throws` - Remove contact from group

### vCard

- `encode(contacts:) throws -> Data` - Encode contacts to vCard
- `decode(data:) throws -> [CNContact]` - Decode vCard to contacts

All methods also have synchronous versions for backward compatibility and closure-based versions in `SwiftyContacts+Closures.swift`.

## Migration Guide

### From v4.x to v5.x

SwiftyContacts v5.0 introduces breaking changes:

1. **Platform Requirements**: Minimum iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0
2. **Swift Version**: Requires Swift 5.9+
3. **Async/Await**: All async methods now use `@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)`
4. **Method Naming**: `deleteContact(_:from:)` is now `removeContact(_:from:)` (old method is deprecated)

The synchronous and closure-based APIs remain available for backward compatibility.

## Thread Safety

SwiftyContacts uses Swift actors to ensure thread-safe access to the Contacts framework. All async operations are automatically serialized, preventing race conditions and ensuring data consistency.

## Error Handling

All methods throw errors that conform to Swift's `Error` protocol. Common errors include:
- Authorization errors
- Contact store errors
- Validation errors

Always wrap async calls in `do-catch` blocks:

```swift
do {
    let contacts = try await fetchContacts()
} catch {
    print("Error fetching contacts: \(error)")
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

SwiftyContacts is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## Author

Satish Babariya, satish.babariya@gmail.com

## Acknowledgments

Built with ❤️ using modern Swift concurrency and best practices.
