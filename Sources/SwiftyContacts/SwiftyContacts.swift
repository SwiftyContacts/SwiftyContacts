//    Copyright (c) 2022 Satish Babariya <satish.babariya@gmail.com>
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.

@_exported import Contacts
import Foundation

/// Protocol defining the interface for a contact store, allowing for mocking in tests.
public protocol ContactStoreProtocol: Sendable {
    func requestAccess(for entityType: CNEntityType) async throws -> Bool
    func enumerateContacts(with request: CNContactFetchRequest, usingBlock block: @Sendable @escaping (CNContact, UnsafeMutablePointer<ObjCBool>) -> Void) throws
    func unifiedContacts(matching predicate: NSPredicate, keysToFetch: [CNKeyDescriptor]) throws -> [CNContact]
    func unifiedContact(withIdentifier identifier: String, keysToFetch: [CNKeyDescriptor]) throws -> CNContact
    func execute(_ saveRequest: CNSaveRequest) throws
    func groups(matching predicate: NSPredicate?) throws -> [CNGroup]
    func containers(matching predicate: NSPredicate?) throws -> [CNContainer]
}

extension CNContactStore: ContactStoreProtocol {}

/// A thread-safe contact store wrapper using an actor for modern Swift concurrency.
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
actor ContactStoreActor {
    private let store: ContactStoreProtocol
    static var shared = ContactStoreActor()
    
    init(store: ContactStoreProtocol = CNContactStore()) {
        self.store = store
    }
    
    func requestAccess(for entityType: CNEntityType) async throws -> Bool {
        return try await store.requestAccess(for: entityType)
    }
    
    func authorizationStatus(for entityType: CNEntityType) -> CNAuthorizationStatus {
        return CNContactStore.authorizationStatus(for: entityType)
    }
    
    func enumerateContacts(with request: CNContactFetchRequest) throws -> [CNContact] {
        var contacts: [CNContact] = []
        try store.enumerateContacts(with: request) { contact, _ in
            contacts.append(contact)
        }
        return contacts
    }
    
    func unifiedContacts(matching predicate: NSPredicate, keysToFetch: [CNKeyDescriptor]) throws -> [CNContact] {
        return try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
    }
    
    func unifiedContact(withIdentifier identifier: String, keysToFetch: [CNKeyDescriptor]) throws -> CNContact {
        return try store.unifiedContact(withIdentifier: identifier, keysToFetch: keysToFetch)
    }
    
    func execute(_ saveRequest: CNSaveRequest) throws {
        try store.execute(saveRequest)
    }
    
    func groups(matching predicate: NSPredicate?) throws -> [CNGroup] {
        return try store.groups(matching: predicate)
    }
}

// Internal instance for backward compatibility and synchronous operations
public enum ContactStore {
    public static var `default`: ContactStoreProtocol = CNContactStore()
}

/// Requests access to the user's contacts.
/// - Returns: `true` if the user allows access to contacts
/// - Throws: An error if access cannot be requested
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func requestAccess() async throws -> Bool {
    return try await ContactStoreActor.shared.requestAccess(for: .contacts)
}

/// Indicates the current authorization status to access contact data.
/// - Returns: The authorization status for contacts
public func authorizationStatus() -> CNAuthorizationStatus {
    return CNContactStore.authorizationStatus(for: .contacts)
}

/// Fetch all contacts from device
/// - Parameters:
///   - keysToFetch: The contact fetch request that specifies the search criteria.
///   - order: The sort order for contacts.
///   - unifyResults: A Boolean value that indicates whether to return linked contacts as unified contacts.
/// - Returns: An array of contacts
/// - Throws: An error if the fetch operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func fetchContacts(
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()],
    order: CNContactSortOrder = .none,
    unifyResults: Bool = true
) async throws -> [CNContact] {
    let actor = ContactStoreActor.shared
    let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
    fetchRequest.unifyResults = unifyResults
    fetchRequest.sortOrder = order
    return try await actor.enumerateContacts(with: fetchRequest)
}

/// Fetch contacts matching a predicate.
/// - Parameters:
///   - predicate: A definition of logical conditions for constraining a search for a fetch or for in-memory filtering.
///   - keysToFetch: The contact fetch request that specifies the search criteria.
/// - Returns: An array of contacts matching the predicate
/// - Throws: An error if the fetch operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func fetchContacts(
    predicate: NSPredicate,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]
) async throws -> [CNContact] {
    let actor = ContactStoreActor.shared
    return try await actor.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
}

