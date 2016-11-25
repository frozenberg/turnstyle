//
//  Globals.swift
//  Turnstyle
//
//  Created by Fede Rozenberg on 11/21/16.
//  Copyright © 2016 6164 Productions. All rights reserved.
//

import Foundation
import Firebase

struct Globals{
    static var FIREBASE_REF : FIRDatabaseReference? = nil
    static var USERID : String = ""
    
    static func initialize(){
        FIREBASE_REF = FIRDatabase.database().reference()
        USERID = UIDevice.current.identifierForVendor!.uuidString
    }
}
