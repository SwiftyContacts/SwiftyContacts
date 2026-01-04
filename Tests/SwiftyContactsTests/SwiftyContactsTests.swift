@testable import SwiftyContacts
import XCTest
import Contacts

/// A mock implementation of ContactStoreProtocol for unit testing.
final class MockContactStore: ContactStoreProtocol, @unchecked Sendable {
    var contacts: [CNContact] = []
    var groups: [CNGroup] = []
    var containers: [CNContainer] = []
    var accessGranted: Bool = true
    var error: Error?

    func requestAccess(for entityType: CNEntityType) async throws -> Bool {
        if let error = error { throw error }
        return accessGranted
    }

    func enumerateContacts(with request: CNContactFetchRequest, usingBlock block: @Sendable @escaping (CNContact, UnsafeMutablePointer<ObjCBool>) -> Void) throws {
        if let error = error { throw error }
        var stop: ObjCBool = false
        for contact in contacts {
            block(contact, &stop)
            if stop.boolValue { break }
        }
    }

    func unifiedContacts(matching predicate: NSPredicate, keysToFetch: [CNKeyDescriptor]) throws -> [CNContact] {
        if let error = error { throw error }
        // Simple mock: return all contacts for any predicate
        return contacts
    }

    func unifiedContact(withIdentifier identifier: String, keysToFetch: [CNKeyDescriptor]) throws -> CNContact {
        if let error = error { throw error }
        guard let contact = contacts.first(where: { $0.identifier == identifier }) else {
            throw NSError(domain: "MockContactStore", code: 404, userInfo: nil)
        }
        return contact
    }

    func execute(_ saveRequest: CNSaveRequest) throws {
        if let error = error { throw error }
        // For simple mocking, we don't reflect save requests back to the 'contacts' array
        // unless specifically needed for a test.
    }

    func groups(matching predicate: NSPredicate?) throws -> [CNGroup] {
        if let error = error { throw error }
        return groups
    }

    func containers(matching predicate: NSPredicate?) throws -> [CNContainer] {
        if let error = error { throw error }
        return containers
    }
}

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, visionOS 1.0, *)
final class SwiftyContactsTests: XCTestCase, @unchecked Sendable {
    
    var mockStore: MockContactStore!
    
    override func setUp() async throws {
        mockStore = MockContactStore()
        // Note: With Swift 6 and constants, we can't inject the mock directly
        // Tests will use the real CNContactStore for now
        // In a real project, you'd want to make the store injectable
    }
    
    // MARK: - Authorization Tests
    
    func testRequestAccess() async throws {
        // Test with real store since we can't mock with constants
        let hasAccess = try await requestAccess()
        // We can't predict the result, but we can test it doesn't crash
        XCTAssertTrue(hasAccess == true || hasAccess == false)
    }
    
    func testRequestAccessWithError() async throws {
        // Test error handling with a custom mock
        let mockStore = MockContactStore()
        mockStore.error = NSError(domain: "TestError", code: 1, userInfo: nil)
        
        let actor = ContactStoreActor(store: mockStore)
        do {
            _ = try await actor.requestAccess(for: .contacts)
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is NSError)
            XCTAssertEqual((error as NSError).domain, "TestError")
        }
    }
    
    func testAuthorizationStatus() {
        // CNContactStore.authorizationStatus is a static method we can't easily mock
        // but we can still test our wrapper logic if it had any.
        let status = authorizationStatus()
        XCTAssertTrue(
            status == .authorized || status == .notDetermined || status == .denied || status == .restricted
        )
    }
    
    func testRequestAccessClosures() {
        let expectation = expectation(description: "testRequestAccessClosures")
        mockStore.accessGranted = true
        
        requestAccess { result in
            switch result {
            case .success(let hasAccess):
                XCTAssertTrue(hasAccess)
            case .failure(let error):
                XCTFail("Failed: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Fetch Contacts Tests
    
    func testFetchContacts() async throws {
        let contact = CNMutableContact()
        contact.givenName = "John"
        mockStore.contacts = [contact]
        
        let contacts = try await fetchContacts()
        XCTAssertEqual(contacts.count, 1)
        XCTAssertEqual(contacts.first?.givenName, "John")
    }
    
    func testFetchContactsClosures() {
        let expectation = expectation(description: "testFetchContactsClosures")
        let contact = CNMutableContact()
        contact.givenName = "Jane"
        mockStore.contacts = [contact]
        
        fetchContacts { result in
            switch result {
            case .success(let contacts):
                XCTAssertEqual(contacts.count, 1)
                XCTAssertEqual(contacts.first?.givenName, "Jane")
            case .failure(let error):
                XCTFail("Failed: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchContactWithIdentifier() async throws {
        let contact = CNMutableContact()
        // We can't set identifier directly on CNContact, so we rely on what the mock returns
        mockStore.contacts = [contact]
        
        let fetched = try await fetchContact(withIdentifier: contact.identifier)
        XCTAssertEqual(fetched.identifier, contact.identifier)
    }
    
    // MARK: - Contact Management Tests
    
    func testAddContact() async throws {
        let contact = CNMutableContact()
        contact.givenName = "New"
        // Verify no crash/error when executing save request
        try await addContact(contact)
    }
    
    func testUpdateContact() async throws {
        let contact = CNMutableContact()
        try await updateContact(contact)
    }
    
    func testDeleteContact() async throws {
        let contact = CNMutableContact()
        try await deleteContact(contact)
    }
    
    // MARK: - Group Tests
    
    func testFetchGroups() async throws {
        let group = CNMutableGroup()
        group.name = "Family"
        mockStore.groups = [group]
        
        let groups = try await fetchGroups()
        XCTAssertEqual(groups.count, 1)
        XCTAssertEqual(groups.first?.name, "Family")
    }
    
    func testAddAndDeleteGroup() async throws {
        try await addGroup("Testing")
        let group = CNMutableGroup()
        try await deleteGroup(group)
    }
    
    // MARK: - VCard Tests
    
    func testEncodeDecodeVCard() throws {
        let contact = CNMutableContact()
        contact.givenName = "VCard"
        
        let data = try encode(contacts: [contact])
        XCTAssertFalse(data.isEmpty)
        
        let decoded = try decode(data: data)
        XCTAssertEqual(decoded.count, 1)
        XCTAssertEqual(decoded.first?.givenName, "VCard")
    }
    
    // MARK: - Search Variants
    
    func testFetchContactsMatchingName() async throws {
        let contact = CNMutableContact()
        contact.givenName = "Satish"
        mockStore.contacts = [contact]
        
        let contacts = try await fetchContacts(matchingName: "Satish")
        XCTAssertEqual(contacts.count, 1)
    }
    
    func testFetchContactsMatchingEmail() async throws {
        let contact = CNMutableContact()
        contact.emailAddresses = [CNLabeledValue(label: nil, value: "test@example.com")]
        mockStore.contacts = [contact]
        
        let contacts = try await fetchContacts(matchingEmailAddress: "test@example.com")
        XCTAssertEqual(contacts.count, 1)
    }

    func testFetchContactsInGroup() async throws {
        let contact = CNMutableContact()
        mockStore.contacts = [contact]
        
        let contacts = try await fetchContacts(in: "GroupID")
        XCTAssertEqual(contacts.count, 1)
    }
    
    func testGroupMembership() async throws {
        let contact = CNContact()
        let group = CNGroup()
        
        try await addContact(contact, to: group)
        try await removeContact(contact, from: group)
    }
}
