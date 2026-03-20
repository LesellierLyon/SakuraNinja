//
//  ViewController.swift
//  SakuraNinja
//
//  Created by Tom Lesellier on 27/02/2026.
//

import UIKit

class ViewController: UIViewController {



    @IBOutlet weak var segmentDifficulte: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameViewController {
            destination.difficulte = segmentDifficulte.selectedSegmentIndex
        }
    }


}