/// Fetch contacts matching a predicate (synchronous version for backward compatibility).
/// - Parameters:
///   - predicate: A definition of logical conditions for constraining a search for a fetch or for in-memory filtering.
///   - keysToFetch: The contact fetch request that specifies the search criteria.
/// - Returns: An array of contacts matching the predicate
/// - Throws: An error if the fetch operation fails
public func fetchContacts(
    predicate: NSPredicate,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]
) throws -> [CNContact] {
    return try ContactStore.default.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
}

/// Fetch contacts matching a name.
/// - Parameters:
///   - name: The name can contain any number of words.
///   - keysToFetch: The contact fetch request that specifies the search criteria.
/// - Returns: An array of contacts matching the name
/// - Throws: An error if the fetch operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func fetchContacts(
    matchingName name: String,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]
) async throws -> [CNContact] {
    return try await fetchContacts(
        predicate: CNContact.predicateForContacts(matchingName: name),
        keysToFetch: keysToFetch
    )
}

/// Fetch contacts matching a name (synchronous version for backward compatibility).
/// - Parameters:
///   - name: The name can contain any number of words.
///   - keysToFetch: The contact fetch request that specifies the search criteria.
/// - Returns: An array of contacts matching the name
/// - Throws: An error if the fetch operation fails
public func fetchContacts(
    matchingName name: String,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]
) throws -> [CNContact] {
    return try fetchContacts(
        predicate: CNContact.predicateForContacts(matchingName: name),
        keysToFetch: keysToFetch
    )
}

/// Fetch contacts matching an email address.
/// - Parameters:
///   - emailAddress: The email address to search for. Do not include a scheme (e.g., "mailto:").
///   - keysToFetch: The contact fetch request that specifies the search criteria.
/// - Returns: An array of contacts matching the email address
/// - Throws: An error if the fetch operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func fetchContacts(
    matchingEmailAddress emailAddress: String,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]
) async throws -> [CNContact] {
    return try await fetchContacts(
        predicate: CNContact.predicateForContacts(matchingEmailAddress: emailAddress),
        keysToFetch: keysToFetch
    )
}

/// Fetch contacts matching an email address (synchronous version for backward compatibility).
/// - Parameters:
///   - emailAddress: The email address to search for. Do not include a scheme (e.g., "mailto:").
///   - keysToFetch: The contact fetch request that specifies the search criteria.
/// - Returns: An array of contacts matching the email address
/// - Throws: An error if the fetch operation fails
public func fetchContacts(
    matchingEmailAddress emailAddress: String,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]
) throws -> [CNContact] {
    return try fetchContacts(
        predicate: CNContact.predicateForContacts(matchingEmailAddress: emailAddress),
        keysToFetch: keysToFetch
    )
}

/// Fetch contacts matching a phone number.
/// - Parameters:
///   - phoneNumber: A CNPhoneNumber representing the phone number to search for. Do not include a scheme (e.g., "tel:").
///   - keysToFetch: The contact fetch request that specifies the search criteria.
/// - Returns: An array of contacts matching the phone number
/// - Throws: An error if the fetch operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func fetchContacts(
    matching phoneNumber: CNPhoneNumber,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]
) async throws -> [CNContact] {
    return try await fetchContacts(
        predicate: CNContact.predicateForContacts(matching: phoneNumber),
        keysToFetch: keysToFetch
    )
}

/// Fetch contacts matching a phone number (synchronous version for backward compatibility).
/// - Parameters:
///   - phoneNumber: A CNPhoneNumber representing the phone number to search for. Do not include a scheme (e.g., "tel:").
///   - keysToFetch: The contact fetch request that specifies the search criteria.
/// - Returns: An array of contacts matching the phone number
/// - Throws: An error if the fetch operation fails
public func fetchContacts(
    matching phoneNumber: CNPhoneNumber,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]
) throws -> [CNContact] {
    return try fetchContacts(
        predicate: CNContact.predicateForContacts(matching: phoneNumber),
        keysToFetch: keysToFetch
    )
}

