//
//  Piece.swift
//  Chess
//
//  Created by mortal on 15/12/9.
//  Copyright © 2015年 mortal. All rights reserved.
//

import Foundation

public func compare(x:(Int,Int),y:(Int,Int)) ->Bool{
    if x.0 == y.0 && x.1 == y.1 {
        return true
    }
    return false
}

public func moveDirection(from:(Int,Int),to:(Int,Int)) ->(Int,Int){
    return (to.0-from.0,to.1-from.1)
}

public func hasPiece(location:(Int,Int),all:[Piece])-> Bool{
    for piece in all {
        if compare(piece.coordinate, y:location) {
            return true
        }
    }
    return false
}

public func pieceInLocation(location:(Int,Int),from all:[Piece])-> Piece?{
    for piece in all {
        if compare(piece.coordinate, y:location) {
            return piece
        }
    }
    return nil
}
// 保证x<y
public func exchange(inout x:Int,inout y:Int){
    if x > y {
        let temp = x
        x = y
        y = temp
    }
}
public enum Side {
    case Black,Red
}
/**
 *  棋子协议
 */
public protocol Piece {
    var name:String{get}
    var coordinate:(Int,Int){get set}
    var side:Side{get}
    
}
extension Piece {
    mutating func move(from:(Int,Int),to:(Int,Int),all:[Piece]) ->Bool{
        for piece in all {
            if compare(to, y: piece.coordinate) && self.side == piece.side{
                print("是友军")
                return false
            }
        }
        let dr = moveDirection(from, to: to)
        outOne:switch self {
            
        case is 将:
            if from.0 != to.0 && from.1 != to.1 {
                return false
            }
            if to.0 < 4 || to.0 > 6 || to.1 < 1 || to.1 > 3 {
                return false
            }
            
            if abs(dr.0) == 2 || abs(dr.1) == 2 {
                return false
            }
            return true
        case is 士:
            if self.side == .Black {
                inOne:switch self.coordinate{
                    case (4,1),(6,1),(4,3),(6,3):
                        if compare((5,2), y: to) {
                            coordinate = to
                            return true
                        }
                    case (5,2):
                        if compare((4,1), y: to) ||
                            compare((6,1), y: to) ||
                            compare((4,3), y: to) ||
                            compare((6,3), y: to){
                                coordinate = to
                                return true
                    }
                    default:
                        break inOne
                }
                return false
            }else{
                switch self.coordinate{
                case (4,10),(6,10),(4,8),(6,8):
                    if compare((5,9), y: to) {
                        return true
                    }
                case (5,9):
                    if compare((4,10), y: to) ||
                        compare((6,10), y: to) ||
                        compare((4,8), y: to) ||
                        compare((6,8), y: to){
                            return true
                    }
                default:
                    break
                }
                return false
            }
        case is 象:
            
            if abs(dr.0) != 2 || abs(dr.1) != 2 || to.1 > 5 {
                return false
            }
            let mid = ((from.0+to.0)/2,(from.1+to.1)/2)
            return !hasPiece(mid, all: all)
            
        case is 马:
            guard (abs(dr.0) == 1 && abs(dr.1) == 2) || (abs(dr.0) == 2 && abs(dr.1) == 1) else {
                return false
            }
            if abs(dr.0) == 2 {
                let mid = ((from.0+to.0)/2,from.1)
                return !hasPiece(mid, all: all)
            }else {
                let mid = (from.0,(from.1+to.1)/2)
                return !hasPiece(mid, all: all)
            }
        case is 車:
            guard abs(dr.0) == 0 || abs(dr.1) == 0 else {
                return false
            }
            if (abs(dr.0) == 1 || abs(dr.1) == 1){
                //return !hasPiece(to, all: all)
                return true
            }
            if abs(dr.0) == 0 {
                var x = from.1,y = to.1
                exchange(&x, y: &y)
                for i in x+1...y-1 {
                    let mid = (from.0,i)
                    if hasPiece(mid, all: all) {
                        return false
                    }
                }
            }else {
                var x = from.0,y = to.0
                exchange(&x, y: &y)
                for i in x+1...y-1 {
                    let mid = (i,from.1)
                    if hasPiece(mid, all: all) {
                        return false
                    }
                }
            }
            return true
        case is 炮:
            guard abs(dr.0) == 0 || abs(dr.1) == 0 else {
                return false
            }
            if (abs(dr.0) == 1 || abs(dr.1) == 1){
                return !hasPiece(to, all: all)
            }
            
            if let p = pieceInLocation(to, from: all) {
                guard p.side != self.side else {
                    return false
                }
                var count = 0
                if abs(dr.0) == 0 {
                    var x = from.1,y = to.1
                    exchange(&x, y: &y)
                    
                    for i in x+1...y-1 {
                        let mid = (from.0,i)
                        if hasPiece(mid, all: all) {
                            count += 1
                        }
                        
                    }
                }else {
                    var x = from.0,y = to.0
                    exchange(&x, y: &y)
                    for i in x+1...y-1 {
                        let mid = (i,from.1)
                        if hasPiece(mid, all: all) {
                            count += 1
                        }
                    }
                }
                if count == 1 {
                    return true
                }else{
                    return false
                }
            }
            if abs(dr.0) == 0 {
                var x = from.1,y = to.1
                exchange(&x, y: &y)
                for i in x+1...y-1 {
                    let mid = (from.0,i)
                    if hasPiece(mid, all: all) {
                        return false
                    }
                }
            }else {
                var x = from.0,y = to.0
                exchange(&x, y: &y)
                for i in x+1...y-1 {
                    let mid = (i,from.1)
                    if hasPiece(mid, all: all) {
                        return false
                    }
                }
            }
            return true
        case is 卒:
            if let zu = self as? 卒 {
                if !zu.strong {
                    guard dr.0 == 0 && dr.1 == 1 else {
                        return false
                    }
                }else {
                    guard (abs(dr.0) == 1 && dr.1 == 0) || (dr.1 == 1 && dr.0 == 0) else {
                        return false
                    }
                }
                return true
            }
        case is 兵:
            if let bing = self as? 兵 {
                if !bing.strong {
                    guard dr.0 == 0 && dr.1 == -1 else {
                        return false
                    }
                }else {
                    guard (abs(dr.0) == 1 && dr.1 == 0) || (dr.1 == -1 && dr.0 == 0) else {
                        return false
                    }
                }
                return true
            }
        case is 相:
            let dr = moveDirection(from, to: to)
            if abs(dr.0) != 2 || abs(dr.1) != 2 || to.1 < 6 {
                return false
            }
            let mid = ((from.0+to.0)/2,(from.1+to.1)/2)
            for piece in all {
                if compare(piece.coordinate, y: mid) {
                    return false
                }
            }
        case is 帅:
            if from.0 != to.0 && from.1 != to.1 {
                return false
            }
            if to.0 < 4 || to.0 > 6 || to.1 < 8 || to.1 > 10 {
                return false
            }
            let dr = moveDirection(from, to: to)
            if abs(dr.0) == 2 || abs(dr.1) == 2 {
                return false
            }
            return true
            
        default:
            break outOne
        }
        coordinate = to
        return true
    }
}

