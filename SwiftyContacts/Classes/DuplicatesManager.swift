//
//  DuplicatesManager.swift
//  PhoneBook
//
//  Created by WebMobTech-3 on 21/08/17.
//  Copyright © 2017 WMT. All rights reserved.
//

import Foundation
import Contacts

class DuplicatesManager: NSObject {
    
    var namePrefix: [String]!
    var givenName: [String]!
    var middleName: [String]!
    var familyName: [String]!
    var previousFamilyName: [String]!
    var nameSuffix: [String]!
    var nickname: [String]!
    var organizationName: [String]!
    var departmentName: [String]!
    var jobTitle: [String]!
    var phoneNumbers: [CNPhoneNumber]!
    var emailAddresses: [NSString]!
    var postalAddresses: [CNPostalAddress]!
    var urlAddresses: [NSString]!
    var contactRelations: [CNContactRelation]!
    var socialProfiles: [CNSocialProfile]!
    var instantMessageAddresses: [CNInstantMessageAddress]!
    
    var newContact : CNMutableContact!
    
    
    init(DuplicateContactsArray arrDuplicates : [CNContact]) {
        
        namePrefix = [String]()
        givenName = [String]()
        middleName = [String]()
        familyName = [String]()
        previousFamilyName = [String]()
        nameSuffix = [String]()
        nickname = [String]()
        organizationName = [String]()
        departmentName = [String]()
        jobTitle = [String]()
        phoneNumbers = [CNPhoneNumber]()
        emailAddresses = [NSString]()
        postalAddresses = [CNPostalAddress]()
        urlAddresses = [NSString]()
        contactRelations = [CNContactRelation]()
        socialProfiles = [CNSocialProfile]()
        instantMessageAddresses = [CNInstantMessageAddress]()
        
        for items in arrDuplicates {
            
            namePrefix.append(items.namePrefix)
            givenName.append(items.givenName)
            middleName.append(items.middleName)
            familyName.append(items.familyName)
            previousFamilyName.append(items.previousFamilyName)
            nameSuffix.append(items.nameSuffix)
            nickname.append(items.nickname)
            organizationName.append(items.organizationName)
            departmentName.append(items.departmentName)
            jobTitle.append(items.jobTitle)
            
            for number in items.phoneNumbers {
                phoneNumbers.append(number.value)
            }
            for email in items.emailAddresses {
                emailAddresses.append(email.value)
            }
            for postal in items.postalAddresses {
                postalAddresses.append(postal.value)
            }
            for url in items.urlAddresses {
                urlAddresses.append(url.value)
            }
            for relation in items.contactRelations {
                contactRelations.append(relation.value)
            }
            for social in items.socialProfiles {
                socialProfiles.append(social.value)
            }
            for message in items.instantMessageAddresses {
                instantMessageAddresses.append(message.value)
            }
        }
        
        newContact = CNMutableContact()
        newContact.namePrefix = Array(Set(namePrefix))[0]
        newContact.givenName = Array(Set(givenName))[0]
        newContact.middleName = Array(Set(middleName))[0]
        newContact.familyName = Array(Set(familyName))[0]
        newContact.previousFamilyName = Array(Set(previousFamilyName))[0]
        newContact.nameSuffix = Array(Set(nameSuffix))[0]
        newContact.nickname = Array(Set(nickname))[0]
        newContact.organizationName = Array(Set(namePrefix))[0]
        newContact.departmentName = Array(Set(namePrefix))[0]
        newContact.jobTitle = Array(Set(namePrefix))[0]
        
        for item in Array(Set(phoneNumbers)) {
            newContact.phoneNumbers.append(CNLabeledValue(label: CNLabelHome, value: item))
        }
        for item in Array(Set(emailAddresses)) {
            newContact.emailAddresses.append(CNLabeledValue(label: CNLabelHome, value: item))
        }
        for item in Array(Set(postalAddresses)) {
            newContact.postalAddresses.append(CNLabeledValue(label: CNLabelHome, value: item))
        }
        for item in Array(Set(urlAddresses)) {
            newContact.urlAddresses.append(CNLabeledValue(label: CNLabelHome, value: item))
        }
        for item in Array(Set(contactRelations)) {
            newContact.contactRelations.append(CNLabeledValue(label: CNLabelHome, value: item))
        }
        for item in Array(Set(socialProfiles)) {
            newContact.socialProfiles.append(CNLabeledValue(label: CNLabelHome, value: item))
        }
        for item in Array(Set(instantMessageAddresses)) {
            newContact.instantMessageAddresses.append(CNLabeledValue(label: CNLabelHome, value: item))
        }
        
    }
    
    deinit {
        print("Merge Contacts Dinit Called")
        namePrefix = nil
        givenName = nil
        middleName = nil
        familyName = nil
        previousFamilyName = nil
        nameSuffix = nil
        nickname = nil
        organizationName = nil
        departmentName = nil
        jobTitle = nil
        phoneNumbers = nil
        emailAddresses = nil
        postalAddresses = nil
        urlAddresses = nil
        contactRelations = nil
        socialProfiles = nil
        instantMessageAddresses = nil
        newContact = nil
    }
    
}