/// Fetch contacts matching contact identifiers.
/// - Parameters:
///   - identifiers: Contact identifiers to be matched.
///   - keysToFetch: The contact fetch request that specifies the search criteria.
/// - Returns: An array of contacts matching the identifiers
/// - Throws: An error if the fetch operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func fetchContacts(
    withIdentifiers identifiers: [String],
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]
) async throws -> [CNContact] {
    return try await fetchContacts(
        predicate: CNContact.predicateForContacts(withIdentifiers: identifiers),
        keysToFetch: keysToFetch
    )
}

/// Fetch contacts matching contact identifiers (synchronous version for backward compatibility).
/// - Parameters:
///   - identifiers: Contact identifiers to be matched.
///   - keysToFetch: The contact fetch request that specifies the search criteria.
/// - Returns: An array of contacts matching the identifiers
/// - Throws: An error if the fetch operation fails
public func fetchContacts(
    withIdentifiers identifiers: [String],
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]
) throws -> [CNContact] {
    return try fetchContacts(
        predicate: CNContact.predicateForContacts(withIdentifiers: identifiers),
        keysToFetch: keysToFetch
    )
}

/// Fetch contacts matching a group identifier.
/// - Parameters:
///   - groupIdentifier: The group identifier to be matched.
///   - keysToFetch: The contact fetch request that specifies the search criteria.
/// - Returns: An array of contacts in the specified group
/// - Throws: An error if the fetch operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func fetchContacts(
    withGroupIdentifier groupIdentifier: String,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]
) async throws -> [CNContact] {
    return try await fetchContacts(
        predicate: CNContact.predicateForContactsInGroup(withIdentifier: groupIdentifier),
        keysToFetch: keysToFetch
    )
}

/// Fetch contacts matching a group identifier (synchronous version for backward compatibility).
/// - Parameters:
///   - groupIdentifier: The group identifier to be matched.
///   - keysToFetch: The contact fetch request that specifies the search criteria.
/// - Returns: An array of contacts in the specified group
/// - Throws: An error if the fetch operation fails
public func fetchContacts(
    withGroupIdentifier groupIdentifier: String,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]
) throws -> [CNContact] {
    return try fetchContacts(
        predicate: CNContact.predicateForContactsInGroup(withIdentifier: groupIdentifier),
        keysToFetch: keysToFetch
    )
}

/// Find the contacts in the specified container.
/// - Parameters:
///   - containerIdentifier: The container identifier to be matched.
///   - keysToFetch: The contact fetch request that specifies the search criteria.
/// - Returns: An array of contacts in the specified container
/// - Throws: An error if the fetch operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func fetchContacts(
    withContainerIdentifier containerIdentifier: String,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]
) async throws -> [CNContact] {
    return try await fetchContacts(
        predicate: CNContact.predicateForContactsInContainer(withIdentifier: containerIdentifier),
        keysToFetch: keysToFetch
    )
}

/// Find the contacts in the specified container (synchronous version for backward compatibility).
/// - Parameters:
///   - containerIdentifier: The container identifier to be matched.
///   - keysToFetch: The contact fetch request that specifies the search criteria.
/// - Returns: An array of contacts in the specified container
/// - Throws: An error if the fetch operation fails
public func fetchContacts(
    withContainerIdentifier containerIdentifier: String,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]
) throws -> [CNContact] {
    return try fetchContacts(
        predicate: CNContact.predicateForContactsInContainer(withIdentifier: containerIdentifier),
        keysToFetch: keysToFetch
    )
}

/// Fetch a contact with a given identifier.
/// - Parameters:
///   - identifier: The identifier of the contact to fetch.
///   - keysToFetch: The contact fetch request that specifies the search criteria.
/// - Returns: Contact matching or linked to the identifier
/// - Throws: An error if the fetch operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func fetchContact(
    withIdentifier identifier: String,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]
) async throws -> CNContact {
    let actor = ContactStoreActor.shared
    return try await actor.unifiedContact(withIdentifier: identifier, keysToFetch: keysToFetch)
}

/// Fetch a contact with a given identifier (synchronous version for backward compatibility).
/// - Parameters:
///   - identifier: The identifier of the contact to fetch.
///   - keysToFetch: The contact fetch request that specifies the search criteria.
/// - Returns: Contact matching or linked to the identifier
/// - Throws: An error if the fetch operation fails
public func fetchContact(
    withIdentifier identifier: String,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]
) throws -> CNContact {
    return try ContactStore.default.unifiedContact(withIdentifier: identifier, keysToFetch: keysToFetch)
}

