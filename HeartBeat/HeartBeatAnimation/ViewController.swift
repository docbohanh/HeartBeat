//
//  ViewController.swift
//  HeartBeatAnimation
//
//  Created by Thành Lã on 2/27/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func showDragDropView() {
        let dragDropViewController = DragDropViewController()
        dragDropViewController.completion = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        self.present(dragDropViewController, animated: true, completion: nil)
    }
}

