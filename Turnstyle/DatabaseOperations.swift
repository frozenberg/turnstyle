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
    
    
    
    static func getEvents(reload: ()) -> [Event] {
        let EVENTS_REF = Globals.FIREBASE_REF.child("events")
        EVENTS_REF.observe(.value, with: { snapshot in
            var newEvents: [Event] = []
            for item in snapshot.children {
                let newEvent = Event(snapshot: item as! FIRDataSnapshot)
                print(newEvent.getName())
                newEvents.append(newEvent)
            }
            reload()
            return newEvents
        })
    }
}
