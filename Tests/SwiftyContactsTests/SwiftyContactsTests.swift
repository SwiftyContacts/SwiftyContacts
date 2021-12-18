@testable import SwiftyContacts
import XCTest

@available(macOS 12.0.0, *)
final class SwiftyContactsTests: XCTestCase {
    func testRequestAccess() async {
        do {
            let bool = try await requestAccess()
            XCTAssertEqual(bool, true)

        } catch {
            XCTFail(error.localizedDescription)
        }
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

    func testFetchContacts() async {
        do {
            let contacts = try await fetchContacts()
            XCTAssertEqual(contacts.count >= 0, true)

        } catch {
            XCTFail(error.localizedDescription)
        }
    }

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
}
