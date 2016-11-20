//
//  Event.swift
//  Turnstyle
//
//  Created by Fede Rozenberg on 11/13/16.
//  Copyright © 2016 6164 Productions. All rights reserved.
//

import Foundation

struct Event{
    
    var eventID : Int
    var ticketCost : Double
    var ticketsLeft : Int
    
    var host : String
    var name : String
    var location : String
    var eventDate : Date
    var description : String
    var url : String
    var createdDate : Date
    var eventTime : Date //NSDate object stores date and time, to use for time simply ignore date
    
    init(cost: Double, ticketsLeft: Int, host: String, name: String, location: String, eventDate: Date, description: String, url: String, eventTime: Date){
        self.eventID = 0 //fix
        self.ticketCost = cost
        self.ticketsLeft = ticketsLeft
        self.host = host
        self.name = name
        self.location = location
        self.eventDate = eventDate
        self.description = description
        self.url = url
        self.createdDate = Date()
        self.eventTime = eventTime
    }

    func toAnyObject() -> Any {
        return [
            "eventId": eventID,
            "ticketCost" : ticketCost,
            "ticketsLeft" : ticketsLeft,
            "host" : host,
            "name": name,
            "location" : location,
            "eventDate" : eventDate.description,
            "description" : description,
            "url" : url,
            "createdDate" : createdDate.description,
            "eventTime" : eventTime.description
        ]
    }
}
