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
    
    
    //idea: change [Event] to [(Event, attending: Bool)] to automatically encode
    //  whether or not you are hosting or attending
    
    static func getEvents(populateArray: @escaping (_ newEvents: [(Event, Bool)]) -> Void){
        let EVENTS_REF = Globals.FIREBASE_REF?.child("events")
        
        var newEvents: [(Event, Bool)] = []

        EVENTS_REF?.observe(.value, with: { snapshot in
            
            if !newEvents.isEmpty{
                newEvents.removeAll()
                
            }
            var count = 0
            for item in snapshot.children {
                let newEvent = Event(snapshot: item as! FIRDataSnapshot)
                //only add to events array if hosting or attending
                if(newEvent.hostId == Globals.USERID){
                    newEvents.append((newEvent, false))
//                    print("\(count): false")
//                    count+=1
                }else if(newEvent.attendeeList.contains(Globals.USERID)){
                    newEvents.append((newEvent, true))
//                    print("\(count): true")
//                    count+=1
                }
                
            }
            populateArray(newEvents)
        })
    }
}
