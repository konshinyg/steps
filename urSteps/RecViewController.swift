//
//  RecViewController.swift
//  urSteps
//
//  Created by Core on 11.08.17.
//  Copyright © 2017 Cornelius. All rights reserved.
//

import UIKit

class RecViewController: UICollectionViewController {
    
    var questions: [String] = ["Who are you?", "What's your name?", "How old are you?", "What do you want from me?", "How long will it take?", "What time is it?", "Where are we?", "How much does it cost?"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.label.text = String(questions[indexPath.row])
        cell.delete.isEnabled = false
        cell.play.isEnabled = false
        cell.stop.isEnabled = false
        return cell
    }
}
