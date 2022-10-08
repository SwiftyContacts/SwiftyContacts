//
//  ContactKeys.swift
//  SwiftyContacts
//
//  Created by Sam Spencer on 10/8/22.
//  Copyright © 2022 nenos, llc. All rights reserved.
//

@_exported import Contacts
import Foundation

/// Available contact fetch keys.
/// 
public enum ContactKeyOptions: CaseIterable {
    case fullName
    case firstName
    case lastName
    case phone
    case email
    case postalAddress
    case thumbnailImage
    case birthday
    case vCardRequired
    
    internal func keyDescriptor() -> CNKeyDescriptor {
        switch self {
        case .fullName:         return CNContactFormatter.descriptorForRequiredKeys(for: .fullName)
        case .firstName:        return CNContactGivenNameKey as CNKeyDescriptor
        case .lastName:         return CNContactFamilyNameKey as CNKeyDescriptor
        case .phone:            return CNContactPhoneNumbersKey as CNKeyDescriptor
        case .email:            return CNContactEmailAddressesKey as CNKeyDescriptor
        case .birthday:         return CNContactBirthdayKey as CNKeyDescriptor
        case .postalAddress:    return CNContactPhoneNumbersKey as CNKeyDescriptor
        case .thumbnailImage:   return CNContactThumbnailImageDataKey as CNKeyDescriptor
        case .vCardRequired:    return CNContactVCardSerialization.descriptorForRequiredKeys()
        }
    }
    
}
