# SwiftyContacts

A modern Swift library for the Contacts framework with full async/await support, type-safe APIs, and comprehensive contact management capabilities.

## Overview

SwiftyContacts provides a modern, type-safe, and concurrent interface to Apple's Contacts framework. It leverages Swift 6 features including actors for thread safety, async/await for modern concurrency, and comprehensive error handling.

## Features

- **Modern Swift Concurrency**: Full async/await support with Swift 6+
- **Thread-Safe**: Actor-based implementation for safe concurrent access
- **Dual API Support**: Both async/await and closure-based APIs for maximum flexibility
- **Type-Safe**: Strongly typed APIs with comprehensive error handling
- **Cross-Platform**: Support for iOS, macOS, watchOS, tvOS, and visionOS
- **Comprehensive**: Full CRUD operations for contacts and groups
- **vCard Support**: Encode and decode contacts to/from vCard format
- **Backward Compatible**: Maintains compatibility with existing code

## Requirements

- iOS 16.0+ / macOS 13.0+ / watchOS 9.0+ / tvOS 16.0+ / visionOS 1.0+
- Xcode 15.0+
- Swift 6.0+

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is the recommended way to install SwiftyContacts.

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/SwiftyContacts/SwiftyContacts.git", from: "6.0.0")
]
```

Or add it through Xcode:
1. File → Add Packages...
2. Enter the repository URL: `https://github.com/SwiftyContacts/SwiftyContacts.git`
3. Select the version you want to use

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. To integrate SwiftyContacts:

```ruby
pod 'SwiftyContacts', '~> 6.0'
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

- ``requestAccess()`` - Request access to contacts
- ``authorizationStatus()`` - Get current authorization status

### Fetching Contacts

- ``fetchContacts(keysToFetch:order:unifyResults:)`` - Fetch all contacts
- ``fetchContact(withIdentifier:keysToFetch:)`` - Fetch a single contact
- ``fetchContacts(matchingName:keysToFetch:)`` - Search by name
- ``fetchContacts(matchingEmailAddress:keysToFetch:)`` - Search by email
- ``fetchContacts(matching:keysToFetch:)`` - Search by phone number
- ``fetchContacts(withIdentifiers:keysToFetch:)`` - Fetch by identifiers
- ``fetchContacts(withGroupIdentifier:keysToFetch:)`` - Fetch by group
- ``fetchContacts(withContainerIdentifier:keysToFetch:)`` - Fetch by container
- ``fetchContacts(in:keysToFetch:)`` - Fetch contacts in a group

### Managing Contacts

- ``addContact(_:toContainerWithIdentifier:)`` - Add a contact
- ``updateContact(_:)`` - Update a contact
- ``deleteContact(_:)`` - Delete a contact

### Managing Groups

- ``fetchGroups(matching:)`` - Fetch groups
- ``addGroup(_:toContainerWithIdentifier:)`` - Add a group
- ``updateGroup(_:)`` - Update a group
- ``deleteGroup(_:)`` - Delete a group
- ``addContact(_:to:)`` - Add contact to group
- ``removeContact(_:from:)`` - Remove contact from group

### vCard

- ``encode(contacts:)`` - Encode contacts to vCard
- ``decode(data:)`` - Decode vCard to contacts

All methods also have synchronous versions for backward compatibility and closure-based versions in `SwiftyContacts+Closures.swift`.

## Migration Guide

### From v5.x to v6.x

SwiftyContacts v6.0 introduces breaking changes:

1. **Platform Requirements**: Minimum iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, visionOS 1.0
2. **Swift Version**: Requires Swift 6.0+
3. **Concurrency**: Improved actor-based isolation and Sendable conformance
4. **Vision OS Support**: Added support for Apple Vision Pro

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