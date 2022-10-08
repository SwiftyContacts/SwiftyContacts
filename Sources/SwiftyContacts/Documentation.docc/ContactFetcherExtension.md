# ``SwiftyContacts/ContactFetcher``
@Metadata {
    @DocumentationExtension(mergeBehavior: override)
}

Fetch the user's contacts from the system Address Book.

## Overview

After gaining access to the user's contacts using the ``SwiftyContacts/ContactAuthorizer``, initialize a `ContactFetcher` actor to perform simple fetch queries on the system Address Book. All fetches return a standard ``SwiftyContacts/ContactResult`` object for simplified access to each contact.

- important: `ContactFetcher` runs in an isolated-actor instance and must be accessed correctly in a thread-safe environment.

## Example
Getting started with the `ContactFetcher` is easy:

```swift
func fetchContactsWithPhoneNumbers() async throws {
    do {
        let contacts = try await ContactFetcher().fetchContacts(keysToFetch: [.phone])
        print("Contacts with phone numbers: \(contacts.map({ $0.name }))")
        return contacts
    } catch let error {
        throw error
    }
}
```

The ``fetchContacts(keysToFetch:order:unifyResults:compactResults:)`` function has additional options to specify its sort order, whether matching contacts should be unified, and if results with missing data should be returned.

## Topics

### Standard Fetching
The most-flexible fetch functions, allowing you to specify the data to fetch and manage how it gets returned to you.

- ``SwiftyContacts/ContactFetcher/fetchContacts(keysToFetch:order:unifyResults:compactResults:)``

### Predicate-Based Fetching
Fetch contacts from the Address Book using a custom predicate object.

- ``SwiftyContacts/ContactFetcher/fetchContacts(predicate:keysToFetch:)``

### Fetch Matching Contacts
Fetch contacts from the Address Book that match a given phone, email, etc.

- ``fetchContact(withIdentifier:keysToFetch:)``
- ``fetchContacts(matchingName:keysToFetch:)``
- ``fetchContacts(matchingEmailAddress:keysToFetch:)``
- ``fetchContacts(matching:keysToFetch:)``

### Fetch Contacts by ID or Group

- ``fetchContacts(withIdentifiers:keysToFetch:)``
- ``fetchContacts(withGroupIdentifier:keysToFetch:)``
- ``fetchContacts(withContainerIdentifier:keysToFetch:)``
