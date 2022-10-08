//
//  ContactFetcher.swift
//  SwiftyContacts
//
//  Created by Sam Spencer on 10/8/22.
//  Copyright © 2022 nenos, llc.
//

@_exported import Contacts
import Foundation

/// Fetches the user's contacts.
///
public actor ContactFetcher {
    
    init() {
        
    }
    
    // MARK: - Work Functions
    
    /// Fetch all contacts from the user's device
    ///
    /// - parameters:
    ///   - keysToFetch: The keys to fetch for each contact from the user's contacts,
    ///     specified as ``ContactKeyOptions``.
    ///   - order: The sort order for contacts. Defaults to `.userDefault`.
    ///   - unifyResults: Set to `true` to return linked contacts as unified contacts.
    ///     Defaults to `true`.
    ///   - compactResults: Set to `true` to remove any contacts from the returned results
    ///     that do not have the information specified in the `keysToFetch` parameter. For
    ///     instance, if you added `phone` as a key to fetch, any contact without a phone
    ///     number would be removed from the results. Defaults to `true`.
    ///
    /// - throws: Error information, if an error occurred.
    /// - returns: An array of discovered contacts as ``ContactResult`` objects.
    ///
    public func fetchContacts(
        keysToFetch: [ContactKeyOptions] = [.vCardRequired],
        order: CNContactSortOrder = .userDefault,
        unifyResults: Bool = true,
        compactResults: Bool = true
    ) async throws -> [ContactResult] {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let fetchedKeys = mapOptionsToKeys(keysToFetch)
                
                var contacts: [CNContact] = []
                let fetchRequest = CNContactFetchRequest(keysToFetch: fetchedKeys)
                fetchRequest.unifyResults = unifyResults
                fetchRequest.sortOrder = order
                
                try ContactStore.default.enumerateContacts(with: fetchRequest) { contact, _ in
                    contacts.append(contact)
                }
                
                var mappedResponse = contacts.map({ ContactResult(from: $0) })
                if compactResults == true {
                    mappedResponse = compactMappedResults(mappedResponse, for: keysToFetch)
                }
                
                continuation.resume(returning: mappedResponse)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    /// Fetch contacts matching a conditions.
    ///
    /// - parameters:
    ///   - predicate: A definition of logical conditions for constraining a search for a
    ///     fetch or for in-memory filtering.
    ///   - keysToFetch: The contact fetch request that specifies the search criteria.
    /// - throws: Error information, if an error occurred.
    /// - returns: An array of discovered contacts as ``ContactResult`` objects.
    ///
    public func fetchContacts(
        predicate: NSPredicate,
        keysToFetch: [ContactKeyOptions] = [.vCardRequired]
    ) throws -> [ContactResult] {
        let fetchedKeys = mapOptionsToKeys(keysToFetch)
        let result = try ContactStore.default.unifiedContacts(
            matching: predicate,
            keysToFetch: fetchedKeys
        )
        
        let mappedResponse = result.map({ ContactResult(from: $0) })
        return mappedResponse
    }
    
    // MARK: - Mapping
    
    private func mapOptionsToKeys(_ options: [ContactKeyOptions]) -> [CNKeyDescriptor] {
        var checkedKeys = options
        if checkedKeys.contains(where: { $0 == .vCardRequired }) == false {
            checkedKeys.append(.vCardRequired)
        }
        
        let fetchedKeys = checkedKeys.map({ $0.keyDescriptor() })
        return fetchedKeys
    }
    
    private func compactMappedResults(_ results: [ContactResult], for keys: [ContactKeyOptions]) -> [ContactResult] {
        var updatedResults = results
        
        for key in keys {
            switch key {
            case .fullName, .firstName, .lastName:
                updatedResults.removeAll(where: { $0.name.count == 0 })
            case .phone:
                updatedResults.removeAll(where: { $0.phones.count == 0 })
            case .email:
                updatedResults.removeAll(where: { $0.emails.count == 0 })
            case .postalAddress:
                updatedResults.removeAll(where: { $0.addresses.count == 0 })
            case .thumbnailImage:
                updatedResults.removeAll(where: { $0.thumbnail == nil })
            case .birthday:
                // Many people do not have birthdays saved in their contacts, so we won't filter
                // out contacts if there is no birthday. However if there is a birthday set and the
                // person is younger than 14, we'll remove them from the set.
                
                updatedResults.removeAll(where: {
                    if let setBirthday = $0.birthday,
                       setBirthday.isValidDate(in: Calendar.current),
                       let birthyear = setBirthday.year
                    {
                        let thisYear = Calendar.current.component(.year, from: Date.now)
                        let cutoffYear = thisYear - 14
                        
                        if birthyear > cutoffYear {
                            return true
                        }
                    }
                    
                    return false
                })
            case .vCardRequired:
                break
            }
        }
        
        return updatedResults
    }
    
    // MARK: - Fetch Matches

    /// Fetch contacts matching a name.
    ///
    /// - parameters:
    ///   - name: The name can contain any number of words.
    ///   - keysToFetch: The contact fetch request that specifies the search criteria.
    /// - throws: Error information, if an error occurred.
    /// - returns: An array of discovered contacts as ``ContactResult`` objects.
    ///
    public func fetchContacts(
        matchingName name: String,
        keysToFetch: [ContactKeyOptions] = [.vCardRequired]
    ) throws -> [ContactResult] {
        return try fetchContacts(predicate: CNContact.predicateForContacts(matchingName: name), keysToFetch: keysToFetch)
    }

    /// Fetch contacts matching an email address.
    ///
    /// - parameters:
    ///   - emailAddress: The email address to search for. Do not include a scheme (e.g.,
    ///     "mailto:").
    ///   - keysToFetch: The contact fetch request that specifies the search criteria.
    /// - throws: Error information, if an error occurred.
    /// - returns: An array of discovered contacts as ``ContactResult`` objects.
    ///
    public func fetchContacts(
        matchingEmailAddress emailAddress: String,
        keysToFetch: [ContactKeyOptions] = [.vCardRequired]
    ) throws -> [ContactResult] {
        return try fetchContacts(predicate: CNContact.predicateForContacts(matchingEmailAddress: emailAddress), keysToFetch: keysToFetch)
    }

    /// Fetch contacts matching a phone number.
    ///
    /// - parameters:
    ///   - phoneNumber: A `CNPhoneNumber` representing the phone number to search for. Do
    ///     not include a scheme (e.g., "tel:").
    ///   - keysToFetch: The contact fetch request that specifies the search criteria.
    /// - throws: Error information, if an error occurred.
    /// - returns: An array of discovered contacts as ``ContactResult`` objects.
    ///
    public func fetchContacts(
        matching phoneNumber: CNPhoneNumber,
        keysToFetch: [ContactKeyOptions] = [.vCardRequired]
    ) throws -> [ContactResult] {
        return try fetchContacts(predicate: CNContact.predicateForContacts(matching: phoneNumber), keysToFetch: keysToFetch)
    }

    /// To fetch contacts matching contact identifiers.
    /// - parameters:
    ///   - identifiers: Contact identifiers to be matched.
    ///   - keysToFetch: The contact fetch request that specifies the search criteria.
    /// - throws: Error information, if an error occurred.
    /// - returns: An array of discovered contacts as ``ContactResult`` objects.
    ///
    public func fetchContacts(
        withIdentifiers identifiers: [String],
        keysToFetch: [ContactKeyOptions] = [.vCardRequired]
    ) throws -> [ContactResult] {
        return try fetchContacts(predicate: CNContact.predicateForContacts(withIdentifiers: identifiers), keysToFetch: keysToFetch)
    }

    /// To fetch contacts matching group identifier
    ///
    /// - parameters:
    ///   - groupIdentifier: The group identifier to be matched.
    ///   - keysToFetch: The contact fetch request that specifies the search criteria.
    /// - throws: Error information, if an error occurred.
    /// - returns: An array of discovered contacts as ``ContactResult`` objects.
    ///
    public func fetchContacts(
        withGroupIdentifier groupIdentifier: String,
        keysToFetch: [ContactKeyOptions] = [.vCardRequired]
    ) throws -> [ContactResult] {
        let predicate = CNContact.predicateForContactsInGroup(withIdentifier: groupIdentifier)
        return try fetchContacts(predicate: predicate, keysToFetch: keysToFetch)
    }

    /// find the contacts in the specified container.
    ///
    /// - parameters:
    ///   - containerIdentifier: The container identifier to be matched.
    ///   - keysToFetch: The contact fetch request that specifies the search criteria.
    /// - throws: Error information, if an error occurred.
    /// - returns: An array of discovered contacts as ``ContactResult`` objects.
    ///
    public func fetchContacts(
        withContainerIdentifier containerIdentifier: String,
        keysToFetch: [ContactKeyOptions] = [.vCardRequired]
    ) throws -> [ContactResult] {
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerIdentifier)
        return try fetchContacts(predicate: predicate, keysToFetch: keysToFetch)
    }

    /// Fetch a contact with a given identifier.
    ///
    /// - parameters:
    ///   - identifier: The identifier of the contact to fetch.
    ///   - keysToFetch: The contact fetch request that specifies the search criteria.
    /// - throws: Error information, if an error occurred.
    /// - returns: Contact matching or linked to the identifier
    ///
    public func fetchContact(
        withIdentifier identifier: String,
        keysToFetch: [ContactKeyOptions] = [.vCardRequired]
    ) throws -> ContactResult {
        do {
            let fetchedKeys = mapOptionsToKeys(keysToFetch)
            let result = try ContactStore.default.unifiedContact(
                withIdentifier: identifier,
                keysToFetch: fetchedKeys
            )
            
            let mappedResponse = ContactResult(from: result)
            return mappedResponse
        } catch let error {
            throw error
        }
    }
    
}
