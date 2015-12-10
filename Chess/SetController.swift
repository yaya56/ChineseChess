//
//  SetController.swift
//  Chess
//
//  Created by mortal on 15/12/10.
//  Copyright © 2015年 mortal. All rights reserved.
//

import UIKit

@objc protocol SetDelegate {
    func reset()
}

class SetController: UIViewController {
    
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var background: UIView!
    weak var delegate :SetDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        background.frame = CGRectMake(WIDTH/4, HEIGHT/4, WIDTH/2, HEIGHT/2)

        //background.center = view.center
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if Config.shareConfig.blackMove {
            firstBtn.setTitle("红先", forState: .Normal)
        }else {
            firstBtn.setTitle("黑先", forState: .Normal)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func first(sender: UIButton) {
        if sender.titleLabel?.text == "红先" {
            Config.shareConfig.blackMove = false
            sender.setTitle("黑先", forState: .Normal)
        }else {
            Config.shareConfig.blackMove = true
            sender.setTitle("红先", forState: .Normal)
        }
        delegate?.reset()
    }

    @IBAction func close(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func reset(sender: UIButton) {
        delegate?.reset()
        dismissViewControllerAnimated(false, completion: nil)
    }
    @IBAction func surrender(sender: UIButton) {
    }
    /**
     蓝牙连接
     
     - parameter sender: 按钮
     */
    @IBAction func blueTooth(sender: UIButton) {
        
    }
    
    
}
