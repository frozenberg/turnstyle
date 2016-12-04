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
    
    static func genQR(code: String) -> CIImage{
        let data = code.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        
        let QR_img = filter?.outputImage
        
        return QR_img!
    }
    
    static func scaleAndDisplayQRCodeImage(QR_img: CIImage, forView: UIImageView){
        let scaleX = forView.frame.size.width / QR_img.extent.size.width
        let scaleY = forView.frame.size.height / QR_img.extent.size.height
        
        let transformedImage = QR_img.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        forView.image = UIImage(ciImage: transformedImage)
    }
}
