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

/// Requests access to the user's contacts (closure-based API for backward compatibility).
/// - Parameter completion: A completion handler that returns either a success or a failure.
///   - On success: Returns `true` if the user allows access to contacts.
///   - On error: Returns error information if an error occurred.
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, visionOS 1.0, *)
public func requestAccess(_ completion: @escaping @Sendable (Result<Bool, Error>) -> Void) {
    if let store = ContactStore.default as? CNContactStore {
        store.requestAccess(for: .contacts) { bool, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(bool))
        }
    } else {
        // For mocks or other protocol conformers, we use the async version internally
        Task { @MainActor in
            do {
                let status = try await ContactStore.default.requestAccess(for: .contacts)
                completion(.success(status))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

/// Fetch all contacts from device (closure-based API for backward compatibility).
/// - Parameters:
///   - keysToFetch: The contact fetch request that specifies the search criteria.
///   - order: The sort order for contacts.
///   - unifyResults: A Boolean value that indicates whether to return linked contacts as unified contacts.
///   - completion: A completion handler that returns either a success or a failure.
///     - On success: Returns an array of contacts.
///     - On error: Returns error information if an error occurred.
public func fetchContacts(
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()],
    order: CNContactSortOrder = .none,
    unifyResults: Bool = true,
    _ completion: @escaping @Sendable (Result<[CNContact], Error>) -> Void
) {
    do {
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        fetchRequest.unifyResults = unifyResults
        fetchRequest.sortOrder = order
        
        let collectedContacts = NSLockingArray<CNContact>()
        try ContactStore.default.enumerateContacts(with: fetchRequest) { contact, _ in
            collectedContacts.append(contact)
        }
        completion(.success(collectedContacts.allElements))
    } catch {
        completion(.failure(error))
    }
}

private final class NSLockingArray<Element>: @unchecked Sendable {
    private var elements: [Element] = []
    private let lock = NSLock()
    
    func append(_ element: Element) {
        lock.lock()
        defer { lock.unlock() }
        elements.append(element)
    }
    
    var allElements: [Element] {
        lock.lock()
        defer { lock.unlock() }
        return elements
    }
}

/// Fetch contacts matching a predicate (closure-based API for backward compatibility).
/// - Parameters:
///   - predicate: A definition of logical conditions for constraining a search for a fetch or for in-memory filtering.
///   - keysToFetch: The contact fetch request that specifies the search criteria.
///   - completion: A completion handler that returns either a success or a failure.
///     - On success: Returns an array of contacts.
///     - On error: Returns error information if an error occurred.
public func fetchContacts(
    predicate: NSPredicate,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()],
    _ completion: @escaping @Sendable (Result<[CNContact], Error>) -> Void
) {
    do {
        completion(.success(try ContactStore.default.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)))
    } catch {
        completion(.failure(error))
    }
}

/// Fetch contacts matching a name (closure-based API for backward compatibility).
/// - Parameters:
///   - name: The name can contain any number of words.
///   - keysToFetch: The contact fetch request that specifies the search criteria.
///   - completion: A completion handler that returns either a success or a failure.
///     - On success: Returns an array of contacts.
///     - On error: Returns error information if an error occurred.
public func fetchContacts(
    matchingName name: String,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()],
    _ completion: @escaping @Sendable (Result<[CNContact], Error>) -> Void
) {
    do {
        completion(.success(try ContactStore.default.unifiedContacts(matching: CNContact.predicateForContacts(matchingName: name), keysToFetch: keysToFetch)))
    } catch {
        completion(.failure(error))
    }
}

/// Fetch contacts matching an email address (closure-based API for backward compatibility).
/// - Parameters:
///   - emailAddress: The email address to search for. Do not include a scheme (e.g., "mailto:").
///   - keysToFetch: The contact fetch request that specifies the search criteria.
///   - completion: A completion handler that returns either a success or a failure.
///     - On success: Returns an array of contacts.
///     - On error: Returns error information if an error occurred.
public func fetchContacts(
    matchingEmailAddress emailAddress: String,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()],
    _ completion: @escaping @Sendable (Result<[CNContact], Error>) -> Void
) {
    do {
        completion(.success(try ContactStore.default.unifiedContacts(matching: CNContact.predicateForContacts(matchingEmailAddress: emailAddress), keysToFetch: keysToFetch)))
    } catch {
        completion(.failure(error))
    }
}

/// Fetch contacts matching a phone number (closure-based API for backward compatibility).
/// - Parameters:
///   - phoneNumber: A CNPhoneNumber representing the phone number to search for. Do not include a scheme (e.g., "tel:").
///   - keysToFetch: The contact fetch request that specifies the search criteria.
///   - completion: A completion handler that returns either a success or a failure.
///     - On success: Returns an array of contacts.
///     - On error: Returns error information if an error occurred.
public func fetchContacts(
    matching phoneNumber: CNPhoneNumber,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()],
    _ completion: @escaping @Sendable (Result<[CNContact], Error>) -> Void
) {
    do {
        completion(.success(try ContactStore.default.unifiedContacts(matching: CNContact.predicateForContacts(matching: phoneNumber), keysToFetch: keysToFetch)))
    } catch {
        completion(.failure(error))
    }
}

