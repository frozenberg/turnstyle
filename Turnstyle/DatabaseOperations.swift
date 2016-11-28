//
//  DatabaseOperations.swift
//  Turnstyle
//
//  Created by Fede Rozenberg on 11/22/16.
//  Copyright © 2016 6164 Productions. All rights reserved.
//

import Foundation
import Firebase


struct DatabaseOperations {
    
    
    //param: populateArray(newEvents: [Event]) -> Void
    //populates newEvents with the Firebase data
    
    static func getEvents(populateArray: @escaping (_ newEvents: [Event]) -> Void){
        let EVENTS_REF = Globals.FIREBASE_REF?.child("events")
        var newEvents: [Event] = []
        EVENTS_REF?.observe(.value, with: { snapshot in
            for item in snapshot.children {
                let newEvent = Event(snapshot: item as! FIRDataSnapshot)
                newEvents.append(newEvent)
            }
            populateArray(newEvents)
        })
    }
}
