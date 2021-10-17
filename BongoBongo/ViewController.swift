//
//  ViewController.swift
//  BongoBongo
//
//  Created by user204006 on 10/14/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    var timeRemaining: Int = 10
    var timer: Timer!
    var initalizeTimer = false
    
    
    @IBOutlet weak var board: UIView!{
        didSet{
            let tap = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
            board.isUserInteractionEnabled = true
            board.addGestureRecognizer(tap)
            animator = UIDynamicAnimator(referenceView: board)
            behavior = SquareBehavior()
            animator?.addBehavior(behavior!)
        }
    }
    
    private var animator: UIDynamicAnimator?
    private var behavior: SquareBehavior?
    private var squares = [UIView]()
    
    @objc func onTap(_ sender: UITapGestureRecognizer){
        sender.location(in: board)
        let tappedLocation = sender.location(in: board)
        createSquare(at: tappedLocation)
        
        
    }
    
    private func playTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step), userInfo: nil, repeats: true)
    }
    
    @objc func step(){
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timer.invalidate()
            timeRemaining = 10
            startExplosion()
            playTimer()
            
        }
        label.text = "\(timeRemaining)"
    }
    private func checkTimer(){
        if initalizeTimer == false {
            playTimer()
            initalizeTimer = true
        }
    }
    private func resetTimer(){
            timer.invalidate()
            timeRemaining = 10
            label.text = "\(timeRemaining)"
        playTimer()
    }
    
    
    private func createSquare(at point: CGPoint){
        let frame = CGRect(origin: point, size: CGSize(width: 30, height: 30))
        
        let square = UIView(frame: frame)
        square.backgroundColor = UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1)
        
        checkTimer()
        board.addSubview(square)
        squares.append(square)
        behavior?.addItem(square)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onSquare(_ sender: UIButton) {
        
        let x = arc4random() % UInt32(board.bounds.size.width)
        let point = CGPoint(x: Int(x), y: 0)
        createSquare(at: point)
        
    }
    
    @IBAction func onExplode(_ sender: UIButton) {
        startExplosion()
        resetTimer()
    }
    
    private func startExplosion(){
        guard squares.count > 0 else {return}
        
        squares.forEach({behavior?.removeItem($0)})
        
        UIView.animate(withDuration: 1){
            
            self.explodeSquares()
            
        } completion: { (finished) in
            self.squares.forEach({$0.removeFromSuperview()})
            self.squares.removeAll()
            
        }
        
    }
    
    private func explodeSquares(){
        for sq in self.squares{
            let x = arc4random() % UInt32(self.board.bounds.size.width)
            let y = self.board.bounds.size.height
            sq.center = CGPoint(x: CGFloat(x), y: -y)
        }
        
        
    }
    
}

