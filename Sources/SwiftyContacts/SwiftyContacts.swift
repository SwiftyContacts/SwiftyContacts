import Foundation
import Contacts

#if os(OSX)
import Cocoa
import CoreTelephony
#elseif os(iOS)
import UIKit
import CoreTelephony
#endif

// PRAGMA MARK: - Contacts Authorization -

/// Requests access to the user's contacts
///
/// - Parameter requestGranted: Result as Bool
public func requestAccess(_ requestGranted: @escaping (Bool) -> ()) {
    CNContactStore().requestAccess(for: .contacts) { grandted, _ in
        requestGranted(grandted)
    }
}

/// Returns the current authorization status to access the contact data.
///
/// - Parameter requestStatus: Result as CNAuthorizationStatus
public func authorizationStatus(_ requestStatus: @escaping (CNAuthorizationStatus) -> ()) {
    requestStatus(CNContactStore.authorizationStatus(for: .contacts))
}

// PRAGMA MARK: - Fetch Contacts -

/// Fetching Contacts from phone
///
/// - Parameter completionHandler: Returns Either [CNContact] or Error.
public func fetchContacts(completionHandler: @escaping (_ result: Result<[CNContact], Error>) -> ()) {
    
    let contactStore: CNContactStore = CNContactStore()
    var contacts: [CNContact] = [CNContact]()
    let fetchRequest: CNContactFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
    do {
        try contactStore.enumerateContacts(with: fetchRequest, usingBlock: {
            contact, _ in
            contacts.append(contact) })
        completionHandler(.success(contacts))
    } catch {
        completionHandler(.failure(error))
    }
}

/// Fetching Contacts from phone with specific sort order.
///
/// - Parameters:
///   - sortOrder: To return contacts in a specific sort order.
///   - completionHandler: Result Handler
@available(iOS 10.0, *)
public func fetchContacts(ContactsSortorder sortOrder: CNContactSortOrder, completionHandler: @escaping (_ result: Result<[CNContact], Error>) -> ()) {
    
    let contactStore: CNContactStore = CNContactStore()
    var contacts: [CNContact] = [CNContact]()
    let fetchRequest: CNContactFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
    fetchRequest.unifyResults = true
    fetchRequest.sortOrder = sortOrder
    do {
        try contactStore.enumerateContacts(with: fetchRequest, usingBlock: {
            contact, _ in
            contacts.append(contact) })
        completionHandler(.success(contacts))
    } catch {
        completionHandler(.failure(error))
    }
}


/// Fetching Contacts from phone
/// - parameter completionHandler: Returns Either [CNContact] or Error.
public func fetchContactsOnBackgroundThread(completionHandler: @escaping (_ result: Result<[CNContact], Error>) -> ()) {
    
    DispatchQueue.global(qos: .userInitiated).async(execute: { () -> () in
        let fetchRequest: CNContactFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
        var contacts = [CNContact]()
        CNContact.localizedString(forKey: CNLabelPhoneNumberiPhone)
        if #available(iOS 10.0, *) {
            fetchRequest.mutableObjects = false
        } else {
            // Fallback on earlier versions
        }
        fetchRequest.unifyResults = true
        fetchRequest.sortOrder = .userDefault
        do {
            try CNContactStore().enumerateContacts(with: fetchRequest) { (contact, _) -> () in
                contacts.append(contact)
            }
            DispatchQueue.main.async(execute: { () -> () in
                 completionHandler(.success(contacts))
            })
        } catch let error as NSError {
           completionHandler(.failure(error))
        }
        
    })
    
}

// PRAGMA MARK: - Search Contacts -

/// Search Contact from phone
/// - parameter string: Search String.
/// - parameter completionHandler: Returns Either [CNContact] or Error.
public func searchContact(SearchString string: String, completionHandler: @escaping (_ result: Result<[CNContact], Error>) -> ()) {
    
    let contactStore: CNContactStore = CNContactStore()
    var contacts: [CNContact] = [CNContact]()
    let predicate: NSPredicate = CNContact.predicateForContacts(matchingName: string)
    do {
        contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
        completionHandler(.success(contacts))
    } catch {
        completionHandler(.failure(error))
    }
}

// Get CNContact From Identifier
/// Get CNContact From Identifier
/// - parameter identifier: A value that uniquely identifies a contact on the device.
/// - parameter completionHandler: Returns Either CNContact or Error.
public func getContactFromID(Identifires identifiers: [String], completionHandler: @escaping (_ result: Result<[CNContact], Error>) -> ()) {
    
    let contactStore: CNContactStore = CNContactStore()
    var contacts: [CNContact] = [CNContact]()
    let predicate: NSPredicate = CNContact.predicateForContacts(withIdentifiers: identifiers)
    do {
        contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
        completionHandler(.success(contacts))
    } catch {
        completionHandler(.failure(error))
    }
}

