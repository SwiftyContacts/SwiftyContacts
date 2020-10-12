@testable import SwiftyContacts
import XCTest

final class SwiftyContactsTests: XCTestCase {
    func testRequestAccess() {
        let e = expectation(description: "requestAccess")

        requestAccess { bool in
            XCTAssertEqual(bool, true)
            e.fulfill()
        }

        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail("requestAccess errored: \(error.localizedDescription)")
            }
        }
    }

    func testFetchContacts() {
        let e = expectation(description: "fetchContacts")

        fetchContacts(keysToFetch: [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactThumbnailImageDataKey] as [CNKeyDescriptor]) { result in
            switch result {
            case let .success(contacts):
                XCTAssertEqual(contacts.count >= 0, true)
            case let .failure(error):
                XCTFail("fetchContacts errored: \(error.localizedDescription)")
            }
            e.fulfill()
        }

        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail("fetchContacts errored: \(error.localizedDescription)")
            }
        }
    }

    static var allTests = [
        ("testRequestAccess", testRequestAccess),
        ("testFetchContacts", testFetchContacts),
    ]
}
