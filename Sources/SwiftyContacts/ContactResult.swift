//
//  ContactResult.swift
//  SwiftyContacts
//
//  Created by Sam Spencer on 10/8/22.
//  Copyright © 2022 nenos, llc. All rights reserved.
//

@_exported import Contacts
import Foundation

/// A simplified representation of `CNContact` objects.
///
/// A ``ContactFetcher`` fetch request will return `ContactResult` objects.
///
/// - note: This type is thread-safe and can be passed between threads.
/// - important: A `ContactResult` should not be instantiated manually, instead, you
///   should use the provided object from a fetch request.
///
public struct ContactResult: Sendable {
    
    public let name: String
    public let phones: [String]
    public let emails: [String]
    public let addresses: [String]
    public let birthday: DateComponents?
    public let thumbnail: Data?
    
    internal init(from contactResponse: CNContact) {
        name = contactResponse.givenName + " " + contactResponse.familyName
        
        var possiblePhoneNumbers: [String] = []
        for phone in contactResponse.phoneNumbers {
            possiblePhoneNumbers.append(phone.value.stringValue)
        }
        phones = possiblePhoneNumbers
        
        var possibleEmails: [String] = []
        for email in contactResponse.emailAddresses {
            possibleEmails.append(email.value as String)
        }
        emails = possibleEmails
        
        var possibleAddresses: [String] = []
        for address in contactResponse.postalAddresses {
            let street = address.value.street
            let city = address.value.city
            let state = address.value.state
            let country = address.value.country
            let postalCode = address.value.postalCode
            let merged = street + ", " + city + ", " + state + ", " + country + " " + postalCode
            possibleAddresses.append(merged)
        }
        addresses = possibleAddresses
        
        birthday = contactResponse.birthday
        thumbnail = contactResponse.thumbnailImageData
    }
    
}
