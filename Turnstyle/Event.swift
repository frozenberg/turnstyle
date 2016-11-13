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
    var eventDate : NSDate
    var description : String
    var url : String
    var createdDate : NSDate
    var eventTime : NSDate //NSDate object stores date and time, to use for time simply ignore date
    
    //TODO constructor
}
