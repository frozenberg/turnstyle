//
//  DatabaseOperations.swift
//  Turnstyle
//
//  Copyright © 2016 6164 Productions. All rights reserved.
//

import Foundation
import Firebase


struct DatabaseOperations {
	
    //get all events from firebase
    static func getEvents(populateArray: @escaping (_ newEvents: [(Event, Bool)]) -> Void){
        let EVENTS_REF = Globals.FIREBASE_REF?.child("events")
        
        var newEvents: [(Event, Bool)] = []

        EVENTS_REF?.observe(.value, with: { snapshot in
            
            if !newEvents.isEmpty{
                newEvents.removeAll()
            }
			
            for item in snapshot.children {
                let newEvent = Event(snapshot: item as! FIRDataSnapshot)
                //only add to events array if hosting or attending
                if(newEvent.hostId == Globals.USERID){
                    newEvents.append((newEvent, false))
                }else if(newEvent.attendeeList.contains(Globals.USERID)){
                    newEvents.append((newEvent, true))
                }
                
            }
            populateArray(newEvents)
        })
    }
	
	//get specific event from firebase
	static func getEvent(withId: String, populateArray: @escaping (_ newEvents: [Event]) -> Void){
		let EVENT_REF = Globals.FIREBASE_REF?.child("events").child(withId)
		print("Getting Event")
		var newEvents: [Event] = []
		EVENT_REF?.observe(.value, with: { snapshot in
			if !newEvents.isEmpty{
				newEvents.removeAll()
			}
			let gotEvent = Event(snapshot: snapshot)
			newEvents.append(gotEvent)
			populateArray(newEvents)
		})
	}
}