// PRAGMA MARK: - Contact Operations

// Add Contact
/// Add new Contact.
/// - parameter mutContact: A mutable value object for the contact properties, such as the first name and the phone number of a contact.
/// - parameter completionHandler: Returns Either Bool or Error.
#if os(iOS) || os(OSX)
public func addContact(Contact mutContact: CNMutableContact, completionHandler: @escaping (_ result: Result<Bool, Error>) -> ()) {
    let store: CNContactStore = CNContactStore()
    let request: CNSaveRequest = CNSaveRequest()
    request.add(mutContact, toContainerWithIdentifier: nil)
    do {
        try store.execute(request)
        completionHandler(.success(true))
    } catch {
       completionHandler(.failure(error))
    }
}
#endif

/// Adds the specified contact to the contact store.
/// - parameter mutContact: A mutable value object for the contact properties, such as the first name and the phone number of a contact.
/// - parameter identifier: The unique identifier for a contacts container on the device.
/// - parameter completionHandler: Returns Either Bool or Error.
#if os(iOS) || os(OSX)
public func addContactInContainer(Contact mutContact: CNMutableContact, Container_Identifier identifier: String, completionHandler: @escaping (_ result: Result<Bool, Error>) -> ()) {
    let store: CNContactStore = CNContactStore()
    let request: CNSaveRequest = CNSaveRequest()
    request.add(mutContact, toContainerWithIdentifier: identifier)
    do {
        try store.execute(request)
        completionHandler(.success(true))
    } catch {
        completionHandler(.failure(error))
    }
}

// Update Contact
/// Updates an existing contact in the contact store.
/// - parameter mutContact: A mutable value object for the contact properties, such as the first name and the phone number of a contact.
/// - parameter completionHandler: Returns Either CNContact or Error.
public func updateContact(Contact mutContact: CNMutableContact, completionHandler: @escaping (_ result: Result<Bool, Error>) -> ()) {
    let store: CNContactStore = CNContactStore()
    let request: CNSaveRequest = CNSaveRequest()
    request.update(mutContact)
    do {
        try store.execute(request)
        completionHandler(.success(true))
    } catch {
        completionHandler(.failure(error))
    }
}

// Delete Contact
/// Deletes a contact from the contact store.
/// - parameter mutContact: A mutable value object for the contact properties, such as the first name and the phone number of a contact.
/// - parameter completionHandler: Returns Either CNContact or Error.
public func deleteContact(Contact mutContact: CNMutableContact, completionHandler: @escaping (_ result: Result<Bool, Error>) -> ()) {
    let store: CNContactStore = CNContactStore()
    let request: CNSaveRequest = CNSaveRequest()
    request.delete(mutContact)
    do {
        try store.execute(request)
        completionHandler(.success(true))
    } catch {
        completionHandler(.failure(error))
    }
}
#endif

// PRAGMA MARK: - Groups Methods -


/// Fetch list of Groups from the contact store.
/// - parameter completionHandler: Returns Either [CNGroup] or Error.
public func fetchGroups(completionHandler: @escaping (_ result: Result<[CNGroup], Error>) -> ()) {
    let store: CNContactStore = CNContactStore()
    do {
        let groups: [CNGroup] = try store.groups(matching: nil)
       completionHandler(.success(groups))
    } catch {
        completionHandler(.failure(error))
    }
}


/// Adds a group to the contact store.
/// - parameter name: Name of the group.
/// - parameter completionHandler: Returns Either Bool or Error.
#if os(iOS) || os(OSX)
public func createGroup(Group_Name name: String, completionHandler: @escaping (_ result:  Result<Bool, Error>) -> ()) {
    let store: CNContactStore = CNContactStore()
    let request: CNSaveRequest = CNSaveRequest()
    let group: CNMutableGroup = CNMutableGroup()
    group.name = name
    request.add(group, toContainerWithIdentifier: nil)
    do {
        try store.execute(request)
        completionHandler(.success(true))
    } catch {
        completionHandler(.failure(error))
    }
}

