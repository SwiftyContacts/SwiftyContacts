@testable import SwiftyContacts
import XCTest

@available(macOS 12.0.0, *)
final class SwiftyContactsTests: XCTestCase {
    #if compiler(>=5.5) && canImport(_Concurrency)
        func testRequestAccess() async {
            do {
                let bool = try await requestAccess()
                XCTAssertEqual(bool, true)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    #endif

    func testAuthorizationStatus() {
        XCTAssertEqual(authorizationStatus(), CNAuthorizationStatus.authorized)
    }

    func testRequestAccessClosures() {
        let e = expectation(description: "testRequestAccessClosures")

        requestAccess { result in
            switch result {
            case let .success(bool):
                XCTAssertEqual(bool, true)
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }

            e.fulfill()
        }

        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }

    #if compiler(>=5.5) && canImport(_Concurrency)
        func testFetchContacts() async {
            do {
                let contacts = try await fetchContacts()
                XCTAssertEqual(contacts.count >= 0, true)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    #endif

    func testFetchContactsClosures() {
        let e = expectation(description: "testRequestAccessClosures")

        fetchContacts { result in
            switch result {
            case let .success(contacts):
                XCTAssertEqual(contacts.count >= 0, true)
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }

            e.fulfill()
        }

        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }

    func testAddContact() async {
        do {
            let contact = CNMutableContact()
            contact.givenName = "Satish"
            try addContact(contact)
            let contacts = try fetchContacts(matchingName: "Satish")
            XCTAssertEqual(contacts.count >= 0, true)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
