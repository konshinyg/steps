//
//  HRViewController.swift
//  urSteps
//
//  Created by Core on 07.09.17.
//  Copyright © 2017 Cornelius. All rights reserved.
//

import UIKit

class HRViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var questions: [String] = ["What's your name?", "Who are you?", "How old are you?", "What do you want from us?"]
    var explanations: [String] =
        ["Please give your full name and surname, also degree or status if you have those",
         "Please give a little overview about yourself, your skills, strong sides, and some of most likely interractions",
         "Means not only your age, but also time of your professional activity",
         "At last, what do you expect from our company and how do you see yourself after 10-15 years"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recCell = tableView.dequeueReusableCell(withIdentifier: "recCell", for: indexPath) as! RecTableViewCell
        recCell.mainTextLabel.text = String(questions[indexPath.row])
        recCell.addTextLabel.text = String(explanations[indexPath.row])
        recCell.delete.isEnabled = false
        recCell.play.isEnabled = false
        recCell.stop.isEnabled = false
        return recCell
    }
    
}