/// Adds the specified contact to the contact store.
/// - Parameters:
///   - contact: The new contact to add.
///   - identifier: The container identifier to add the new contact to. Set to nil for the default container.
/// - Throws: An error if the operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func addContact(
    _ contact: CNMutableContact,
    toContainerWithIdentifier identifier: String? = nil
) async throws {
    let actor = ContactStoreActor.shared
    let request = CNSaveRequest()
    request.add(contact, toContainerWithIdentifier: identifier)
    try await actor.execute(request)
}

/// Adds the specified contact to the contact store (synchronous version for backward compatibility).
/// - Parameters:
///   - contact: The new contact to add.
///   - identifier: The container identifier to add the new contact to. Set to nil for the default container.
/// - Throws: An error if the operation fails
public func addContact(
    _ contact: CNMutableContact,
    toContainerWithIdentifier identifier: String? = nil
) throws {
    let request = CNSaveRequest()
    request.add(contact, toContainerWithIdentifier: identifier)
    try ContactStore.default.execute(request)
}

/// Adds the specified contact to the contact store.
/// - Parameters:
///   - contact: The new contact to add.
///   - identifier: The container identifier to add the new contact to. Set to nil for the default container.
/// - Throws: An error if the operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func addContact(
    _ contact: CNContact,
    toContainerWithIdentifier identifier: String? = nil
) async throws {
    guard let mutableContact = contact.mutableCopy() as? CNMutableContact else {
        throw NSError(domain: "SwiftyContacts", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create mutable contact"])
    }
    try await addContact(mutableContact, toContainerWithIdentifier: identifier)
}

/// Adds the specified contact to the contact store (synchronous version for backward compatibility).
/// - Parameters:
///   - contact: The new contact to add.
///   - identifier: The container identifier to add the new contact to. Set to nil for the default container.
/// - Throws: An error if the operation fails
public func addContact(
    _ contact: CNContact,
    toContainerWithIdentifier identifier: String? = nil
) throws {
    guard let mutableContact = contact.mutableCopy() as? CNMutableContact else {
        return
    }
    try addContact(mutableContact, toContainerWithIdentifier: identifier)
}

/// Updates an existing contact in the contact store.
/// - Parameter contact: The contact to update.
/// - Throws: An error if the operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func updateContact(_ contact: CNMutableContact) async throws {
    let actor = ContactStoreActor.shared
    let request = CNSaveRequest()
    request.update(contact)
    try await actor.execute(request)
}

/// Updates an existing contact in the contact store (synchronous version for backward compatibility).
/// - Parameter contact: The contact to update.
/// - Throws: An error if the operation fails
public func updateContact(_ contact: CNMutableContact) throws {
    let request = CNSaveRequest()
    request.update(contact)
    try ContactStore.default.execute(request)
}

/// Updates an existing contact in the contact store.
/// - Parameter contact: The contact to update.
/// - Throws: An error if the operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func updateContact(_ contact: CNContact) async throws {
    guard let mutableContact = contact.mutableCopy() as? CNMutableContact else {
        throw NSError(domain: "SwiftyContacts", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create mutable contact"])
    }
    try await updateContact(mutableContact)
}

/// Updates an existing contact in the contact store (synchronous version for backward compatibility).
/// - Parameter contact: The contact to update.
/// - Throws: An error if the operation fails
public func updateContact(_ contact: CNContact) throws {
    guard let mutableContact = contact.mutableCopy() as? CNMutableContact else {
        return
    }
    try updateContact(mutableContact)
}

/// Deletes a contact from the contact store.
/// - Parameter contact: Contact to be deleted.
/// - Throws: An error if the operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func deleteContact(_ contact: CNMutableContact) async throws {
    let actor = ContactStoreActor.shared
    let request = CNSaveRequest()
    request.delete(contact)
    try await actor.execute(request)
}

/// Deletes a contact from the contact store (synchronous version for backward compatibility).
/// - Parameter contact: Contact to be deleted.
/// - Throws: An error if the operation fails
public func deleteContact(_ contact: CNMutableContact) throws {
    let request = CNSaveRequest()
    request.delete(contact)
    try ContactStore.default.execute(request)
}

