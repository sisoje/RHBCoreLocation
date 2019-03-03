//
//  CoreLocationTests.swift
//  RHBTests_Tests
//
//  Created by Lazar Otasevic on 11/14/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import RHBCoreLocation
import CoreLocation

class CoreLocationTests: XCTestCase {
    func testAuthorization() {
        let ex = expectation(description: "testAuthorization")

        let manager = CLLocationManager()
        let actions = LocationActions()
        actions.manager = manager
        actions.blocks.didChangeAuthorization[.authorizedAlways] = {
            ex.fulfill()
        }
        #if !os(macOS)
        actions.blocks.didChangeAuthorization[.authorizedWhenInUse] = {
            ex.fulfill()
        }
        #endif
        actions.blocks.didChangeAuthorization[.denied] = {
            ex.fulfill()
        }
        actions.blocks.didChangeAuthorization[.notDetermined] = {
            ex.fulfill()
        }
        actions.blocks.didChangeAuthorization[.restricted] = {
            ex.fulfill()
        }
        #if os(macOS)
        actions.blocks.didChangeAuthorization[.authorized] = {
            ex.fulfill()
        }
        #endif

        waitForExpectations(timeout: 5, handler: nil)
    }
}
