//
//  TimeLineController.swift
//  TimeLine
//
//  Created by CHERIF Yannis on 13/02/2018.
//  Copyright © 2018 CHERIF Yannis. All rights reserved.
//

import UIKit

class TimeLineControl: UIView, UIGestureRecognizerDelegate {
    
    let verticalPosition : CGFloat = 10
    let circleRadius : CGFloat = 8
    var width : CGFloat!
    var firstCircle : CircleView?
    var secondCircle : CircleView?
    var firstValue : CGFloat = 0
    var secondValue : CGFloat = 100
    
    
    override func draw(_ rect: CGRect) {
        print("Rect : ",rect.size.width)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.addEllipse(in: CGRect(origin: CGPoint(x: 1 , y: verticalPosition), size: CGSize(width: circleRadius * 2, height: circleRadius * 2)))
        ctx?.move(to: CGPoint(x: circleRadius * 2, y: verticalPosition + circleRadius))
        ctx?.addLine(to: CGPoint(x: rect.size.width - circleRadius * 2, y: verticalPosition + circleRadius))
        ctx?.addEllipse(in: CGRect(origin: CGPoint(x:rect.size.width - circleRadius * 2 - 1 , y: 10), size: CGSize(width: circleRadius * 2, height: circleRadius * 2)))
        ctx?.strokePath()
    }
    
    override func awakeFromNib() {
        width = self.bounds.size.width
        print(width)
        let firstCirclePostion = (width * firstValue / 100) + 17
        let secondCirclePostion = (width * secondValue / 100) - 33
        print(secondCirclePostion)
        firstCircle = CircleView(frame: CGRect(x: firstCirclePostion, y: 10, width: 16, height: 16))
        firstCircle?.backgroundColor = UIColor.clear
        firstCircle?.fillColor = tintColor
        firstCircle?.clipsToBounds = false
        secondCircle = CircleView(frame: CGRect(x:secondCirclePostion, y: 10, width: 16, height: 16))
        secondCircle?.backgroundColor = UIColor.clear
        secondCircle?.fillColor = tintColor
        secondCircle?.clipsToBounds = false
        
        
      
            self.addSubview(firstCircle!)
            let gestureForFirstValue = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
            gestureForFirstValue.delegate = self as UIGestureRecognizerDelegate
            firstCircle!.addGestureRecognizer(gestureForFirstValue)
     
        
        
            self.addSubview(secondCircle!)
            let gestureForSecondValue = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
            gestureForSecondValue.delegate = self as UIGestureRecognizerDelegate
            secondCircle!.addGestureRecognizer(gestureForSecondValue)
        
    }
    
    @objc func handleDrag(recognizer: UIPanGestureRecognizer) {

        let translation = recognizer.translation(in: self)
        if let view = recognizer.view {
            
            if (view == firstCircle && firstCircle!.isScrollable) {
                if (firstValue < secondValue - 2) {
                    firstValue += translation.x * 100 / width
                    view.center = CGPoint(x:view.center.x + translation.x, y:18)
                }
                if (firstValue >= secondValue - 4) {
                    firstCircle!.isScrollable = false
                    firstValue -= 3
                    let destination = width * firstValue / 100
                    move(point: view, to: destination)
                }
                if (firstValue < 0) {
                    firstCircle!.isScrollable = false
                    firstValue = 1
                    let destination = width * firstValue / 100
                    move(point: view, to: destination)
                }
            }
            
            if (view == secondCircle && secondCircle!.isScrollable) {
                if (secondValue > firstValue + 2) {
                    secondValue += translation.x * 100 / width
                    view.center = CGPoint(x:view.center.x + translation.x, y:18)
                }
                if (secondValue <= firstValue + 4) {
                    secondCircle!.isScrollable = false
                    secondValue += 3
                    let destination = width * secondValue / 100
                    move(point: view, to: destination)
                }
                
                if (secondValue >= 101) {
                    secondCircle!.isScrollable = false
                    secondValue = 100
                    let destination = width * secondValue / 100
                    move(point: view, to: destination)
                }
            }
            
            if(recognizer.state.rawValue == 3)
            {
                firstCircle!.isScrollable = true
                secondCircle!.isScrollable = true
            }
        }
        recognizer.setTranslation(CGPoint.zero, in: self)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //move(point: firstCircle!, to: 100.00, contextWidth: width )
    }
    
    
//    func move(point: CircleView, to: CGFloat, contextWidth: CGFloat ) {
//        let destination = (width / 100 * to)
//        let pointDestination = CGPoint(x: destination, y: 18)
//        UIView.animate(withDuration: 0.6, animations: {
//            point.center = pointDestination
//        }, completion: nil)
//    }
    
    func percentToPosition () {
        
    }
    
    func move(point: UIView, to: CGFloat) {
        let pointDestination = CGPoint(x: to+16, y: 18)
        UIView.animate(withDuration: 0.2, animations: {
            point.center = pointDestination
        }, completion: nil)
    }
}
