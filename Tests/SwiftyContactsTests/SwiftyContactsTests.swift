@testable import SwiftyContacts
import XCTest

final class SwiftyContactsTests: XCTestCase {
    
    func testRequestAccess() async {
        do {
            let authorizer = ContactAuthorizer()
            let bool = try await authorizer.requestAccess()
            XCTAssertEqual(bool, true)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testAuthorizationStatus() async {
        let authorizer = ContactAuthorizer()
        let authStatus = await authorizer.authorizationStatus()
        XCTAssertEqual(authStatus, CNAuthorizationStatus.authorized)
    }
    
    func testFetchContacts() async {
        do {
            let fetcher = ContactFetcher()
            let contacts = try await fetcher.fetchContacts()
            XCTAssertEqual(contacts.count >= 0, true)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testAddContact() async {
        do {
            let contact = CNMutableContact()
            contact.givenName = "Satish"
            
            let updater = ContactUpdater()
            let fetcher = ContactFetcher()
            
            try await updater.addContact(contact)
            let contacts = try await fetcher.fetchContacts(matchingName: "Satish")
            
            XCTAssertEqual(contacts.count >= 0, true)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
