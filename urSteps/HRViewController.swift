//
//  HRViewController.swift
//  urSteps
//
//  Created by Core on 07.09.17.
//  Copyright © 2017 Cornelius. All rights reserved.
//

import UIKit

class HRViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var questions: [String] = ["Who are you?", "What's your name?", "How old are you?", "What do you want from me?"]
    
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
        recCell.delete.isEnabled = false
        recCell.play.isEnabled = false
        recCell.stop.isEnabled = false
        return recCell
    }
    
}
