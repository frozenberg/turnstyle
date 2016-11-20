//
//  EventsViewController.swift
//  Turnstyle
//
//  Copyright © 2016 6164 Productions. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {


    
    @IBOutlet var tableViewOut: UITableView!
    var eventArray = ["event1"]
    
    
    func position(for bar: UIBarPositioning) -> UIBarPosition{
        return .topAttached;
    }


    @IBAction func addEvent(_ sender: Any) {
        let eventCreater = eventForm()
        self.navigationController?.pushViewController(eventCreater, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // let myCell = tableView.dequeueReusableCellWithIdentifier("theCell")! as UITableViewCell
        
        print("in cellForRow at \(indexPath)")
        
        let myCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        myCell.textLabel!.text = eventArray[indexPath.row]
        
        return myCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        let EventDetails = EventDetailView()
        self.navigationController?.pushViewController(EventDetails, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOut.reloadData()
        tableViewOut.dataSource = self
        tableViewOut.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

