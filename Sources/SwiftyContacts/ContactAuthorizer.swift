//
//  ContactAuthorizer.swift
//  SwiftyContacts
//
//  Created by Sam Spencer on 10/8/22.
//  Copyright © 2022 nenos, llc.
//

@_exported import Contacts
import Foundation

/// Manages authorization for the user's contacts.
///
public actor ContactAuthorizer {
    
    init() {
        
    }
    
    /// Requests access to the user's contacts.
    ///
    /// - throws: Error information, if an error occurred.
    /// - returns: `true` if the user allows access to contacts.
    ///
    public func requestAccess() async throws -> Bool {
        return try await ContactStore.default.requestAccess(for: .contacts)
    }

    /// Indicates the current authorization status to access contact data.
    ///
    /// - returns: The authorization status for the user's `contacts`.
    ///
    public func authorizationStatus() -> CNAuthorizationStatus {
        return CNContactStore.authorizationStatus(for: .contacts)
    }

    
}
