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
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var url: UILabel!
    @IBOutlet weak var detailDescription: UILabel!
    
    var event: Event? = nil //this event is set by the EventsViewController that pushes the DetailView
    
    @IBAction func purchaseTicket(_ sender: Any) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = event!.name
        host.text = "Host: \(event!.host)"
        price.text = "Price: \(event!.ticketCost.description)"
        location.text = "Location: \(event!.location)"
        detailDescription.text = "Description: \(event!.description)"
        date.text = "Date: \(event!.eventDate.description)"
        time.text = "Time: \(event!.eventTime.description)"
        url.text = "URL: \(event!.url)"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
