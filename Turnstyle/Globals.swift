//
//  Globals.swift
//  Turnstyle
//
//  Copyright © 2016 6164 Productions. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseStorageUI

struct Globals{
    
    
    static var FIREBASE_REF : FIRDatabaseReference? = nil
    static var STORAGE_REF: FIRStorageReference? = nil
    static var USERID : String = ""
    static let FONT : String = "BebasNeue"
    static let ORANGE: UIColor = UIColor(colorLiteralRed: 1, green: 0.498, blue: 0, alpha: 0.6)
	    
    static func initialize(){
        FIREBASE_REF = FIRDatabase.database().reference()
        STORAGE_REF = FIRStorage.storage().reference()
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
