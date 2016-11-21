//
//  EventDetailView.swift
//  Turnstyle
//
//  Created by Ross Arkin on 11/20/16.
//  Copyright © 2016 6164 Productions. All rights reserved.
//

import UIKit

class EventDetailView: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var host: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var description: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var url: UILabel!
    
    var event: Event
    
    @IBAction func purchaseTicket(_ sender: Any) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = event.name
        host.text = event.host
        price.text = event.ticketCost as! String
        location.text = event.location
        description.text = event.description
        date.text = event.eventDate as! String
        time.text = event.eventTime as! String
        url.text = event.url
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
