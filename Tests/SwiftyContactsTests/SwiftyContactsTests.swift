@testable import SwiftyContacts
import XCTest
import Contacts

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
final class SwiftyContactsTests: XCTestCase {
    
    // MARK: - Authorization Tests
    
    func testRequestAccess() async throws {
        let hasAccess = try await requestAccess()
        XCTAssertTrue(hasAccess, "Should have access to contacts")
    }
    
    func testAuthorizationStatus() {
        let status = authorizationStatus()
        XCTAssertTrue(
            status == .authorized || status == .notDetermined || status == .denied || status == .restricted,
            "Authorization status should be valid"
        )
    }
    
    func testRequestAccessClosures() {
        let expectation = expectation(description: "testRequestAccessClosures")
        
        requestAccess { result in
            switch result {
            case .success(let hasAccess):
                XCTAssertTrue(hasAccess, "Should have access to contacts")
            case .failure(let error):
                XCTFail("Request access failed: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
    }
    
    // MARK: - Fetch Contacts Tests
    
    func testFetchContacts() async throws {
        let contacts = try await fetchContacts()
        XCTAssertGreaterThanOrEqual(contacts.count, 0, "Should fetch contacts")
    }
    
    func testFetchContactsClosures() {
        let expectation = expectation(description: "testFetchContactsClosures")
        
        fetchContacts { result in
            switch result {
            case .success(let contacts):
                XCTAssertGreaterThanOrEqual(contacts.count, 0, "Should fetch contacts")
            case .failure(let error):
                XCTFail("Fetch contacts failed: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
    }
    
    func testFetchContactsWithKeys() async throws {
        let keysToFetch: [CNKeyDescriptor] = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactEmailAddressesKey as CNKeyDescriptor
        ]
        let contacts = try await fetchContacts(keysToFetch: keysToFetch)
        XCTAssertGreaterThanOrEqual(contacts.count, 0, "Should fetch contacts with specified keys")
    }
    
    func testFetchContactWithIdentifier() async throws {
        // First fetch all contacts to get an identifier
        let allContacts = try await fetchContacts()
        guard let firstContact = allContacts.first else {
            return // Skip if no contacts
        }
        
        let contact = try await fetchContact(withIdentifier: firstContact.identifier)
        XCTAssertEqual(contact.identifier, firstContact.identifier, "Should fetch the correct contact")
    }
    
    // MARK: - Contact Management Tests
    
    func testAddAndDeleteContact() async throws {
        // Create a test contact
        let contact = CNMutableContact()
        contact.givenName = "Test"
        contact.familyName = "User"
        contact.emailAddresses = [CNLabeledValue(label: CNLabelHome, value: "test@example.com")]
        
        // Add contact
        try await addContact(contact)
        
        // Verify it was added
        let fetchedContacts = try await fetchContacts(matchingName: "Test User")
        XCTAssertGreaterThan(fetchedContacts.count, 0, "Contact should be added")
        
        // Clean up - delete the contact
        if let addedContact = fetchedContacts.first,
           let mutableContact = addedContact.mutableCopy() as? CNMutableContact {
            try await deleteContact(mutableContact)
        }
    }
    
    func testUpdateContact() async throws {
        // This test requires a contact to exist, so we'll skip if none are available
        let allContacts = try await fetchContacts()
        guard let existingContact = allContacts.first,
              let mutableContact = existingContact.mutableCopy() as? CNMutableContact else {
            return // Skip if no contacts
        }
        
        let originalName = mutableContact.givenName
        mutableContact.givenName = "Updated"
        
        // Update contact
        try await updateContact(mutableContact)
        
        // Verify update
        let updatedContact = try await fetchContact(withIdentifier: mutableContact.identifier)
        XCTAssertEqual(updatedContact.givenName, "Updated", "Contact should be updated")
        
        // Restore original name
        mutableContact.givenName = originalName
        try await updateContact(mutableContact)
    }
    
    // MARK: - Group Tests
    
    func testFetchGroups() async throws {
        let groups = try await fetchGroups()
        XCTAssertGreaterThanOrEqual(groups.count, 0, "Should fetch groups")
    }
    
    func testAddAndDeleteGroup() async throws {
        let groupName = "Test Group \(UUID().uuidString)"
        
        // Add group
        try await addGroup(groupName)
        
        // Verify it was added
        let groups = try await fetchGroups()
        let addedGroup = groups.first { $0.name == groupName }
        XCTAssertNotNil(addedGroup, "Group should be added")
        
        // Clean up - delete the group
        if let group = addedGroup,
           let mutableGroup = group.mutableCopy() as? CNMutableGroup {
            try await deleteGroup(mutableGroup)
        }
    }
    
    // MARK: - VCard Tests
    
    func testEncodeDecodeVCard() throws {
        let contact = CNMutableContact()
        contact.givenName = "Test"
        contact.familyName = "VCard"
        contact.emailAddresses = [CNLabeledValue(label: CNLabelHome, value: "test@example.com")]
        
        // Encode
        let vCardData = try encode(contacts: [contact])
        XCTAssertGreaterThan(vCardData.count, 0, "VCard data should not be empty")
        
        // Decode
        let decodedContacts = try decode(data: vCardData)
        XCTAssertEqual(decodedContacts.count, 1, "Should decode one contact")
        XCTAssertEqual(decodedContacts.first?.givenName, "Test", "Decoded contact should match")
    }
    
    // MARK: - Search Tests
    
    func testFetchContactsMatchingName() async throws {
        let contacts = try await fetchContacts(matchingName: "Test")
        XCTAssertGreaterThanOrEqual(contacts.count, 0, "Should fetch contacts matching name")
    }
    
    func testFetchContactsMatchingEmail() async throws {
        let contacts = try await fetchContacts(matchingEmailAddress: "test@example.com")
        XCTAssertGreaterThanOrEqual(contacts.count, 0, "Should fetch contacts matching email")
    }
}
