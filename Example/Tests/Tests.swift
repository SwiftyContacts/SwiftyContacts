// https://github.com/Quick/Quick

import Quick
import Nimble
import SwiftyContacts

class TableOfContentsSpec: QuickSpec {
    override func spec() {
        describe("these will fail") {

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
