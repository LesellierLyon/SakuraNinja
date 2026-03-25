//
//  GameViewController.swift
//  SakuraNinja
//
//  Created by Tom Lesellier on 17/03/2026.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {

    
    @IBOutlet weak var vie1: UIImageView!
    @IBOutlet weak var vie2: UIImageView!
    @IBOutlet weak var vie3: UIImageView!
    var nbVie = 0
    var t: Timer!
    var t2: Timer!
    var attente : Int = 0
    var Score : Int = 0

    var screenHeight : Int = 0
    var screenWidth : Int = 0
    var positionx : [Int] = []
    var temps : Int = 0
    var maxSpeed : Int = 0
    
    var difficulte: Int = 1
    
    @IBOutlet weak var boutonpause: UIButton!
    @IBOutlet weak var boutonmenu: UIButton!
    @IBOutlet weak var boutonrejouer: UIButton!
    var vitesses: [UIImageView: CGPoint] = [:]
    var rotations: [UIImageView: CGFloat] = [:]


    @IBOutlet weak var finpartie: UILabel!
    
    @IBOutlet weak var scorelabel: UILabel!
    @IBOutlet weak var fleur1: UIImageView!
    @IBOutlet weak var fleur2: UIImageView!
    @IBOutlet weak var fleur3: UIImageView!
    @IBOutlet weak var fleur4: UIImageView!
    @IBOutlet weak var bombe: UIImageView!
    var fleurs : [UIImageView] = []
    var fleur = UIImageView()

    var dernierPoint: CGPoint?
    var pointActuel: CGPoint?
    
    var explosionPlayer: AVAudioPlayer?
    var katanaPlayer: AVAudioPlayer?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first {
            let p = t.location(in: view)
            dernierPoint = p
            pointActuel = p
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first {
            pointActuel = t.location(in: view)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dernierPoint = nil
        pointActuel = nil
    }
    
    
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
        Score = 0
        scorelabel.text = "Score : \(Score)"
        print(fleur1.frame.origin)
        t = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(boucle), userInfo: nil, repeats: true)
        lancerSpawn()    }
    
    func lancerSpawn() {
        let attente = Double(Int.random(in: 1...4)) * 0.2 * Double(3 - difficulte)
        
        t2 = Timer.scheduledTimer(timeInterval: attente,
                                  target: self,
                                  selector: #selector(activation),
                                  userInfo: nil,
                                  repeats: false)
    }
    
    @objc func activation(_ timer: Timer) {
        let spawnBombe = Int.random(in: 1...6) == 1
        if spawnBombe {
            fleurs = [bombe, fleur1, fleur2, fleur3, fleur4]
        }
        for fleur in fleurs {
            if fleur.isHidden == true{
                fleur.isHidden = false
                fleur.frame.origin = CGPoint(x: positionx[Int.random(in: 0...1)], y: Int.random(in:100...screenHeight))
                if fleur.frame.origin.x < 0 {
                    if Int(fleur.frame.origin.y) <= (screenHeight+100)/2 {
                        vitesses[fleur] = CGPoint(x:maxSpeed, y:Int.random(in: 0...2))
                    }
                    else{
                        vitesses[fleur] = CGPoint(x:maxSpeed, y:Int.random(in: -2...0))
                    }
                }
                else {
                    if Int(fleur.frame.origin.y) <= screenHeight/2 {
                        vitesses[fleur] = CGPoint(x:-maxSpeed, y:Int.random(in: 0...2))
                    }
                    else{
                        vitesses[fleur] = CGPoint(x:-maxSpeed, y:Int.random(in: -2...0))
                    }
                }
                fleur.layer.removeAllAnimations()
                UIView.animate(withDuration: 2, delay: 0, options: [.repeat, .curveLinear], animations: {fleur.transform = fleur.transform.rotated(by: .pi) })
                break
            }
        }
        lancerSpawn()

    }

    func couperFleur(_ fleur: UIImageView) {
        if fleur == bombe {
            let explosion = UIImageView(image: UIImage(named: "explosion"))
            explosion.frame = view.bounds
            view.addSubview(explosion)
            
            if let url = Bundle.main.url(forResource: "explosion", withExtension: "mp3") {
                explosionPlayer = try? AVAudioPlayer(contentsOf: url)
                explosionPlayer?.play()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                explosion.removeFromSuperview()
            }
            
            perdu(fleur)
            fleurs.removeFirst()
            return
        }
        
        if let url = Bundle.main.url(forResource: "katana", withExtension: "mp3") {
            katanaPlayer = try? AVAudioPlayer(contentsOf: url)
            katanaPlayer?.play()
        }
        
        let gauche = UIImageView(image: UIImage(named: "fleur gauche"))
        let droite = UIImageView(image: UIImage(named: "fleur droite"))
        
        let midX = fleur.frame.midX
        let midY = fleur.frame.midY
        let w = fleur.frame.width
        let h = fleur.frame.height
        
        gauche.frame = CGRect(x: midX - w, y: midY - h/2, width: w, height: h)
        droite.frame = CGRect(x: midX, y: midY - h/2, width: w, height: h)
        
        view.addSubview(gauche)
        view.addSubview(droite)
        
        fleur.layer.removeAllAnimations()
        fleur.transform = .identity
        fleur.isHidden = true
        fleur.frame.origin = CGPoint(x: -100, y: 381)
        vitesses[fleur] = CGPoint(x: 0, y: 0)
        
        let gCenter = gauche.center
        let dCenter = droite.center
        
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
            gauche.center = CGPoint(x: gCenter.x - 30, y: gCenter.y + 50)
            droite.center = CGPoint(x: dCenter.x + 30, y: dCenter.y + 50)
            gauche.alpha = 0
            droite.alpha = 0
        }, completion: { _ in
            gauche.removeFromSuperview()
            droite.removeFromSuperview()
        })
        
        Score += 1
        scorelabel.text = "Score : \(Score)"
    }
    
    func perdu(_ fleur: UIImageView){
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
            fleur.layer.removeAllAnimations()
            fleur.transform = .identity
        }
    }
    
    @objc func boucle(_ timer: Timer) {
        for fleur in fleurs {
            if fleur.isHidden == false {
                var p : CGPoint = fleur.frame.origin
                if let v = vitesses[fleur] {
                    p.x += v.x
                    p.y += v.y
                }
                if (-100...screenWidth+100).contains(Int(p.x)) {
                    fleur.frame.origin = p
                }
                else {
                    if fleur != bombe {
                        nbVie+=1
                    }
                    else {
                        fleurs.removeFirst()
                    }
                    fleur.isHidden = true
                    fleur.frame.origin = CGPoint(x:-100, y:381)
                    vitesses[fleur] = CGPoint(x:0, y:0)
                    vie1.isHidden = (nbVie<1)
                    vie2.isHidden = (nbVie<2)
                    vie3.isHidden = (nbVie<3)

                    if nbVie > 2 {
                            perdu(fleur)
                        }
                    }
                }
            }
        if let p1 = dernierPoint, let p2 = pointActuel {
            
            for fleur in fleurs {
                if fleur.isHidden == false {
                    
                    if fleur.frame.contains(p1) || fleur.frame.contains(p2) {
                        couperFleur(fleur)
                    }
                }
            }
            dernierPoint = p2
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenHeight = Int(UIScreen.main.bounds.height)-100
        screenWidth = Int(UIScreen.main.bounds.width)
        positionx = [-100, screenWidth+100]
        fleurs = [fleur1, fleur2, fleur3, fleur4]
        maxSpeed = (difficulte + 2)
        t = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(boucle), userInfo: nil, repeats: true)
                
        lancerSpawn()
    }
    
}
