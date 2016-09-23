//
//  HOFViewController.swift
//  GeoQuiz
//
//  Created by Eric Robbins on 9/19/16.
//  Copyright © 2016 Eric Robbins. All rights reserved.
//

import UIKit
import CoreData

class HOFViewController: UIViewController, UITableViewDelegate {
    
    var i:Int = 0
    
    var testContentOne = ["Eric", "Eric's dog", "Erik the Red"]
    var testContentTwo = ["Wayne", "Deshaun", "Greg", "that guy who threw the ball to the ref", "Ray-Ray"]

    func fetchLeaderCount () -> Int {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Leaders")
        
        request.returnsObjectsAsFaults = false
        
        i = 0
        
        do {
            
            let results = try context.executeFetchRequest(request)
            
            for result in results {
                i += 1
            }
            
        } catch {
            print("Fetch failed")
        }

        return i
    }
    
    func fetchLeaderList () -> [NSManagedObject] {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
        let context: NSManagedObjectContext = appDel.managedObjectContext
    
        let request = NSFetchRequest(entityName: "Leaders")
    
        request.returnsObjectsAsFaults = false
    
        do {
            let results = try context.executeFetchRequest(request)
    
            return results as! [NSManagedObject]
    
        } catch {
            print("Fetch failed")
        }

        return []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchLeaderCount()
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        var leaderArray:[String] = []
        var newLeader:String = "Name      Quiz      Score"
        
        //leaderArray.append(newLeader)
        
        let results = fetchLeaderList()
        var resultDict = Dictionary<Int, String>()
    
        
        for result in results {
            newLeader = ""
            newLeader += String(result.valueForKey("userName")!)
            newLeader += "   "
            newLeader += String(result.valueForKey("gameType")!)
            newLeader += "   "
            newLeader += String(result.valueForKey("score")!)
            newLeader += " out of 21"
            
            let index:Int = result.valueForKey("score") as! Int
            resultDict[index] = newLeader
            leaderArray.append(newLeader)
        }
        
        // thanks pulse4life from stack overflow for this code
        var sortedDict = Array(resultDict.keys).sort({resultDict[$0] > resultDict [$1]})
        sortedDict = sortedDict.sort { $0 > $1 }
        
        print(indexPath.row)
        print(sortedDict)
        print(resultDict)
        cell.textLabel?.text = resultDict[sortedDict[indexPath.row]]
        
        return cell				
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
