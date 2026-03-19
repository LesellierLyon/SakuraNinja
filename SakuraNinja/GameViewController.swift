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
    var attente : Int = 0

    var screenHeight : Int = 0
    var screenWidth : Int = 0
    var positionx : [Int] = []
    var temps : Int = 0
    
    @IBOutlet weak var boutonpause: UIButton!
    @IBOutlet weak var boutonmenu: UIButton!
    @IBOutlet weak var boutonrejouer: UIButton!
    var vitesses: [UIImageView: CGPoint] = [:]

    @IBOutlet weak var finpartie: UILabel!
    
    @IBOutlet weak var fleur1: UIImageView!
    @IBOutlet weak var fleur2: UIImageView!
    @IBOutlet weak var fleur3: UIImageView!
    @IBOutlet weak var fleur4: UIImageView!
    var fleurs : [UIImageView] = []
    let fleur = UIImageView()

    
    @IBAction func rejouer(_ sender: Any) {
        nbVie=0
        vie1.isHidden=true
        vie2.isHidden=true
        vie3.isHidden=true
        finpartie.isHidden=true
        boutonmenu.isHidden=true
        boutonrejouer.isHidden=true
        boutonpause.isHidden=false
        fleur1.isHidden=true
        fleur2.isHidden=true
        fleur3.isHidden=true
        fleur4.isHidden=true
        print(fleur1.frame.origin)
        t = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(boucle), userInfo: nil, repeats: true)
        lancerSpawn()    }
    
    func lancerSpawn() {
        let attente = Double(Int.random(in: 1...4)) * 0.2
        
        t2 = Timer.scheduledTimer(timeInterval: attente,
                                  target: self,
                                  selector: #selector(activation),
                                  userInfo: nil,
                                  repeats: false)
    }
    
    @objc func activation(_ timer: Timer) {
        for fleur in fleurs {
            if fleur.isHidden == true{
                fleur.isHidden = false
                fleur.frame.origin = CGPoint(x: positionx[Int.random(in: 0...1)], y: Int.random(in:100...screenHeight))
                if fleur.frame.origin.x < 0 {
                    if Int(fleur.frame.origin.y) <= (screenHeight+100)/2 {
                        vitesses[fleur] = CGPoint(x:4, y:Int.random(in: 0...2))
                    }
                    else{
                        vitesses[fleur] = CGPoint(x:4, y:Int.random(in: -2...0))
                    }
                }
                else {
                    if Int(fleur.frame.origin.y) <= screenHeight/2 {
                        vitesses[fleur] = CGPoint(x:-4, y:Int.random(in: 0...2))
                    }
                    else{
                        vitesses[fleur] = CGPoint(x:-4, y:Int.random(in: -2...0))
                    }
                }
                break
            }
        }
        lancerSpawn()

    }

    
    @objc func boucle(_ timer: Timer) {
        for fleur in fleurs {
            if fleur.isHidden == false {
                var p : CGPoint = fleur.frame.origin
                if let v = vitesses[fleur] {
                    p.x += v.x
                    p.y += v.y
                }
                if (-100...screenWidth+100).contains(Int(p.x)){
                    fleur.frame.origin = p
                }
                else {
                    nbVie+=1
                    fleur.isHidden = true
                    fleur.frame.origin = CGPoint(x:-100, y:381)
                    vitesses[fleur] = CGPoint(x:0, y:0)
                    vie1.isHidden = (nbVie<1)
                    vie2.isHidden = (nbVie<2)
                    vie3.isHidden = (nbVie<3)

                    if nbVie > 2 {
                        t.invalidate()
                        t2.invalidate()
                        finpartie.isHidden = false
                        boutonmenu.isHidden = false
                        boutonrejouer.isHidden = false
                        boutonpause.isHidden = true
                        for fleur in fleurs {
                            fleur.isHidden = true
                            fleur.frame.origin = CGPoint(x:-100, y:381)
                            vitesses[fleur] = CGPoint(x:0, y:0)
                        }
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenHeight = Int(UIScreen.main.bounds.height)-100
        screenWidth = Int(UIScreen.main.bounds.width)
        positionx = [-100, screenWidth+100]
        fleurs = [fleur1, fleur2, fleur3, fleur4]
        
        t = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(boucle), userInfo: nil, repeats: true)
                
        lancerSpawn()
    }
    
}