/// Fetch contacts matching contact identifiers (closure-based API for backward compatibility).
/// - Parameters:
///   - identifiers: Contact identifiers to be matched.
///   - keysToFetch: The contact fetch request that specifies the search criteria.
///   - completion: A completion handler that returns either a success or a failure.
///     - On success: Returns an array of contacts.
///     - On error: Returns error information if an error occurred.
public func fetchContacts(
    withIdentifiers identifiers: [String],
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()],
    _ completion: @escaping @Sendable (Result<[CNContact], Error>) -> Void
) {
    do {
        completion(.success(try ContactStore.default.unifiedContacts(matching: CNContact.predicateForContacts(withIdentifiers: identifiers), keysToFetch: keysToFetch)))
    } catch {
        completion(.failure(error))
    }
}

/// Fetch contacts matching a group identifier (closure-based API for backward compatibility).
/// - Parameters:
///   - groupIdentifier: The group identifier to be matched.
///   - keysToFetch: The contact fetch request that specifies the search criteria.
///   - completion: A completion handler that returns either a success or a failure.
///     - On success: Returns an array of contacts.
///     - On error: Returns error information if an error occurred.
public func fetchContacts(
    withGroupIdentifier groupIdentifier: String,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()],
    _ completion: @escaping @Sendable (Result<[CNContact], Error>) -> Void
) {
    do {
        completion(.success(try ContactStore.default.unifiedContacts(matching: CNContact.predicateForContactsInGroup(withIdentifier: groupIdentifier), keysToFetch: keysToFetch)))
    } catch {
        completion(.failure(error))
    }
}

/// Find the contacts in the specified container (closure-based API for backward compatibility).
/// - Parameters:
///   - containerIdentifier: The container identifier to be matched.
///   - keysToFetch: The contact fetch request that specifies the search criteria.
///   - completion: A completion handler that returns either a success or a failure.
///     - On success: Returns an array of contacts.
///     - On error: Returns error information if an error occurred.
public func fetchContacts(
    withContainerIdentifier containerIdentifier: String,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()],
    _ completion: @escaping @Sendable (Result<[CNContact], Error>) -> Void
) {
    do {
        completion(.success(try ContactStore.default.unifiedContacts(matching: CNContact.predicateForContactsInContainer(withIdentifier: containerIdentifier), keysToFetch: keysToFetch)))
    } catch {
        completion(.failure(error))
    }
}

/// Fetch a contact with a given identifier (closure-based API for backward compatibility).
/// - Parameters:
///   - identifier: The identifier of the contact to fetch.
///   - keysToFetch: The contact fetch request that specifies the search criteria.
///   - completion: A completion handler that returns either a success or a failure.
///     - On success: Returns the contact matching or linked to the identifier.
///     - On error: Returns error information if an error occurred.
public func fetchContact(
    withIdentifier identifier: String,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()],
    _ completion: @escaping @Sendable (Result<CNContact, Error>) -> Void
) {
    do {
        completion(.success(try ContactStore.default.unifiedContact(withIdentifier: identifier, keysToFetch: keysToFetch)))
    } catch {
        completion(.failure(error))
    }
}

/// Adds the specified contact to the contact store (closure-based API for backward compatibility).
/// - Parameters:
///   - contact: The new contact to add.
///   - identifier: The container identifier to add the new contact to. Set to nil for the default container.
///   - completion: A completion handler that returns either a success or a failure.
///     - On success: Returns `true`.
///     - On error: Returns error information if an error occurred.
public func addContact(
    _ contact: CNMutableContact,
    toContainerWithIdentifier identifier: String? = nil,
    _ completion: @escaping @Sendable (Result<Bool, Error>) -> Void
) {
    do {
        let request = CNSaveRequest()
        request.add(contact, toContainerWithIdentifier: identifier)
        try ContactStore.default.execute(request)
        completion(.success(true))
    } catch {
        completion(.failure(error))
    }
}

/// Updates an existing contact in the contact store (closure-based API for backward compatibility).
/// - Parameters:
///   - contact: The contact to update.
///   - completion: A completion handler that returns either a success or a failure.
///     - On success: Returns `true`.
///     - On error: Returns error information if an error occurred.
public func updateContact(
    _ contact: CNMutableContact,
    _ completion: @escaping @Sendable (Result<Bool, Error>) -> Void
) {
    do {
        let request = CNSaveRequest()
        request.update(contact)
        try ContactStore.default.execute(request)
        completion(.success(true))
    } catch {
        completion(.failure(error))
    }
}

/// Deletes a contact from the contact store (closure-based API for backward compatibility).
/// - Parameters:
///   - contact: Contact to be deleted.
///   - completion: A completion handler that returns either a success or a failure.
///     - On success: Returns `true`.
///     - On error: Returns error information if an error occurred.
public func deleteContact(
    _ contact: CNMutableContact,
    _ completion: @escaping @Sendable (Result<Bool, Error>) -> Void
) {
    do {
        let request = CNSaveRequest()
        request.delete(contact)
        try ContactStore.default.execute(request)
        completion(.success(true))
    } catch {
        completion(.failure(error))
    }
}

