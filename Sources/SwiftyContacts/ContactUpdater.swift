//
//  ContactUpdater.swift
//  SwiftyContacts
//
//  Created by Sam Spencer on 10/8/22.
//  Copyright © 2022 nenos, llc.
//

@_exported import Contacts
import Foundation

/// Updates the user's contacts.
///
public actor ContactUpdater {
    
    init() {
        
    }
    
    // MARK: - Adding
    
    /// Adds the specified contact to the contact store.
    ///
    /// - parameters:
    ///   - contact: The new contact to add.
    ///   - identifier: The container identifier to add the new contact to. Set to `nil` for
    ///     the default container.
    /// - throws: Error information, if an error occurred.
    ///
    public func addContact(_ contact: CNMutableContact, toContainerWithIdentifier identifier: String? = nil) throws {
        let request = CNSaveRequest()
        request.add(contact, toContainerWithIdentifier: identifier)
        try ContactStore.default.execute(request)
    }
    
    /// Adds the specified contact to the contact store.
    ///
    /// - parameters:
    ///   - contact: The new contact to add.
    ///   - identifier: The container identifier to add the new contact to. Set to nil for
    ///     the default container.
    /// - throws: Error information, if an error occurred.
    ///
    public func addContact(_ contact: CNContact, toContainerWithIdentifier identifier: String? = nil) throws {
        guard let contact = contact.mutableCopy() as? CNMutableContact else {
            return
        }
        try addContact(contact, toContainerWithIdentifier: identifier)
    }
    
    // MARK: - Updating
    
    /// Updates an existing contact in the contact store.
    ///
    /// - parameters:
    ///   - contact: The contact to update.
    /// - throws: Error information, if an error occurred.
    ///
    public func updateContact(_ contact: CNMutableContact) throws {
        let request = CNSaveRequest()
        request.update(contact)
        try ContactStore.default.execute(request)
    }
    
    /// Updates an existing contact in the contact store.
    ///
    /// - parameters:
    ///   - contact: The contact to update.
    /// - throws: Error information, if an error occurred.
    ///
    public func updateContact(_ contact: CNContact) throws {
        guard let contact = contact.mutableCopy() as? CNMutableContact else {
            return
        }
        try updateContact(contact)
    }
    
    // MARK: - Deleting
    
    /// Deletes a contact from the contact store.
    ///
    /// - Parameter contact: Contact to be delete.
    /// - throws: Error information, if an error occurred.
    ///
    public func deleteContact(_ contact: CNMutableContact) throws {
        let request = CNSaveRequest()
        request.delete(contact)
        try ContactStore.default.execute(request)
    }
    
    /// Deletes a contact from the contact store.
    ///
    /// - Parameter contact: Contact to be delete.
    /// - throws: Error information, if an error occurred.
    ///
    public func deleteContact(_ contact: CNContact) throws {
        guard let contact = contact.mutableCopy() as? CNMutableContact else {
            return
        }
        try deleteContact(contact)
    }
    
}
