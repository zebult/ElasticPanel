/*
 *
 *  ViewController.swift
 *  ElasticPanel
 *
 *  Created by 鈴木 才智 on 2018/07/07.
 *  Copyright © 2018年 鈴木 才智. All rights reserved.
 *
 */

import Cocoa

class ViewController: NSViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()

        NSEvent.addLocalMonitorForEvents(matching:.keyDown) {
            (event)->NSEvent? in
            self.keyDown(with : event)

            return event
        }
    }

    override func keyDown(with event : NSEvent)
    {
        print(String(describing: event.characters!))
    }
}
