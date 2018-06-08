//
// SwiftyContacts
//
// Copyright (c) 2017 Satish Babariya <satish.babariya@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Contacts
import Foundation
import RxSwift
import RxCocoa

#if os(OSX)
    import Cocoa
    import CoreTelephony
#elseif os(iOS)
    import CoreTelephony
    import UIKit
#endif

// PRAGMA MARK: - Contacts Authorization -

/// Returns the current authorization status to access the contact data.
public var rx_authorizationStatus: Observable<CNAuthorizationStatus> {
    return Observable.create({ (observer) -> Disposable in
        observer.onNext(CNContactStore.authorizationStatus(for: .contacts))
        observer.onCompleted()
        return Disposables.create()
    })
}

/// Requests access to the user's contacts
///
/// - Returns: Boolean value
public func rx_requestAccess() -> Observable<Bool> {
    return Observable.create({ (observer) -> Disposable in
        CNContactStore().requestAccess(for: .contacts, completionHandler: { bool, error in
            if let error = error {
                observer.onError(error)
            } else {
                observer.onNext(bool)
                observer.onCompleted()
            }
        })
        return Disposables.create()
    })
}

// PRAGMA MARK: - Fetch Contacts -

/// Fetching Contacts from phone
///
/// - Returns: Array of CNContact
public func rx_fetchContacts() -> Observable<[CNContact]> {
    return Observable.create({ (observer) -> Disposable in
        let contactStore: CNContactStore = CNContactStore()
        var contacts: [CNContact] = [CNContact]()
        let fetchRequest: CNContactFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
        do {
            try contactStore.enumerateContacts(with: fetchRequest, usingBlock: {
                contact, _ in
                contacts.append(contact)

            })
            observer.onNext(contacts)
            observer.onCompleted()

        } catch {
            observer.onError(error)
        }
        return Disposables.create()
    })

}

@available(iOS 10.0, *)

/// Fetching Contacts from phone with specific sort order.
///
/// - Parameter sortOrder: CNContactSortOrder
/// - Returns: Arry of CNContact
public func rx_fetchContacts(ContactsSortorder sortOrder: CNContactSortOrder) -> Observable<[CNContact]> {
    return Observable.create({ (observer) -> Disposable in
        let contactStore: CNContactStore = CNContactStore()
        var contacts: [CNContact] = [CNContact]()
        let fetchRequest: CNContactFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
        fetchRequest.unifyResults = true
        fetchRequest.sortOrder = sortOrder
        do {
            try contactStore.enumerateContacts(with: fetchRequest, usingBlock: {
                contact, _ in
                contacts.append(contact)

            })
            observer.onNext(contacts)
            observer.onCompleted()

        } catch {
            observer.onError(error)
        }
        return Disposables.create()
    })

}

// PRAGMA MARK: - Search Contacts -

/// Search Contact from phone
///
/// - Parameter string: Search String.
/// - Returns: Array of CNContact
public func rx_searchContact(SearchString string: String) -> Observable<[CNContact]> {
    return Observable.create({ (observer) -> Disposable in
        let contactStore: CNContactStore = CNContactStore()
        var contacts: [CNContact] = [CNContact]()
        let predicate: NSPredicate = CNContact.predicateForContacts(matchingName: string)
        do {
            contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
            observer.onNext(contacts)
            observer.onCompleted()

        } catch {
            observer.onError(error)
        }
        return Disposables.create()
    })

}

/// Get CNContact From Array of Identifiers
///
/// - Parameter identifiers: Array of Identifiers
/// - Returns: Array of CNContact
public func rx_ContactsFromIDs(SIdentifires identifiers: [String]) -> Observable<[CNContact]> {
    return Observable.create({ (observer) -> Disposable in
        let contactStore: CNContactStore = CNContactStore()
        var contacts: [CNContact] = [CNContact]()
        let predicate: NSPredicate = CNContact.predicateForContacts(withIdentifiers: identifiers)
        do {
            contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
            observer.onNext(contacts)
            observer.onCompleted()

        } catch {
            observer.onError(error)
        }
        return Disposables.create()
    })

}

