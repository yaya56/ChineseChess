//
//  ViewController.swift
//  Chess
//
//  Created by mortal on 15/12/9.
//  Copyright © 2015年 mortal. All rights reserved.
//

import UIKit
let SCREEN = UIScreen.mainScreen().bounds
let WIDTH = SCREEN.width
let HEIGHT = SCREEN.height
let EACHW = WIDTH/10
let EACHH = HEIGHT/11
class ViewController: UIViewController {
    var curPiece:Piece?
    var blackMove:Bool?
    var curPoint:Point?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blackMove = true
        let checkerboard = UIImageView(frame:SCREEN)
        checkerboard.userInteractionEnabled = true
        checkerboard.image = UIImage(named: "checkerboard.jpg")
        view.addSubview(checkerboard)
        createPieces()
        createPoint()
        
        
        //print("\(pieces)")
    }
    
    
    var pieces:[Piece]?
    func createPieces(){
        pieces = []
        //黑
        pieces?.append(将())
        pieces?.append(士(coordinate: (4,1), side: .Black))
        pieces?.append(士(coordinate: (6,1), side: .Black))
        pieces?.append(象(coordinate: (3,1)))
        pieces?.append(象(coordinate: (7,1)))
        pieces?.append(马(coordinate: (2,1), side: .Black))
        pieces?.append(马(coordinate: (8,1), side: .Black))
        pieces?.append(車(coordinate: (1,1), side: .Black))
        pieces?.append(車(coordinate: (9,1), side: .Black))
        pieces?.append(炮(coordinate: (2,3), side: .Black))
        pieces?.append(炮(coordinate: (8,3), side: .Black))
        pieces?.append(卒(coordinate: (1,4)))
        pieces?.append(卒(coordinate: (3,4)))
        pieces?.append(卒(coordinate: (5,4)))
        pieces?.append(卒(coordinate: (7,4)))
        pieces?.append(卒(coordinate: (9,4)))
        
        //红
        pieces?.append(帅())
        pieces?.append(士(coordinate: (4,10), side: .Red))
        pieces?.append(士(coordinate: (6,10), side: .Red))
        pieces?.append(相(coordinate: (3,10)))
        pieces?.append(相(coordinate: (7,10)))
        pieces?.append(马(coordinate: (2,10), side: .Red))
        pieces?.append(马(coordinate: (8,10), side: .Red))
        pieces?.append(車(coordinate: (1,10), side: .Red))
        pieces?.append(車(coordinate: (9,10), side: .Red))
        pieces?.append(炮(coordinate: (2,8), side: .Red))
        pieces?.append(炮(coordinate: (8,8), side: .Red))
        pieces?.append(兵(coordinate: (1,7)))
        pieces?.append(兵(coordinate: (3,7)))
        pieces?.append(兵(coordinate: (5,7)))
        pieces?.append(兵(coordinate: (7,7)))
        pieces?.append(兵(coordinate: (9,7)))
        
    }
    
    var points:[Point]?
    func createPoint(){
        points = []
        for p in pieces! {
            let point = Point(co: p.coordinate)
            point.addTarget(self, action: "canChoose:", forControlEvents: .TouchUpInside)
            point.piece = p
            points?.append(point)
            view.addSubview(point)
        }
    }
    
    func canChoose(sender:Point){
        if let piece = curPiece {
            if blackMove! && sender.piece?.side == .Red {
                choosePiece(sender)
            }
            if !blackMove! && sender.piece?.side == .Black {
                choosePiece(sender)
            }
        }else {
            if (blackMove! && sender.piece?.side == .Black) || (!blackMove! && sender.piece?.side == .Red) {
           choosePiece(sender)
            }
        }
    }
    /**
     选择棋子
     
     - parameter sender: 棋子按钮
     */
    func choosePiece(sender:Point){
        //当前有选中 没有选中 是否两次选中一样
        //TODO: 谁走
        if let piece = curPiece {
            if compare(piece.coordinate, y: (sender.piece?.coordinate)!) {
                    curPiece = nil
                    curPoint = nil
                    sender.picked = false
            }else{
                guard curPoint?.piece?.side != sender.piece?.side else {
                    curPoint?.picked = false
                    curPiece = sender.piece!
                    curPoint = sender
                    sender.picked = true
                    return
                }
                
                if var cur = curPiece {
                    let coor = sender.piece?.coordinate
                    if cur.move(cur.coordinate, to: coor!,all:pieces!) {
                        print("\(self.curPoint?.piece?.coordinate)")
                        UIView.animateWithDuration(0.7, animations: { () -> Void in
                            self.curPoint?.coor = coor!
                            }, completion: { (finish) -> Void in
                                self.curPoint?.picked = false
                                self.curPoint?.piece?.coordinate = coor!
                                if self.curPoint?.piece is 兵 {
                                    if coor!.1 == 5 {
                                        self.curPoint?.piece = 兵(coordinate: coor!,strong: true)
                                    }
                                }
                                if self.curPoint?.piece is 卒 {
                                    if coor!.1 == 6 {
                                        self.curPoint?.piece = 卒(coordinate: coor!,strong:true)
                                    }
                                }
                                //print("\(self.points?.count)")
                                self.points?.removeAtIndex((self.points?.indexOf(sender))!)
                                sender.removeFromSuperview()
                                //print("\(self.points?.count)")
                                self.pieces?.removeAll()
                                for point in self.points! {
                                    self.pieces?.append(point.piece!)
                                }
                                //print("\(self.curPoint?.piece?.coordinate)")
                                //print("\(self.curPiece)")
                                self.curPoint = nil
                                self.curPiece = nil
                                self.blackMove = !self.blackMove!
                                self.check()
                        })
                    }
                }

                
            }
            
        }else{
            sender.picked = true
            curPiece = sender.piece
            curPoint = sender
        }
        //print("\(curPoint)")
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch?.locationInView(view)
        if let coor = checkCoordinate(location!) {
            if var cur = curPiece {
                if cur.move(cur.coordinate, to: coor,all:pieces!) {
                    print("\(self.curPoint?.piece?.coordinate)")
                    UIView.animateWithDuration(0.7, animations: { () -> Void in
                        self.curPoint?.coor = coor
                        }, completion: { (finish) -> Void in
                           self.curPoint?.picked = false
                            self.curPoint?.piece?.coordinate = coor
                            if self.curPoint?.piece is 兵 {
                                if coor.1 == 5 {
                                   self.curPoint?.piece = 兵(coordinate: coor,strong: true)
                                }
                            }
                            if self.curPoint?.piece is 卒 {
                                if coor.1 == 6 {
                                    self.curPoint?.piece = 卒(coordinate: coor,strong:true)
                                }
                            }
                            self.pieces?.removeAll()
                            for point in self.points! {
                                self.pieces?.append(point.piece!)
                            }
                            print("\(self.curPoint?.piece?.coordinate)")
                            //print("\(self.curPiece)")
                            self.curPoint = nil
                            self.curPiece = nil
                            self.blackMove = !self.blackMove!
                            self.check()
                    })
                }
            }
        }
    }
    func checkCoordinate(location:CGPoint)->(Int,Int)?{
        var i:Int = Int(location.x/EACHW)
        var j:Int = Int(location.y/EACHH)
        let x = location.x % EACHW
        let y = location.y % EACHH
        //print("\(i)-------\(x)------\(location.x)-----\(EACHW)")
        if x > EACHW/2+10 {
           i += 1
        }
        if y > EACHH/2+10 {
            j += 1
            
        }
        if (x > EACHW/2-10 && x < EACHW/2+10) || (y > EACHH/2 - 10 && y < EACHH/2+10){
            return nil
        }
        if i == 0 || j == 0 || j>=11 || i >= 10 {
            return nil
        }
        return (i,j)
    }
    /**
     检查 将 帅状态
     */
    func check (){
        var j,s :Piece?
        for piece in pieces! {
            if piece is 将 {
                j = piece as!将
            }
            if piece is 帅 {
                s = piece as! 帅
            }
        }
        if j == nil {
            print("黑棋输")
            return
        }
        if s == nil {
            print("红棋输")
            return
        }
        if j!.coordinate.0 == s!.coordinate.0 {
            var x = j?.coordinate.1
            var y = s?.coordinate.1
            exchange(&x!, y: &y!)
            var hasPieces = false
            for i in x!+1...y!-1 {
                let b = !hasPiece((j!.coordinate.0,i), all: pieces!)
                print("\(b)")
                if hasPiece((j!.coordinate.0,i), all: pieces!) {
                    hasPieces = true
                }
            }
            if !hasPieces {
                
                if blackMove! {
                    print("黑赢")
                    return
                }else {
                    print("红赢")
                    return
                }
            }
        }
    }
}