struct 将:Piece {
    var name:String = {
        return "将"
    }()
    var coordinate:(Int,Int)
    var side:Side
    
    init(){
        coordinate = (5,1)
        side = .Black
    }
}

struct 士:Piece {
    var name:String = {
        return "士"
    }()
    var coordinate:(Int,Int)
    var side:Side
    
    init(coordinate:(Int,Int) = (4,1),side:Side){
        self.coordinate = coordinate
        self.side = side
    }
}

struct 象:Piece {
    var name:String = {
        return "象"
    }()
    var coordinate:(Int,Int)
    var side:Side
    
    init(coordinate:(Int,Int) = (3,1)){
        self.coordinate = coordinate
        side = .Black
    }
}

struct 马:Piece {
    var name:String = {
        return "马"
    }()
    var coordinate:(Int,Int)
    var side:Side
    
    init(coordinate:(Int,Int) = (2,1),side:Side){
        self.coordinate = coordinate
        self.side = side
    }
}

struct 車:Piece {
    var name:String = {
        return "車"
    }()
    var coordinate:(Int,Int)
    var side:Side
    
    init(coordinate:(Int,Int) = (1,1),side:Side){
        self.coordinate = coordinate
        self.side = side
    }
}

struct 炮:Piece {
    var name:String = {
        return "炮"
    }()
    var coordinate:(Int,Int)
    var side:Side
    
    init(coordinate:(Int,Int) = (2,3),side:Side){
        self.coordinate = coordinate
        self.side = side
    }
}

struct 卒:Piece {
    var strong:Bool
    var name:String = {
        return "卒"
    }()
    var coordinate:(Int,Int)
    var side:Side
    
    init(coordinate:(Int,Int) = (1,1),strong:Bool? = false){
        self.coordinate = coordinate
        side = .Black
        self.strong = strong!
    }
}

struct 兵:Piece {
    var strong:Bool
    var name:String = {
        return "兵"
    }()
    var coordinate:(Int,Int)
    var side:Side
    
    init(coordinate:(Int,Int) = (1,1),strong:Bool? = false){
        self.coordinate = coordinate
        side = .Red
        self.strong = strong!
    }
}

struct 相:Piece {
    var name:String = {
        return "相"
    }()
    var coordinate:(Int,Int)
    var side:Side
    
    init(coordinate:(Int,Int) = (4,1)){
        self.coordinate = coordinate
        side = .Red
    }
}

struct 帅:Piece {
    var name:String = {
        return "帅"
    }()
    var coordinate:(Int,Int)
    var side:Side
    
    init(coordinate:(Int,Int) = (5,10)){
        self.coordinate = coordinate
        side = .Red
    }
}

struct Config {
    var blackMove:Bool
    static var shareConfig = Config()
    init(){
        blackMove = true
    }
}
