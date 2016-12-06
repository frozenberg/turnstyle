//
//  CodeScannerViewController.swift
//  Turnstyle
//
//  Created by Fede Rozenberg on 12/3/16.
//  Copyright © 2016 6164 Productions. All rights reserved.
//

import UIKit
import AVFoundation

class CodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    let EVENT_ID_INDEX = 0
    let USER_ID_INDEX = 1
    
    var event: Event? = nil //this event is set by the EventDetailView that pushes the ScannerView
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        messageLabel.isHidden = true
        
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        } else {
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning();
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: readableObject.stringValue);
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        let codeArray = code.components(separatedBy: "/")
        let attendees = event?.attendeeList
        var isValid = false
        if (codeArray[EVENT_ID_INDEX] == event?.eventId){
            print("Event id: \(codeArray[EVENT_ID_INDEX])")
            for id: String in attendees! {
                if (id == codeArray[USER_ID_INDEX]){
                    isValid = true
                }
            }
        }
        if (isValid){
            foundValidTicket()
        }else{
            foundInvalidTicket()
        }
    }
    
    func foundValidTicket(){
        messageLabel.text = "Ticket Redeemed!"
        messageLabel.isHidden = false
        //TODO add some form of db interaction to mark the ticket as redeemed
        
        //no clue if this works, should restart capture session
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.captureSession.startRunning()
        })
       
        
    }
    
    func foundInvalidTicket(){
        messageLabel.text = "Invalid Ticket"
        messageLabel.backgroundColor = UIColor.red
        messageLabel.isHidden = false
        //TODO restart the scanning functionality (i think)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
