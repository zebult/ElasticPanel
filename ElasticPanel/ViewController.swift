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
    private let distanceX: CGFloat = 10;

    private let distanceY: CGFloat = 10;

    enum Direction
    {
        case none
        case left
        case down
        case up
        case right
    }

    func getDirection(key: String)->Direction
    {
        switch key {
            case "h":

                return Direction.left;
            case "j":

                return Direction.down;
            case "k":

                return Direction.up;
            case "l":

                return Direction.right;
            default:

                return Direction.none;
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        NSEvent.addLocalMonitorForEvents(matching:.keyDown) {
            (event)->NSEvent? in
            self.keyDown(with : event)

            return event
        }
    }

    override func viewWillAppear()
    {
        super.viewWillAppear();
        self.view.window!.hasShadow = false;
    }

    override func keyDown(with event : NSEvent)
    {
        let key       = String(describing : event.characters!);
        let direction = getDirection(key: key);

        resizeWindow(direction: direction);
    }

    func resizeWindow(direction : Direction)
    {
        let frame = self.view.window!.frame;

        switch direction
        {
            case Direction.left:
                self.view.window?.setFrame(NSRect(x: frame.minX - self.distanceX, y: frame.minY, width: frame.width + self.distanceX, height: frame.height), display: true)
            case Direction.down :

                self.view.window?.setFrame(NSRect(x: frame.minX, y: frame.minY - self.distanceY, width: frame.width, height: frame.height + self.distanceY), display: true)
            case Direction.up :

                self.view.window?.setFrame(NSRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height + self.distanceY), display: true)
            case Direction.right :

                self.view.window?.setFrame(NSRect(x: frame.minX, y: frame.minY, width: frame.width + self.distanceX, height: frame.height), display: true)
            default :

                return;
        }
    }
}
