//
//  ViewController.swift
//  Whiteboard
//
//  Created by Steven Brice  on 4/28/15.
//  Copyright (c) 2015 Steven Brice. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a new instance of the WhiteBoard
        // Set the Bounds to the current Views bounds
        let board = WhiteBoard(frame: view.bounds)
        
        
        // Add WhiteBoard as a subview of the current view
        view.addSubview(board);
        
        let alert = UIAlertView()
        alert.title = "Welcome"
        alert.message = "Touch Anywhere To Draw"
        alert.addButtonWithTitle("Ok")
        alert.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}