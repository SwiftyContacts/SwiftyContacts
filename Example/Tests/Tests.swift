// https://github.com/Quick/Quick

import Quick
import Nimble
import SwiftyContacts

class RequestAcess: QuickSpec {
    override func spec() {
        describe("Contact Methods") {
            
            describe("Request Acess") {
                it("Request", closure: {
                    
                    requestAccess({ (bool) in
                        expect(true || false) == bool
                    })
                })
            }
            
            
        }
    }
}

class FetchContactsRequest: QuickSpec {
    override func spec() {
        describe("Contact Methods") {
            
            
            
            describe("Fetch Contacts") {
                it("Fetch Contacts Request", closure: {
                    fetchContacts(completionHandler: { (result) in
                        switch result{
                        case .Success(response: _):
                            // Do your thing here with [CNContacts] array
                            XCTAssert(true)
                            break
                        case .Error(error: _):
                            XCTAssert(true)
                            break
                        }
                    })
                })
            }
            
            
            
            
        }
    }
}

class fetchContactsRequestAgain: QuickSpec {
    override func spec() {
        describe("Contact Methods") {
            
            
            describe("Fetch Contacts") {
                it("Fetch Contacts Request", closure: {
                    fetchContactsOnBackgroundThread(completionHandler: { (result) in
                        switch result{
                        case .Success(response: _):
                            // Do your thing here with [CNContacts] array
                            XCTAssert(true)
                            break
                        case .Error(error: _):
                            break
                        }
                    })
                })
            }
            
            
        }
    }
}

class FetchListOfGroups: QuickSpec {
    override func spec() {
        
        describe("Fetch List Of Groups") {
            it("Fetch List Of Groups", closure: {
                fetchGroups { (result) in
                    switch result{
                    case .Success(response:  _):
                        XCTAssert(true)
                        break
                    case .Error(error: _):
                        XCTAssert(true)
                        break
                    }
                }
            })
        }
        
        
    }
}


class FetchDupllicates: QuickSpec {
    override func spec() {
        
        describe("Fetch Contacts") {
            it("Fetch Dupllicates", closure: {
                fetchContacts(completionHandler: { (result) in
                    switch result{
                    case .Success(response: let contactsArray):
                        // Do your thing here with [CNContacts] array
                        findDuplicateContacts(Contacts: contactsArray) { (duplicatesContacts) in
                            XCTAssert(true)
                        }
                        break
                    case .Error(error: _):
                        XCTAssert(true)
                        break
                    }
                })
            })
        }
        
    }
}


class Fetchcontactsingroup: QuickSpec {
    override func spec() {
        describe("Contact Methods") {
            
            
            
            describe("Fetch Contacts") {
                it("Fetch contactts in group", closure: {
                    fetchGroups { (result) in
                        switch result{
                        case .Success(response:  let group):
                            for item in group{
                                fetchContactsInGorup(Group: item) { (result) in
                                    switch result{
                                    case .Success(response: _):
                                        XCTAssert(true)
                                        break
                                    case .Error(error: let error):
                                        print(error)
                                        break
                                    }
                                }
                            }
                            
                            break
                        case .Error(error: _):
                            XCTAssert(true)
                            break
                        }
                    }
                })
            }
            
            
            
            
        }
    }
}

class ConvertToCSV: QuickSpec {
    override func spec() {
        describe("Contact Methods") {
            
            
            describe("CSV") {
                it("Convert [CNContacts] TO CSV", closure: {
                    fetchContacts(completionHandler: { (result) in
                        switch result{
                        case .Success(response: let ContactsArray):
                            contactsToVCardConverter(contacts: ContactsArray) { (result) in
                                switch result {
                                case .Success(response: _):
                                    XCTAssert(true)
                                    break
                                case .Error(error: let error):
                                    XCTAssert(true)
                                    break
                                    
                                }
                            }
                            break
                        case .Error(error: _):
                            XCTAssert(true)
                            break
                        }
                    })
                })
            }
            
        }
    }
}

class CSVTOContact: QuickSpec {
    override func spec() {
        describe("Contact Methods") {
            
            describe("CSV") {
                it("Convert CSV TO [CNContact]", closure: {
                    fetchContacts(completionHandler: { (result) in
                        switch result{
                        case .Success(response: let ContactsArray):
                            contactsToVCardConverter(contacts: ContactsArray) { (result) in
                                switch result {
                                case .Success(response: let data):
                                    VCardToContactConverter(data: data) { (result) in
                                        switch result{
                                        case .Success(response: _):
                                            XCTAssert(true)
                                            break
                                        case .Error(error: _):
                                            XCTAssert(true)
                                            break
                                        }
                                    }
                                    break
                                case .Error(error: _):
                                    XCTAssert(true)
                                    break
                                    
                                }
                            }
                            break
                        case .Error(error: _):
                            XCTAssert(true)
                            break
                        }
                    })
                })
            }
            
            
            
        }
    }
}

class ArchiveContacts: QuickSpec {
    override func spec() {
        describe("Contact Methods") {
            
            describe("Archive") {
                it("Convert [CNContacts] TO Data", closure: {
                    fetchContacts(completionHandler: { (result) in
                        switch result{
                        case .Success(response: let ContactsArray):
                            archiveContacts(contacts: ContactsArray) { (result) in
                                XCTAssert(true)
                            }
                            break
                        case .Error(error: _):
                            XCTAssert(true)
                            break
                        }
                    })
                })
            }
            
            
            
        }
    }
}

class UnArchive: QuickSpec {
    override func spec() {
        describe("Contact Methods") {
            
            
            describe("Unrchive") {
                it("Data  TO [CNContact]", closure: {
                    fetchContacts(completionHandler: { (result) in
                        switch result{
                        case .Success(response: let ContactsArray):
                            contactsToVCardConverter(contacts: ContactsArray) { (result) in
                                switch result {
                                case .Success(response: let data):
                                    unarchiveConverter(data: data) { (result) in
                                        XCTAssert(true)
                                    }
                                    break
                                case .Error(error: _):
                                    XCTAssert(true)
                                    break
                                    
                                }
                            }
                            break
                        case .Error(error: _):
                            XCTAssert(true)
                            break
                        }
                    })
                })
            }
            
            
            
        }
    }
}


