//
//  XCUIElementQuery+labelContains.swift
//  MunchkinUITests
//
//  Created by Neifmetus on 09.03.2022.
//

import XCTest

extension XCUIElementQuery {
    func labelContains(text: String) -> XCUIElementQuery {
        let predicate = NSPredicate(format: "label CONTAINS %@", text)
        return self.containing(predicate)
    }
    
    func identifierContains(text: String) -> XCUIElementQuery {
        let predicate = NSPredicate(format: "identifier CONTAINS %@", text)
        return self.containing(predicate)
    }
}