class Point: UIButton {
    var picked:Bool{
        didSet{
            if (picked) {
                backgroundColor = UIColor.lightGrayColor()
            }else{
                backgroundColor = UIColor.grayColor()
            }
        }
    }
    var piece:Piece? {
        didSet{
            if piece?.side == .Red {
                setTitleColor(UIColor.redColor(), forState: .Normal)
            }else{
                setTitleColor(UIColor.blackColor(), forState: .Normal)
                layer.transform = CATransform3DMakeRotation(CGFloat(M_PI), 0, 0, 1)
            }
            setTitle(piece?.name, forState: .Normal)
            titleLabel?.font = UIFont.systemFontOfSize(30, weight: 5)
        }
    }
    var coor:(Int,Int) {
        didSet {
            layer.position = CGPoint(x: WIDTH/10*CGFloat(coor.0), y: HEIGHT/11*CGFloat(coor.1))
        }
    }
    init(co:(Int,Int)){
        coor = co
        picked = false
        super.init(frame: CGRect(x: 0, y: 0, width: WIDTH/10-15, height: WIDTH/10-15))
        layer.position = CGPoint(x: WIDTH/10*CGFloat(co.0), y: HEIGHT/11*CGFloat(co.1))
        layer.cornerRadius = WIDTH/20-15/2
        backgroundColor = UIColor.grayColor()
        //backgroundColor = UIColor.redColor()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