/// Deletes a contact from the contact store.
/// - Parameter contact: Contact to be deleted.
/// - Throws: An error if the operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func deleteContact(_ contact: CNContact) async throws {
    guard let mutableContact = contact.mutableCopy() as? CNMutableContact else {
        throw NSError(domain: "SwiftyContacts", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create mutable contact"])
    }
    try await deleteContact(mutableContact)
}

/// Deletes a contact from the contact store (synchronous version for backward compatibility).
/// - Parameter contact: Contact to be deleted.
/// - Throws: An error if the operation fails
public func deleteContact(_ contact: CNContact) throws {
    guard let mutableContact = contact.mutableCopy() as? CNMutableContact else {
        return
    }
    try deleteContact(mutableContact)
}

/// Fetches all groups in the contact store.
/// - Parameter predicate: The predicate to use to fetch the matching groups. Set predicate to nil to match all groups.
/// - Returns: An array of CNGroup objects that match the predicate.
/// - Throws: An error if the fetch operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func fetchGroups(matching predicate: NSPredicate? = nil) async throws -> [CNGroup] {
    let actor = ContactStoreActor.shared
    return try await actor.groups(matching: predicate)
}

/// Fetches all groups in the contact store (synchronous version for backward compatibility).
/// - Parameter predicate: The predicate to use to fetch the matching groups. Set predicate to nil to match all groups.
/// - Returns: An array of CNGroup objects that match the predicate.
/// - Throws: An error if the fetch operation fails
public func fetchGroups(matching predicate: NSPredicate? = nil) throws -> [CNGroup] {
    return try ContactStore.default.groups(matching: predicate)
}

/// Adds a group to the contact store.
/// - Parameters:
///   - name: The new group to add.
///   - identifier: The container identifier to add the new group to. Set to nil for the default container.
/// - Throws: An error if the operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func addGroup(
    _ name: String,
    toContainerWithIdentifier identifier: String? = nil
) async throws {
    let actor = ContactStoreActor.shared
    let request = CNSaveRequest()
    let group = CNMutableGroup()
    group.name = name
    request.add(group, toContainerWithIdentifier: identifier)
    try await actor.execute(request)
}

/// Adds a group to the contact store (synchronous version for backward compatibility).
/// - Parameters:
///   - name: The new group to add.
///   - identifier: The container identifier to add the new group to. Set to nil for the default container.
/// - Throws: An error if the operation fails
public func addGroup(
    _ name: String,
    toContainerWithIdentifier identifier: String? = nil
) throws {
    let request = CNSaveRequest()
    let group = CNMutableGroup()
    group.name = name
    request.add(group, toContainerWithIdentifier: identifier)
    try ContactStore.default.execute(request)
}

/// Updates an existing group in the contact store.
/// - Parameter group: The group to update.
/// - Throws: An error if the operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func updateGroup(_ group: CNMutableGroup) async throws {
    let actor = ContactStoreActor.shared
    let request = CNSaveRequest()
    request.update(group)
    try await actor.execute(request)
}

/// Updates an existing group in the contact store (synchronous version for backward compatibility).
/// - Parameter group: The group to update.
/// - Throws: An error if the operation fails
public func updateGroup(_ group: CNMutableGroup) throws {
    let request = CNSaveRequest()
    request.update(group)
    try ContactStore.default.execute(request)
}

/// Updates an existing group in the contact store.
/// - Parameter group: The group to update.
/// - Throws: An error if the operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func updateGroup(_ group: CNGroup) async throws {
    guard let mutableGroup = group.mutableCopy() as? CNMutableGroup else {
        throw NSError(domain: "SwiftyContacts", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create mutable group"])
    }
    try await updateGroup(mutableGroup)
}

/// Updates an existing group in the contact store (synchronous version for backward compatibility).
/// - Parameter group: The group to update.
/// - Throws: An error if the operation fails
public func updateGroup(_ group: CNGroup) throws {
    guard let mutableGroup = group.mutableCopy() as? CNMutableGroup else {
        return
    }
    try updateGroup(mutableGroup)
}

/// Deletes a group from the contact store.
/// - Parameter group: The group to delete.
/// - Throws: An error if the operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func deleteGroup(_ group: CNMutableGroup) async throws {
    let actor = ContactStoreActor.shared
    let request = CNSaveRequest()
    request.delete(group)
    try await actor.execute(request)
}

