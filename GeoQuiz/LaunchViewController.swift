//
//  LaunchViewController.swift
//  GeoQuiz
//
//  Created by Eric Robbins on 9/18/16.
//  Copyright © 2016 Eric Robbins. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var quizzes: [String] = [String]()
    var selectedQuiz:String = ""
    
    @IBOutlet weak var nameEntry: UITextField!
    
    @IBOutlet weak var quizPicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.quizPicker.delegate = self
        self.quizPicker.dataSource = self
        quizzes = ["World Cities", "College Towns"]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LaunchToMain" {
            if let dest = segue.destinationViewController as? ViewController {
                dest.quizType = selectedQuiz
                dest.userName = nameEntry.text!
            }
            
        }
    }
    
    @IBAction func launchButton(sender: AnyObject) {
        self.performSegueWithIdentifier("LaunchToMain", sender: self)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return quizzes.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return quizzes[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedQuiz = quizzes[row]
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