/// Adds a group to the contact store.
/// - parameter name: Name of the group.
/// - parameter identifire: The identifier of the container to add the new group. To add the new group to the default container, set identifier to nil.
/// - parameter completionHandler: Returns Either Bool or Error.
public func createGroupInContainer(Group_Name name: String, ContainerIdentifire identifire: String, completionHandler: @escaping (_ result: Result<Bool, Error>) -> ()) {
    let store: CNContactStore = CNContactStore()
    let request: CNSaveRequest = CNSaveRequest()
    let group: CNMutableGroup = CNMutableGroup()
    group.name = name
    request.add(group, toContainerWithIdentifier: identifire)
    do {
        try store.execute(request)
        completionHandler(.success(true))
    } catch {
       completionHandler(.failure(error))
    }
}

/// Remove an existing group in the contact store.
/// - parameter group: The group to delete.
/// - parameter completionHandler: Returns Either Bool or Error.
public func removeGroup(Group group: CNGroup, completionHandler: @escaping (_ result: Result<Bool, Error>) -> ()) {
    let store: CNContactStore = CNContactStore()
    let request: CNSaveRequest = CNSaveRequest()
    if let mutableGroup: CNMutableGroup = group.mutableCopy() as? CNMutableGroup {
        request.delete(mutableGroup)
    }
    do {
        try store.execute(request)
         completionHandler(.success(true))
    } catch {
         completionHandler(.failure(error))
    }
}

/// Update an existing group in the contact store.
/// - parameter group: The group to update.
/// - parameter completionHandler: Returns Either Bool or Error.
public func updateGroup(Group group: CNGroup, New_Group_Name name: String, completionHandler: @escaping (_ result:  Result<Bool, Error>) -> ()) {
    let store: CNContactStore = CNContactStore()
    let request: CNSaveRequest = CNSaveRequest()
    if let mutableGroup: CNMutableGroup = group.mutableCopy() as? CNMutableGroup {
        mutableGroup.name = name
        request.update(mutableGroup)
    }
    do {
        try store.execute(request)
        completionHandler(.success(true))
    } catch {
        completionHandler(.failure(error))
    }
}

/// Adds a contact as a member of a group.
/// - parameter group: The group to add member in.
/// - parameter completionHandler: Returns Either Bool or Error.
public func addContactToGroup(Group group: CNGroup, Contact contact: CNContact, completionHandler: @escaping (_ result:  Result<Bool, Error>) -> ()) {
    let store: CNContactStore = CNContactStore()
    let request: CNSaveRequest = CNSaveRequest()
    request.addMember(contact, to: group)
    do {
        try store.execute(request)
        completionHandler(.success(true))
    } catch {
        completionHandler(.failure(error))
    }
}

/// Remove a contact as a member of a group.
/// - parameter group: The group to Remove member from.
/// - parameter completionHandler: Returns Either Bool or Error.
public func removeContactFromGroup(Group group: CNGroup, Contact contact: CNContact, completionHandler: @escaping (_ result: Result<Bool, Error>) -> ()) {
    let store: CNContactStore = CNContactStore()
    let request: CNSaveRequest = CNSaveRequest()
    request.removeMember(contact, from: group)
    do {
        try store.execute(request)
        completionHandler(.success(true))
    } catch {
        completionHandler(.failure(error))
    }
}
#endif

/// Fetch all contacts in a group.
/// - parameter group: The group.
/// - parameter completionHandler: Returns Either [CNContact] or Error.
public func fetchContactsInGorup(Group group: CNGroup, completionHandler: @escaping (_ result: Result<[CNContact], Error>) -> ()) {
    
    let contactStore: CNContactStore = CNContactStore()
    var contacts: [CNContact] = [CNContact]()
    do {
        let predicate: NSPredicate = CNContact.predicateForContactsInGroup(withIdentifier: group.name)
        let keysToFetch: [String] = [CNContactGivenNameKey]
        contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as [CNKeyDescriptor])
         completionHandler(.success(contacts))
    } catch {
        completionHandler(.failure(error))
    }
}

/// Fetch all contacts in a group.
/// - parameter group: The group.
/// - parameter completionHandler: Returns Either [CNContact] or Error.
public func fetchContactsInGorup2(Group group: CNGroup, completionHandler: @escaping (_ result:  Result<[CNContact], Error>) -> ()) {
    
    let contactStore: CNContactStore = CNContactStore()
    let contacts: [CNContact] = [CNContact]()
    do {
        var predicate: NSPredicate!
        let allGroups: [CNGroup] = try contactStore.groups(matching: nil)
        for item in allGroups {
            if item.name == group.name {
                predicate = CNContact.predicateForContactsInGroup(withIdentifier: group.identifier)
            }
        }
        let keysToFetch: [String] = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactOrganizationNameKey, CNContactPhoneNumbersKey, CNContactUrlAddressesKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey, CNContactNoteKey, CNContactImageDataKey]
        if predicate != nil {
            var contacts: [CNContact] = try contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as [CNKeyDescriptor])
            for contact in contacts {
                contacts.append(contact)
            }
        }
         completionHandler(.success(contacts))
    } catch {
        completionHandler(.failure(error))
    }
}