/// Deletes a group from the contact store (synchronous version for backward compatibility).
/// - Parameter group: The group to delete.
/// - Throws: An error if the operation fails
public func deleteGroup(_ group: CNMutableGroup) throws {
    let request = CNSaveRequest()
    request.delete(group)
    try ContactStore.default.execute(request)
}

/// Deletes a group from the contact store.
/// - Parameter group: The group to delete.
/// - Throws: An error if the operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func deleteGroup(_ group: CNGroup) async throws {
    guard let mutableGroup = group.mutableCopy() as? CNMutableGroup else {
        throw NSError(domain: "SwiftyContacts", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create mutable group"])
    }
    try await deleteGroup(mutableGroup)
}

/// Deletes a group from the contact store (synchronous version for backward compatibility).
/// - Parameter group: The group to delete.
/// - Throws: An error if the operation fails
public func deleteGroup(_ group: CNGroup) throws {
    guard let mutableGroup = group.mutableCopy() as? CNMutableGroup else {
        return
    }
    try deleteGroup(mutableGroup)
}

/// Find the contacts that are members in the specified group.
/// - Parameters:
///   - group: The group identifier to be matched.
///   - keysToFetch: The contact fetch request that specifies the search criteria.
/// - Returns: An array of contacts in the specified group
/// - Throws: An error if the fetch operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func fetchContacts(
    in group: String,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]
) async throws -> [CNContact] {
    return try await fetchContacts(
        predicate: CNContact.predicateForContactsInGroup(withIdentifier: group),
        keysToFetch: keysToFetch
    )
}

/// Find the contacts that are members in the specified group (synchronous version for backward compatibility).
/// - Parameters:
///   - group: The group identifier to be matched.
///   - keysToFetch: The contact fetch request that specifies the search criteria.
/// - Returns: An array of contacts in the specified group
/// - Throws: An error if the fetch operation fails
public func fetchContacts(
    in group: String,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]
) throws -> [CNContact] {
    return try fetchContacts(
        predicate: CNContact.predicateForContactsInGroup(withIdentifier: group),
        keysToFetch: keysToFetch
    )
}

/// Add a new member to a group.
/// - Parameters:
///   - contact: The new member to add to the group.
///   - group: The group to add the member to.
/// - Throws: An error if the operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func addContact(_ contact: CNContact, to group: CNGroup) async throws {
    let actor = ContactStoreActor.shared
    let request = CNSaveRequest()
    request.addMember(contact, to: group)
    try await actor.execute(request)
}

/// Add a new member to a group (synchronous version for backward compatibility).
/// - Parameters:
///   - contact: The new member to add to the group.
///   - group: The group to add the member to.
/// - Throws: An error if the operation fails
public func addContact(_ contact: CNContact, to group: CNGroup) throws {
    let request = CNSaveRequest()
    request.addMember(contact, to: group)
    try ContactStore.default.execute(request)
}

/// Removes a contact as a member of a group.
/// - Parameters:
///   - contact: The contact to remove from the group membership.
///   - group: The group to remove the contact from its membership.
/// - Throws: An error if the operation fails
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public func removeContact(_ contact: CNContact, from group: CNGroup) async throws {
    let actor = ContactStoreActor.shared
    let request = CNSaveRequest()
    request.removeMember(contact, from: group)
    try await actor.execute(request)
}

/// Removes a contact as a member of a group (synchronous version for backward compatibility).
/// - Parameters:
///   - contact: The contact to remove from the group membership.
///   - group: The group to remove the contact from its membership.
/// - Throws: An error if the operation fails
public func removeContact(_ contact: CNContact, from group: CNGroup) throws {
    let request = CNSaveRequest()
    request.removeMember(contact, from: group)
    try ContactStore.default.execute(request)
}

/// Removes a contact as a member of a group (deprecated - use removeContact instead).
/// - Parameters:
///   - contact: The contact to remove from the group membership.
///   - group: The group to remove the contact from its membership.
/// - Throws: An error if the operation fails
@available(*, deprecated, renamed: "removeContact(_:from:)")
public func deleteContact(_ contact: CNContact, from group: CNGroup) throws {
    try removeContact(contact, from: group)
}