// PRAGMA MARK: - Contact Operations

#if os(iOS) || os(OSX)

    /// Add new Contact.
    ///
    /// - Parameter mutContact: A mutable value object for the contact properties, such as the first name and the phone number of a contact.
    /// - Returns: Returns error or Completion
    public func rx_addContact(Contact mutContact: CNMutableContact) -> Observable<()> {
        return Observable.create({ (observer) -> Disposable in
            let store: CNContactStore = CNContactStore()
            let request: CNSaveRequest = CNSaveRequest()
            request.add(mutContact, toContainerWithIdentifier: nil)
            do {
                try store.execute(request)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        })
    }

    /// Adds the specified contact to the contact store.
    ///
    /// - Parameters:
    ///   - mutContact: A mutable value object for the contact properties, such as the first name and the phone number of a contact.
    ///   - identifier: The unique identifier for a contacts container on the device.
    /// - Returns: Sucess or error
    public func rx_addContactInContainer(Contact mutContact: CNMutableContact, Container_Identifier identifier: String) -> Observable<()> {
        return Observable.create({ (observer) -> Disposable in
            let store: CNContactStore = CNContactStore()
            let request: CNSaveRequest = CNSaveRequest()
            request.add(mutContact, toContainerWithIdentifier: identifier)
            do {
                try store.execute(request)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        })
    }

    /// Updates an existing contact in the contact store.
    ///
    /// - Parameter mutContact: A mutable value object for the contact properties, such as the first name and the phone number of a contact.
    /// - Returns: Sucess or error
    public func rx_updateContact(Contact mutContact: CNMutableContact) -> Observable<()> {
        return Observable.create({ (observer) -> Disposable in
            let store: CNContactStore = CNContactStore()
            let request: CNSaveRequest = CNSaveRequest()
            request.update(mutContact)
            do {
                try store.execute(request)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        })
    }

    /// Deletes a contact from the contact store.
    ///
    /// - Parameter mutContact: A mutable value object for the contact properties, such as the first name and the phone number of a contact.
    /// - Returns: Sucess or error
    public func rx_deleteContact(Contact mutContact: CNMutableContact) -> Observable<()> {
        return Observable.create({ (observer) -> Disposable in
            let store: CNContactStore = CNContactStore()
            let request: CNSaveRequest = CNSaveRequest()
            request.delete(mutContact)
            do {
                try store.execute(request)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        })
    }

#endif

// PRAGMA MARK: - Groups Methods -

/// etch list of Groups from the contact store.
///
/// - Returns: Array of CNGroup
public func rx_fetchGroups() -> Observable<[CNGroup]> {
    return Observable.create({ (observer) -> Disposable in
        let store: CNContactStore = CNContactStore()
        do {
            let groups: [CNGroup] = try store.groups(matching: nil)
            observer.onNext(groups)
            observer.onCompleted()
        } catch {
            observer.onError(error)
        }
        return Disposables.create()
    })
}

#if os(iOS) || os(OSX)

    /// Adds a group to the contact store.
    ///
    /// - Parameter name: Name of the group.
    /// - Returns: Sucess or error
    public func rx_createGroup(Group_Name name: String) -> Observable<()> {
        return Observable.create({ (observer) -> Disposable in
            let store: CNContactStore = CNContactStore()
            let request: CNSaveRequest = CNSaveRequest()
            let group: CNMutableGroup = CNMutableGroup()
            group.name = name
            request.add(group, toContainerWithIdentifier: nil)
            do {
                try store.execute(request)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        })
    }

    /// Adds a group to the contact store.
    ///
    /// - Parameters:
    ///   - name: Name of the group.
    ///   - identifire: The identifier of the container to add the new group. To add the new group to the default container, set identifier to nil.
    /// - Returns: Sucess of error.
    public func rx_createGroupInContainer(Group_Name name: String, ContainerIdentifire identifire: String) -> Observable<()> {
        return Observable.create({ (observer) -> Disposable in
            let store: CNContactStore = CNContactStore()
            let request: CNSaveRequest = CNSaveRequest()
            let group: CNMutableGroup = CNMutableGroup()
            group.name = name
            request.add(group, toContainerWithIdentifier: identifire)
            do {
                try store.execute(request)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        })
    }

    /// Remove an existing group in the contact store.
    ///
    /// - Parameter group: The group to delete.
    /// - Returns: Sucess or error
    public func rx_removeGroup(Group group: CNGroup) -> Observable<()> {
        return Observable.create({ (observer) -> Disposable in
            let store: CNContactStore = CNContactStore()
            let request: CNSaveRequest = CNSaveRequest()
            if let mutableGroup: CNMutableGroup = group.mutableCopy() as? CNMutableGroup {
                request.delete(mutableGroup)
            }
            do {
                try store.execute(request)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        })
    }

    /// Update an existing group in the contact store.
    ///
    /// - Parameters:
    ///   - group: The group to update.
    ///   - name: new name of the group
    /// - Returns: Sucess or error.
    public func rx_updateGroup(Group group: CNGroup, New_Group_Name name: String) -> Observable<()> {
        return Observable.create({ (observer) -> Disposable in
            let store: CNContactStore = CNContactStore()
            let request: CNSaveRequest = CNSaveRequest()
            if let mutableGroup: CNMutableGroup = group.mutableCopy() as? CNMutableGroup {
                mutableGroup.name = name
                request.update(mutableGroup)
            }
            do {
                try store.execute(request)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        })
    }

    /// Adds a contact as a member of a group.
    ///
    /// - Parameters:
    ///   - group: The group to add member in.
    ///   - contact: The contact that want to add in group
    /// - Returns: Sucess or error
    public func rx_addContactToGroup(Group group: CNGroup, Contact contact: CNContact) -> Observable<()> {
        return Observable.create({ (observer) -> Disposable in
            let store: CNContactStore = CNContactStore()
            let request: CNSaveRequest = CNSaveRequest()
            request.addMember(contact, to: group)
            do {
                try store.execute(request)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        })
    }

    /// Remove a contact as a member of a group.
    ///
    /// - Parameters:
    ///   - group: The group to Remove member from.
    ///   - contact: The contact that want to remove from group
    /// - Returns: Sucess or error
    public func rx_removeContactFromGroup(Group group: CNGroup, Contact contact: CNContact) -> Observable<()> {
        return Observable.create({ (observer) -> Disposable in
            let store: CNContactStore = CNContactStore()
            let request: CNSaveRequest = CNSaveRequest()
            request.removeMember(contact, from: group)
            do {
                try store.execute(request)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        })
    }

#endif

/// Fetch all contacts in a group.
///
/// - Parameter group: The group.
/// - Returns: Array or CNContact or error
public func rx_fetchContactsInGorup(Group group: CNGroup) -> Observable<[CNContact]> {
    return Observable.create({ (observer) -> Disposable in
        let contactStore: CNContactStore = CNContactStore()
        var contacts: [CNContact] = [CNContact]()
        let predicate: NSPredicate = CNContact.predicateForContactsInGroup(withIdentifier: group.name)
        let keysToFetch: [String] = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactOrganizationNameKey, CNContactPhoneNumbersKey, CNContactUrlAddressesKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey, CNContactNoteKey, CNContactImageDataKey]
        do {
            contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as [CNKeyDescriptor])
            observer.onNext(contacts)
            observer.onCompleted()

        } catch {
            observer.onError(error)
        }
        return Disposables.create()
    })

}

// PRAGMA MARK: - Converter Methods -

/// Convert [CNContacts] TO CSV
///
/// - Parameter contacts: Array of contacts.
/// - Returns: Data object
public func rx_contactsToVCardConverter(contacts: [CNContact]) -> Observable<Data> {
    return Observable.create({ (observer) -> Disposable in
        var vcardFromContacts: Data = Data()
        do {
            try vcardFromContacts = CNContactVCardSerialization.data(with: contacts)
            observer.onNext(vcardFromContacts)
            observer.onCompleted()
        } catch {
            observer.onError(error)
        }
        return Disposables.create()
    })

}

/// Convert CSV TO [CNContact]
///
/// - Parameter data: Data having contacts.
/// - Returns: Returns Either Array of CNContacts or Error.
public func rx_VCardToContactConverter(data: Data) -> Observable<[CNContact]> {
    return Observable.create({ (observer) -> Disposable in
        var contacts: [CNContact] = [CNContact]()
        do {
            try contacts = CNContactVCardSerialization.contacts(with: data) as [CNContact]
            observer.onNext(contacts)
            observer.onCompleted()
        } catch {
            observer.onError(error)
        }
        return Disposables.create()
    })

}

/// Convert Array of CNContacts to Data using NSKeyedArchiver
///
/// - Parameter contacts: Array of CNContacts
/// - Returns: Data
public func rx_archiveContacts(contacts: [CNContact]) -> Observable<Data> {
    return Observable.create({ (observer) -> Disposable in
        observer.onNext(NSKeyedArchiver.archivedData(withRootObject: contacts))
        observer.onCompleted()
        return Disposables.create()
    })

}

/// Convert Data to Array of CNContacts using NSKeyedArchiver
///
/// - Parameter data: Data contains CNContacts
/// - Returns: Array of CNContacts
public func rx_unarchiveConverter(data: Data) -> Observable<[CNContact]> {
    return Observable.create({ (observer) -> Disposable in
        let decodedData: Any? = NSKeyedUnarchiver.unarchiveObject(with: data)
        if let contacts: [CNContact] = decodedData as? [CNContact] {
            observer.onNext(contacts)
            observer.onCompleted()
        }
        return Disposables.create()
    })

}

// PRAGMA MARK: - CoreTelephonyCheck

#if os(iOS) || os(OSX)

    /// Convert CNPhoneNumber To digits
    ///
    /// - Parameter CNPhoneNumber: Phone number.
    /// - Returns: String
    public func rx_CNPhoneNumberToString(CNPhoneNumber: CNPhoneNumber) -> Observable<String> {
        return Observable.create({ (observer) -> Disposable in
            if let result: String = CNPhoneNumber.value(forKey: "digits") as? String {
                observer.onNext(result)
                observer.onCompleted()
            }
            return Disposables.create()
        })
    }

#endif

#if os(OSX)

    /// Make call to given number.
    ///
    /// - Parameter CNPhoneNumber: Phone Number
    public func makeCall(CNPhoneNumber: CNPhoneNumber) {
        if let phoneNumber: String = CNPhoneNumber.value(forKey: "digits") as? String {
            guard let url: URL = URL(string: "tel://" + "\(phoneNumber)") else {
                print("Error in Making Call")
                return
            }
            NSWorkspace.shared.open(url)
        }
    }

#elseif os(iOS)

    /// Check if iOS Device supports phone calls
    public var rx_isCapableToCall: Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            observer.onNext(UIApplication.shared.canOpenURL(NSURL(string: "tel://")! as URL) ? (CTTelephonyNetworkInfo().subscriberCellularProvider?.mobileNetworkCode != nil ? true : false) : false)
            observer.onCompleted()
            return Disposables.create()
        })
    }

    /// Check if iOS Device supports sms
    public var rx_isCapableToSMS: Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            observer.onNext(UIApplication.shared.canOpenURL(NSURL(string: "sms:")! as URL))
            observer.onCompleted()
            return Disposables.create()
        })
    }

    /// Make call to given number.
    ///
    /// - Parameter CNPhoneNumber: Phone Number
    public func makeCall(CNPhoneNumber: CNPhoneNumber) {
        if let phoneNumber: String = CNPhoneNumber.value(forKey: "digits") as? String {
            guard let url: URL = URL(string: "tel://" + "\(phoneNumber)") else {
                print("Error in Making Call")
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
    }

#endif

/**
 Represents a disposable that does nothing on disposal.

 Nop = No Operation
 */
public struct NopDisposable: Disposable {

    /**
     Singleton instance of `NopDisposable`.
     */
    public static let instance: Disposable = NopDisposable()

    init() {

    }

    /**
     Does nothing.
     */
    public func dispose() {
    }
}



// MARK: - CNContactStore
extension Reactive where Base: CNContactStore {
    
    // MARK: - Privacy Access
    
    /// Requests access to the user's contacts.
    ///
    /// - Parameter entityType: Set to CNEntityTypeContacts.
    /// - Returns: Set granted to true if the user allows access and error is nil.
    public func requestAccess(for entityType: CNEntityType) -> Observable<Bool> {
        return Observable.create { observer in
            self.base.requestAccess(for: entityType, completionHandler: { bool, error in
                if let error = error {
                    observer.onError(error)
                }
                observer.onNext(bool)
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    // MARK: - Fetching Unified Contacts
    
    /// Fetches all unified contacts matching the specified predicate.
    ///
    /// - Parameters:
    ///   - predicate: The predicate to match against.
    ///   - keys: The properties to fetch in the returned CNContact objects. You should fetch only the properties that you plan to use. Note that you can combine contact keys and contact key descriptors.
    /// - Returns: An array of CNContact objects matching the predicate.
    public func unifiedContacts(matching predicate: NSPredicate,
                                keysToFetch keys: [CNKeyDescriptor]) -> Observable<[CNContact]> {
        return Observable.create { observer in
            do {
                observer.onNext(try self.base.unifiedContacts(matching: predicate, keysToFetch: keys))
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    /// Fetches a unified contact for the specified contact identifier.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of the contact to fetch.
    ///   - keys:     The properties to fetch in the returned CNContact object.
    /// - Returns: A unified contact matching or linked to the identifier.
    public func unifiedContact(withIdentifier identifier: String,
                               keysToFetch keys: [CNKeyDescriptor]) -> Observable<CNContact> {
        return Observable.create { observer in
            do {
                observer.onNext(try self.base.unifiedContact(withIdentifier: identifier, keysToFetch: keys))
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    // MARK: - Fetching and Saving
    
    /// Fetches all groups matching the specified predicate.
    ///
    /// - Parameter predicate: The predicate to use to fetch the matching groups. Set predicate to nil to match all groups.
    /// - Returns: An array of CNGroup objects that match the predicate.
    public func groups(matching predicate: NSPredicate?) -> Observable<[CNGroup]> {
        return Observable.create { observer in
            do {
                observer.onNext(try self.base.groups(matching: predicate))
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    /// Fetches all containers matching the specified predicate.
    ///
    /// - Parameter predicate: The predicate to use to fetch matching containers. Set this property to nil to match all containers.
    /// - Returns: An array of CNContainer objects that match the predicate.
    public func containers(matching predicate: NSPredicate?) -> Observable<[CNContainer]> {
        return Observable.create { observer in
            do {
                observer.onNext(try self.base.containers(matching: predicate))
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    /// Returns a Boolean value that indicates whether the enumeration of all contacts matching a contact fetch request executed successfully.
    ///
    /// - Parameter fetchRequest: The contact fetch request that specifies the search criteria.
    /// - Returns: true if enumeration of all contacts matching a contact fetch request executes successfully; otherwise, false
    public func enumerateContacts(with fetchRequest: CNContactFetchRequest) -> Observable<(CNContact, UnsafeMutablePointer<ObjCBool>)> {
        return Observable.create { observer in
            do {
                try self.base.enumerateContacts(with: fetchRequest, usingBlock: { contact, pointer in
                    observer.onNext((contact, pointer))
                    observer.onCompleted()
                })
                
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    #if os(iOS) || os(OSX)
    
    /// Executes a save request and returns success or failure.
    ///
    /// - Parameter saveRequest: The save request to execute.
    /// - Returns: true if the save request executes successfully; otherwise, false.
    public func execute(_ saveRequest: CNSaveRequest) -> Observable<Void> {
    return Observable.create { observer in
    do {
    observer.onNext(try self.base.execute(saveRequest))
    observer.onCompleted()
    } catch {
    observer.onError(error)
    }
    return Disposables.create()
    }
    }
    
    #endif
    
    /// Posted notifications when changes occur in another CNContactStore.
    ///
    /// - Returns: Notification Object
    public func didChange() -> Observable<Notification> {
        return NotificationCenter.default.rx.notification(NSNotification.Name.CNContactStoreDidChange)
    }
    
}


