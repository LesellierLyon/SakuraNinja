//
//  GameViewController.swift
//  SakuraNinja
//
//  Created by Tom Lesellier on 17/03/2026.
//

import UIKit

class GameViewController: UIViewController {

    
    @IBOutlet weak var vie1: UIImageView!
    @IBOutlet weak var vie2: UIImageView!
    @IBOutlet weak var vie3: UIImageView!
    var nbVie = 0
    var t: Timer!
    var t2: Timer!
    var screenHeight : Int = 0
    var screenWidth : Int = 0
    var positionx : [Int] = []
    
    @IBOutlet weak var boutonpause: UIButton!
    @IBOutlet weak var boutonmenu: UIButton!
    @IBOutlet weak var boutonrejouer: UIButton!
    var v = CGPoint(x:0, y:0)
    
    @IBOutlet weak var finpartie: UILabel!
    @IBOutlet weak var Fleur: UIImageView!
    
    @IBAction func rejouer(_ sender: Any) {
        nbVie=0
        vie1.isHidden=true
        vie2.isHidden=true
        vie3.isHidden=true
        finpartie.isHidden=true
        boutonmenu.isHidden=true
        boutonrejouer.isHidden=true
        boutonpause.isHidden=false
        viewDidLoad()
    }
    @objc func deplace(t2: Timer) {
        Fleur.frame.origin = CGPoint(x: positionx[Int.random(in: 0...1)], y: Int.random(in:100...screenHeight))
        t = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(boucle), userInfo: nil, repeats: true)
        if Fleur.frame.origin.x < 0 {
            if Int(Fleur.frame.origin.y) <= (screenHeight+100)/2 {
                v = CGPoint(x:4, y:Int.random(in: 0...2))
            }
            else{
                v = CGPoint(x:4, y:Int.random(in: -2...0))
            }
        }
        else {
            if Int(Fleur.frame.origin.y) <= screenHeight/2 {
                v = CGPoint(x:-4, y:Int.random(in: 0...2))
            }
            else{
                v = CGPoint(x:-4, y:Int.random(in: -2...0))
            }
        }
    }
    
    @objc func boucle(t: Timer) {
        var p : CGPoint = Fleur.frame.origin
        p.x += v.x
        p.y += v.y
        if (-100...screenWidth+100).contains(Int(p.x)) {
        }
        else {
            nbVie+=1
            t.invalidate()
            p.x = p.x - v.x
            p.y = p.y - v.y
            vie1.isHidden = (nbVie<=1)
            vie2.isHidden = (nbVie<=2)
            vie3.isHidden = (nbVie<=3)
            if nbVie>3 {
                t2.invalidate()
                finpartie.isHidden = false
                boutonmenu.isHidden = false
                boutonrejouer.isHidden = false
                boutonpause.isHidden = true
            }
        }
        Fleur.frame.origin = p
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenHeight = Int(UIScreen.main.bounds.height)-100
        screenWidth = Int(UIScreen.main.bounds.width)
        positionx = [-50, screenWidth+50]
        
        t = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(boucle), userInfo: nil, repeats: true)
        
        t2 = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(deplace), userInfo: nil, repeats: true)

    }
    
}