/// Fetches all groups matching the specified predicate (closure-based API for backward compatibility).
/// - Parameters:
///   - predicate: The predicate to use to fetch the matching groups. Set predicate to nil to match all groups.
///   - completion: A completion handler that returns either a success or a failure.
///     - On success: Returns an array of CNGroup objects that match the predicate.
///     - On error: Returns error information if an error occurred.
public func fetchGroups(
    matching predicate: NSPredicate? = nil,
    _ completion: @escaping @Sendable (Result<[CNGroup], Error>) -> Void
) {
    do {
        let groups = try ContactStore.default.groups(matching: predicate)
        completion(.success(groups))
    } catch {
        completion(.failure(error))
    }
}

/// Adds a group to the contact store (closure-based API for backward compatibility).
/// - Parameters:
///   - name: The new group to add.
///   - identifier: The container identifier to add the new group to. Set to nil for the default container.
///   - completion: A completion handler that returns either a success or a failure.
///     - On success: Returns `true`.
///     - On error: Returns error information if an error occurred.
public func addGroup(
    _ name: String,
    toContainerWithIdentifier identifier: String? = nil,
    _ completion: @escaping @Sendable (Result<Bool, Error>) -> Void
) {
    do {
        let request = CNSaveRequest()
        let group = CNMutableGroup()
        group.name = name
        request.add(group, toContainerWithIdentifier: identifier)
        try ContactStore.default.execute(request)
        completion(.success(true))
    } catch {
        completion(.failure(error))
    }
}

/// Updates an existing group in the contact store (closure-based API for backward compatibility).
/// - Parameters:
///   - group: The group to update.
///   - completion: A completion handler that returns either a success or a failure.
///     - On success: Returns `true`.
///     - On error: Returns error information if an error occurred.
public func updateGroup(
    _ group: CNMutableGroup,
    _ completion: @escaping @Sendable (Result<Bool, Error>) -> Void
) {
    do {
        let request = CNSaveRequest()
        request.update(group)
        try ContactStore.default.execute(request)
        completion(.success(true))
    } catch {
        completion(.failure(error))
    }
}

/// Deletes a group from the contact store (closure-based API for backward compatibility).
/// - Parameters:
///   - group: The group to delete.
///   - completion: A completion handler that returns either a success or a failure.
///     - On success: Returns `true`.
///     - On error: Returns error information if an error occurred.
public func deleteGroup(
    _ group: CNMutableGroup,
    _ completion: @escaping @Sendable (Result<Bool, Error>) -> Void
) {
    do {
        let request = CNSaveRequest()
        request.delete(group)
        try ContactStore.default.execute(request)
        completion(.success(true))
    } catch {
        completion(.failure(error))
    }
}

/// Find the contacts that are members in the specified group (closure-based API for backward compatibility).
/// - Parameters:
///   - group: The group identifier to be matched.
///   - keysToFetch: The contact fetch request that specifies the search criteria.
///   - completion: A completion handler that returns either a success or a failure.
///     - On success: Returns an array of contacts.
///     - On error: Returns error information if an error occurred.
public func fetchContacts(
    in group: String,
    keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()],
    _ completion: @escaping @Sendable (Result<[CNContact], Error>) -> Void
) {
    do {
        let contacts = try fetchContacts(predicate: CNContact.predicateForContactsInGroup(withIdentifier: group), keysToFetch: keysToFetch)
        completion(.success(contacts))
    } catch {
        completion(.failure(error))
    }
}

/// Add a new member to a group (closure-based API for backward compatibility).
/// - Parameters:
///   - contact: The new member to add to the group.
///   - group: The group to add the member to.
///   - completion: A completion handler that returns either a success or a failure.
///     - On success: Returns `true`.
///     - On error: Returns error information if an error occurred.
public func addContact(
    _ contact: CNContact,
    to group: CNGroup,
    _ completion: @escaping @Sendable (Result<Bool, Error>) -> Void
) {
    do {
        let request = CNSaveRequest()
        request.addMember(contact, to: group)
        try ContactStore.default.execute(request)
        completion(.success(true))
    } catch {
        completion(.failure(error))
    }
}

/// Removes a contact as a member of a group (closure-based API for backward compatibility).
/// - Parameters:
///   - contact: The contact to remove from the group membership.
///   - group: The group to remove the contact from its membership.
///   - completion: A completion handler that returns either a success or a failure.
///     - On success: Returns `true`.
///     - On error: Returns error information if an error occurred.
public func removeContact(
    _ contact: CNContact,
    from group: CNGroup,
    _ completion: @escaping @Sendable (Result<Bool, Error>) -> Void
) {
    do {
        let request = CNSaveRequest()
        request.removeMember(contact, from: group)
        try ContactStore.default.execute(request)
        completion(.success(true))
    } catch {
        completion(.failure(error))
    }
}
