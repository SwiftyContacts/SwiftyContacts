//
//  SwiftyContactsSpec.swift
//  SwiftyContacts
//
//  Created by Rahul Katariya on 04/10/16.
//  Copyright © 2017 JetpackSwift. All rights reserved.
//

import Quick
import Nimble
@testable import SwiftyContacts

class SwiftyContactsSpec: QuickSpec {

    override func spec() {

        describe("SwiftyContactsSpec") {
            it("works") {
                expect(SwiftyContacts.name) == "SwiftyContacts"
            }
        }
    }

}
