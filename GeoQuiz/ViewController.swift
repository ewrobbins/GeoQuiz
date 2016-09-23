//
//  ViewController.swift
//  GeoQuiz
//
//  Created by Eric Warren Robbins on 9/3/16.
//  Copyright © 2016 Eric Robbins. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController, MKMapViewDelegate {
    
    var i:Int = 0
    var cities:[City] = []
    var qRight:Int = 0
    var qTotal:Int = 0
    var userName:String = ""
    var quizType:String = ""
    
    class City {
        
        var name:String = ""
        
        var country:String = ""
        
        var altCountries:[String] = []
        
        var lat:CLLocationDegrees = 0.0
        
        var lon:CLLocationDegrees = 0.0
        
        var latDelta:CLLocationDegrees = 0.4
        
        var lonDelta:CLLocationDegrees = 0.4
        
    }
    
    @IBOutlet var answerBox: UITextField!
    
    
    
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var scoreLabel: UILabel!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBAction func submitButton(sender: AnyObject) {
        
        let answer = answerBox.text!.lowercaseString
        
        var rightAlert = UIAlertController(title: "Correct!", message: "\(cities[i].name) is in \(cities[i].country).", preferredStyle: UIAlertControllerStyle.Alert)
        
        if (quizType == "College Towns") {
            rightAlert = UIAlertController(title: "Correct!", message: "\(cities[i].name) is the home of \(cities[i].country).", preferredStyle: UIAlertControllerStyle.Alert)
            rightAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            }))
        }
        else {
            rightAlert = UIAlertController(title: "Correct!", message: "\(cities[i].name) is in \(cities[i].country).", preferredStyle: UIAlertControllerStyle.Alert)
            rightAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            }))
        }
        
        var wrongAlert = UIAlertController(title: "Incorrect!", message: "\(cities[i].name) is in \(cities[i].country).", preferredStyle: UIAlertControllerStyle.Alert)
        
        if (quizType == "College Towns") {
            wrongAlert = UIAlertController(title: "Incorrect!", message: "\(cities[i].name) is the home of \(cities[i].country).", preferredStyle: UIAlertControllerStyle.Alert)
            wrongAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            }))
        }
        else {
            wrongAlert = UIAlertController(title: "Incorrect!", message: "\(cities[i].name) is in \(cities[i].country).", preferredStyle: UIAlertControllerStyle.Alert)
            wrongAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            }))
        }
        
        
        if (cities[i].country.lowercaseString == answer || cities[i].altCountries.contains(answer)) {
            qRight += 1
            qTotal += 1
            
            if i < cities.count-1 {
                self.presentViewController(rightAlert, animated: true, completion: nil)
                i += 1
                updateMap(cities[i])
            }
            else {
                endFunc(1)
            }
        }
            
        else {
            qTotal += 1
            if i < cities.count-1 {
                self.presentViewController(wrongAlert, animated: true, completion: nil)
                i += 1
                updateMap(cities[i])
            }
            else {
                endFunc(0)
            }
        }
        
        scoreLabel.text = ("\(qRight)/\(qTotal)")
        
        answerBox.text = ""
    }
    
    func endFunc (finalCorrect: Int) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        var newUser = NSEntityDescription.insertNewObjectForEntityForName("Leaders", inManagedObjectContext: context)
        
        if (quizType == "") {
            quizType = "World Cities"
        }
        
        if (userName == "") {
            userName = "Anonymous"
        }
        
        newUser.setValue(userName, forKey: "userName")
        newUser.setValue(quizType, forKey: "gameType")
        newUser.setValue(qRight, forKey: "score")
        
        do {
            try context.save()
        } catch {
            print ("Problem saving.")
        }
        
        if (finalCorrect == 0) {
            let endAlert = UIAlertController(title: "Thanks for playing, \(userName)!", message: "Sorry, you are incorrect. Your final score was \(qRight)/\(qTotal).", preferredStyle: UIAlertControllerStyle.Alert)
            endAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            //self.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(endAlert, animated: true, completion: nil)
        }
        else {
            let endAlert = UIAlertController(title: "Thanks for playing, \(userName)!", message: "You are correct!. Your final score was \(qRight)/\(qTotal).", preferredStyle: UIAlertControllerStyle.Alert)
            endAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                //self.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(endAlert, animated: true, completion: nil)
        }

        
        qRight = 0
        qTotal = 0
        
        scoreLabel.text = ("\(qRight)/\(qTotal)")
        
        i = 0
        updateMap(cities[i])
    }
    
    
    @IBOutlet var cityMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (quizType == "College Towns") {
            questionLabel.text = "Do you know your college towns?"
            nameLabel.text = "Name the university:"
        }
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "swiped:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "swiped:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        cities = createCities()
        updateMap(cities[i])
        
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        if event!.subtype == UIEventSubtype.MotionShake {
            
            restart()
        }
    }
    
    func swiped(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
                case UISwipeGestureRecognizerDirection.Right:
                    giveUp()
            
                case UISwipeGestureRecognizerDirection.Left:
                    giveUp()		
            
                default:
                    break
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    
    func updateMap(newCity: City) {
        
        let latitude:CLLocationDegrees = newCity.lat
        
        let longitude:CLLocationDegrees = newCity.lon
        
        let latDelta:CLLocationDegrees = newCity.latDelta
        
        let lonDelta:CLLocationDegrees = newCity.lonDelta
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        cityMap.setRegion(region, animated: true)
    }
    
    func giveUp () {
        
        qTotal += 1
        scoreLabel.text = ("\(qRight)/\(qTotal)")
        
        var giveUpAlert = UIAlertController(title: "You gave up!", message: "\(cities[i].name) is the home of \(cities[i].country).", preferredStyle: UIAlertControllerStyle.Alert)
        
        if (quizType == "College Towns") {
            giveUpAlert = UIAlertController(title: "You gave up!", message: "\(cities[i].name) is the home of \(cities[i].country).", preferredStyle: UIAlertControllerStyle.Alert)
        }
        else {
            giveUpAlert = UIAlertController(title: "You gave up!", message: "\(cities[i].name) is in \(cities[i].country).", preferredStyle: UIAlertControllerStyle.Alert)
        }
        
        giveUpAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        
        if i < (cities.count - 1) {
            self.presentViewController(giveUpAlert, animated:true, completion: nil)
            i += 1
            updateMap(cities[i])
        }
        
        else {
            endFunc(0)
        }
    }
    
    func restart () {
        i = 0
        qRight = 0
        qTotal = 0
        scoreLabel.text = ("0/0")
        updateMap(cities[i])
    }
    
    func createCities() -> ([City]) {
        
        func initCity(cName: String, _ cCountry: String, _ cAltCountries: [String], _ cLat:CLLocationDegrees, _ cLon:CLLocationDegrees,
            _ cLatDelta:CLLocationDegrees, _ cLonDelta:CLLocationDegrees)-> City {
            
            let newCity = City()
            newCity.name = cName
            newCity.country = cCountry
            newCity.altCountries = cAltCountries
            newCity.lat = cLat
            newCity.lon = cLon
            newCity.latDelta = cLatDelta
            newCity.lonDelta = cLonDelta
            
            return newCity
        }
        
        var cities = [City]()
        
        if quizType == "College Towns" {
            cities.append(initCity("Athens", "University of Georgia", ["uga", "georgia"], 33.952, -83.355, 0.3, 0.3))
            cities.append(initCity("Knoxville", "University of Tennesee - Knoxville", ["ut", "tennesee", "ut-knoxville"], 35.961, -83.919, 0.4, 0.4))
            cities.append(initCity("Gainesville", "University of Florida", ["uf", "florida"], 29.650, -82.323, 0.4, 0.4))
            cities.append(initCity("Blacksburg", "Virginia Tech", ["virginia polytechnic and state university", "vt"], 37.228, -80.413, 0.3, 0.3))
            cities.append(initCity("Chapel Hill", "University of North Carolina - Chapel Hill", ["unc", "university of north carolina", "north carolina", "university of north carolina at chapel hill"], 35.913, -79.056, 0.3, 0.3))
            cities.append(initCity("Baton Rouge", "Louisiana State University", ["lsu", "louisiana state"], 30.460, -91.144, 0.4, 0.4))
            cities.append(initCity("Ann Arbor", "University of Michigan", ["michigan", "um"], 42.279, -83.742, 0.3, 0.3))
            cities.append(initCity("Boulder", "University of Colorado", ["colorado", "cu"], 40.016, -105.273, 0.3, 0.3))
            cities.append(initCity("Oxford", "University of Mississippi", ["mississippi", "ole miss"], 34.368, -89.516, 0.3, 0.3))
            cities.append(initCity("South Bend", "University of Notre Dame", ["Notre Dame", "ND"], 41.676, -86.240, 0.3, 0.3))
            cities.append(initCity("Madison", "University of Wisconsin - Madison", ["uw", "university of wisconsin", "uw-madison", "uw - madison", "wisconsin"], 43.071, -89.411, 0.4, 0.4))
            cities.append(initCity("Lexington", "University of Kentucky", ["kentucky", "uk"], 38.033, -84.500, 0.3, 0.3))
            cities.append(initCity("Columbus", "The Ohio State University", ["ohio state", "ohio state university", "osu"], 29.971, -82.996, 0.4, 0.4))
            cities.append(initCity("Palo Alto", "Stanford University", ["stanford"], 37.442, -122.142, 0.3, 0.3))
            cities.append(initCity("Fort Worth", "Texas Christian University", ["tcu", "texas christian"], 32.756, -97.325, 0.3, 0.3))
            cities.append(initCity("Tallahassee", "Florida State University", ["florida state", "fsu"], 30.437, -84.267, 0.3, 0.3))
            cities.append(initCity("Eugene", "University of Oregon", ["uo", "oregon"], 44.050, -123.083, 0.3, 0.3))
            cities.append(initCity("Nashville", "Vanderbilt University", ["vandy", "vanderbilt"], 36.167, -86.778, 0.4, 0.4))
            cities.append(initCity("Norman", "University of Oklahoma", ["oklahoma", "ou"], 35.223, -97.432, 0.3, 0.3))
            cities.append(initCity("Tuscon", "University of Arizona", ["ua", "arizona", "zona"], 32.223, -110.933, 0.4, 0.4))
            cities.append(initCity("Fayetteville", "University of Arkansas - Fayetteville", ["ua, arkansas, university of arkansas, university of arkansas-fayetteville"], 36.059, -94.160, 0.3, 0.3))
            
        }
        else {
            cities.append(initCity("Manila", "The Philippines", ["philippines"], 14.601, 120.986, 0.4, 0.4))
            cities.append(initCity("Zurich", "Switzerland", [], 47.384, 8.542, 0.4, 0.4))
            cities.append(initCity("Sao Paulo", "Brazil", ["brasil"], -23.531,-46.613, 0.4, 0.4))
            cities.append(initCity("Buenos Aires", "Argentina", [], -34.601, -58.373, 0.4, 0.4))
            cities.append(initCity("Hanoi", "Vietnam", [], 21.031, 105.833, 0.4, 0.4))
            cities.append(initCity("Osaka", "Japan", [], 34.702, 135.500, 0.4, 0.4))
            cities.append(initCity("Helsinki", "Finland", [], 60.178, 24.919, 0.4, 0.4))
            cities.append(initCity("Johannesburg", "South Africa", ["rsa"], -26.204, 28.048, 0.4, 0.4))
            cities.append(initCity("Casablanca", "Morocco", [], 33.575, -7.591, 0.4, 0.4))
            cities.append(initCity("Pyongyang", "North Korea", ["dprk","prk"], 39.043, 125.759, 0.4, 0.4))
            cities.append(initCity("Tel Aviv", "Israel", [], 32.084, 34.782, 0.4, 0.4))
            cities.append(initCity("Bangalore/Bengaluru", "India", [], 12.966, 77.596, 0.4, 0.4))
            cities.append(initCity("New Orleans", "United States", ["united states of america","usa","us"], 29.972, -90.084, 0.4, 0.4))
            cities.append(initCity("Auckland", "New Zealand", ["nz"], -36.856, 174.760, 0.4, 0.4))
            cities.append(initCity("Calgary", "Canada", [], 51.051, -114.071, 0.4, 0.4))
            cities.append(initCity("Tehran", "Iran", ["persia"], 35.692, 51.396, 0.4, 0.4))
            cities.append(initCity("Jakarta", "Indonesia", [], -6.214, 106.851, 0.4, 0.4))
            cities.append(initCity("Bogota", "Colombia", ["columbia"], 4.705, -74.069, 0.4, 0.4))
            cities.append(initCity("Manchester", "United Kingdom", ["uk", "england", "britain", "great britain"], 53.483, -2.221, 0.4, 0.4))
            cities.append(initCity("St. Petersburg", "Russia", ["russian federation"], 59.938, 30.348, 0.4, 0.4))
            cities.append(initCity("Reykjavik", "Iceland", [], 64.121, -21.822, 0.4, 0.4))
        
        
        }
        
        return cities
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