// PRAGMA MARK: - Converter Methods -

// CSV Converter


// Convert [CNContacts] TO CSV
/// Returns the vCard representation of the specified contacts.
/// - parameter contacts: Array of contacts.
/// - parameter completionHandler: Returns Either Data or Error.
public func contactsToVCardConverter(contacts: [CNContact], completionHandler: @escaping (_ result: Result<Data, Error>) -> ()) {
    
    var vcardFromContacts: Data = Data()
    do {
        try vcardFromContacts = CNContactVCardSerialization.data(with: contacts)
        completionHandler(.success(vcardFromContacts))
    } catch {
        completionHandler(.failure(error))
    }
    
}


// Convert CSV TO [CNContact]
/// Returns the contacts from the vCard data.
/// - parameter data: Data having contacts.
/// - parameter completionHandler: Returns Either [CNContact] or Error.
public func VCardToContactConverter(data: Data, completionHandler: @escaping (_ result: Result<[CNContact], Error>) -> ()) {
    var contacts: [CNContact] = [CNContact]()
    do {
        try contacts = CNContactVCardSerialization.contacts(with: data) as [CNContact]
        completionHandler(.success(contacts))
    } catch {
       completionHandler(.failure(error))
    }
}

// Archive Unarchive Contacts
/// Returns the NSKeyedArchiver.archivedData representation of the specified contacts.
/// - parameter contacts: Array of contacts.
/// - parameter completionHandler: Returns Either Data or Error.
public func archiveContacts(contacts: [CNContact], completionHandler: @escaping (_ result: Data) -> ()) {
    
    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: contacts)
    completionHandler(encodedData)
    
}

/// Returns the contacts from the NSKeyedArchiver.archivedData.
/// - parameter data: Data having contacts.
/// - parameter completionHandler: Returns Either [CNContact] or Error.
public func unarchiveConverter(data: Data, completionHandler: @escaping (_ result: [CNContact]) -> ()) {
    let decodedData: Any? = NSKeyedUnarchiver.unarchiveObject(with: data)
    if let contacts: [CNContact] = decodedData as? [CNContact] {
        completionHandler(contacts)
    }
}

#if os(OSX)

/// Convert CNPhoneNumber To digits
/// - parameter CNPhoneNumber: Phone number.
public func CNPhoneNumberToString(CNPhoneNumber: CNPhoneNumber) -> String {
    if let result: String = CNPhoneNumber.value(forKey: "digits") as? String {
        return result
    }
    return ""
}

/// Make call to given number.
/// - parameter CNPhoneNumber: Phone number.
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
// PRAGMA MARK: - CoreTelephonyCheck

/// Check if iOS Device supports phone calls
/// - parameter completionHandler: Returns Bool.
public func isCapableToCall(completionHandler: @escaping (_ result: Bool) -> ()) {
    if UIApplication.shared.canOpenURL(NSURL(string: "tel://")! as URL) {
        // Check if iOS Device supports phone calls
        // User will get an alert error when they will try to make a phone call in airplane mode
        
        #if targetEnvironment(macCatalyst)

            completionHandler(false)
        #else 
        
        
        if let mnc: String = CTTelephonyNetworkInfo().subscriberCellularProvider?.mobileNetworkCode, !mnc.isEmpty {
            // iOS Device is capable for making calls
            completionHandler(true)
        } else {
            // Device cannot place a call at this time. SIM might be removed
            completionHandler(false)
        }
        
        #endif
    } else {
        // iOS Device is not capable for making calls
        completionHandler(false)
    }
    
}

/// Check if iOS Device supports sms
/// - parameter completionHandler: Returns Bool.
public func isCapableToSMS(completionHandler: @escaping (_ result: Bool) -> ()) {
    if UIApplication.shared.canOpenURL(NSURL(string: "sms:")! as URL) {
        completionHandler(true)
    } else {
        completionHandler(false)
    }
    
}

/// Convert CNPhoneNumber To digits
/// - parameter CNPhoneNumber: Phone number.
public func CNPhoneNumberToString(CNPhoneNumber: CNPhoneNumber) -> String {
    if let result: String = CNPhoneNumber.value(forKey: "digits") as? String {
        return result
    }
    return ""
}

/// Make call to given number.
/// - parameter CNPhoneNumber: Phone number.
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
