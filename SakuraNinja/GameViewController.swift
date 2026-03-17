//
//  GameViewController.swift
//  SakuraNinja
//
//  Created by Tom Lesellier on 17/03/2026.
//

import UIKit

class GameViewController: UIViewController {

    
    var t: Timer!
    var screenHeight : Int = 0
    var screenWidth : Int = 0
    var positionx : [Int] = []
    
    var v = CGPoint(x:0, y:0)
    
    @IBOutlet weak var Fleur: UIImageView!
    
    @IBAction func deplace(_ sender: Any) {
        Fleur.frame.origin = CGPoint(x: positionx[Int.random(in: 0...1)], y: Int.random(in:100...screenHeight))
        if Fleur.frame.origin.x < 0 {
            if Int(Fleur.frame.origin.y) <= (screenHeight+100)/2 {
                v = CGPoint(x:2, y:Int.random(in: 0...2))
            }
            else{
                v = CGPoint(x:2, y:Int.random(in: -2...0))
            }
        }
        else {
            if Int(Fleur.frame.origin.y) <= screenHeight/2 {
                v = CGPoint(x:-2, y:Int.random(in: 0...2))
            }
            else{
                v = CGPoint(x:-2, y:Int.random(in: -2...0))
            }
        }
        if v.y == 0 {
            v.x *= 2
        }
    }
    @objc func boucle(t: Timer) {
        var p : CGPoint = Fleur.frame.origin
        p.x += v.x
        p.y += v.y
        Fleur.frame.origin = p
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenHeight = Int(UIScreen.main.bounds.height)-100
        screenWidth = Int(UIScreen.main.bounds.width)
        positionx = [-50, screenWidth+50]
        
        t = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(boucle), userInfo: nil, repeats: true)
    }
    
}
