//
//  SetPage.swift
//  Chess
//
//  Created by mortal on 15/12/10.
//  Copyright © 2015年 mortal. All rights reserved.
//

import UIKit

class SetPage: UIView {
    
    init(){
        super.init(frame:CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        let blur = UIBlurEffect(style:.Light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = bounds
        blurView.layer.opacity = 0.9
        addSubview(blurView)
        setsubView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setsubView(){
        let background = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH/2, height: HEIGHT))
        
    }
}
