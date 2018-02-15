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
    var draggableZoneWidth : CGFloat!
    var firstCircle : CircleView?
    var secondCircle : CircleView?
    var firstValue : CGFloat = 0
    var secondValue : CGFloat = 100
    var circlesSize : CGFloat = 32
    
    func calcXposition(percent: CGFloat) -> (left: CGFloat, right: CGFloat) {
        var l =  (draggableZoneWidth * percent / 100) + (1 + 16 + circlesSize/2) - 5
        var r = (draggableZoneWidth * percent / 100) + (1 + 16 + circlesSize/2) + 5
        return (left: l, right: r)
    }
    
    func calcXBoundPosition (center: CGFloat) -> (left: CGFloat, right: CGFloat) {
        var l = center - (circlesSize / 2)
        var r = center - (circlesSize / 2)
        return (left: l, right: r)
    }
    
    
    
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
        
        /*
         *   Calculate width of dragging zone
         */
        draggableZoneWidth = self.bounds.size.width-32-circlesSize-2
        
        
        
        /*
        *   Init left Draggable Circle
        */
        let firstCirclePostion = calcXposition(percent: firstValue).left
        firstCircle = CircleView(frame: CGRect(x: calcXBoundPosition(center: firstCirclePostion).left, y: 18-circlesSize/2, width: circlesSize, height: circlesSize))
        firstCircle?.backgroundColor = UIColor.clear
        firstCircle?.fillColor = tintColor
        self.addSubview(firstCircle!)
        let gestureForFirstValue = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        gestureForFirstValue.delegate = self as UIGestureRecognizerDelegate
        firstCircle!.addGestureRecognizer(gestureForFirstValue)
        
        
        
        /*
         *   Init Right Draggable Circle
         */
        let secondCirclePostion = calcXposition(percent: secondValue).right
        secondCircle = CircleView(frame: CGRect(x:calcXBoundPosition(center: secondCirclePostion).right , y: 18-circlesSize/2, width: circlesSize, height: circlesSize))
        secondCircle?.backgroundColor = UIColor.clear
        secondCircle?.fillColor = tintColor
        self.addSubview(secondCircle!)
        let gestureForSecondValue = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        gestureForSecondValue.delegate = self as UIGestureRecognizerDelegate
        secondCircle!.addGestureRecognizer(gestureForSecondValue)
    }
    
    @objc func handleDrag(recognizer: UIPanGestureRecognizer) {

        let translation = recognizer.translation(in: self)
        if let view = recognizer.view {
            
            if (view == firstCircle && firstCircle!.isScrollable) {
                if (firstValue < secondValue - 10) {
                    firstValue += translation.x * 100 / draggableZoneWidth
                    view.center = CGPoint(x:view.center.x + translation.x, y:18)
                }
                if (firstValue >= secondValue - 10) {
                    firstCircle!.isScrollable = false
                    firstValue = secondValue - 10.01
                    let destination = calcXposition(percent: firstValue).left
                    move(point: view, to: destination)
                }
                if (firstValue < 0) {
                    firstCircle!.isScrollable = false
                    firstValue = 0
                    let destination = calcXposition(percent: firstValue).left
                    print("calculed Size : ", destination)
                    move(point: view, to: destination)
                }
            }
            
            if (view == secondCircle && secondCircle!.isScrollable) {
                if (secondValue > firstValue + 10) {
                    secondValue += translation.x * 100 / draggableZoneWidth
                    view.center = CGPoint(x:view.center.x + translation.x, y:18)
                }
                if (secondValue <= firstValue + 10) {
                    secondCircle!.isScrollable = false
                    secondValue = firstValue + 10.01
                    let destination = calcXposition(percent: secondValue).right
                    move(point: view, to: destination)
                }
                
                if (secondValue > 100) {
                    secondCircle!.isScrollable = false
                    secondValue = 100
                    let destination = calcXposition(percent: secondValue).right
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
        let pointDestination = CGPoint(x: to, y: 18)
        UIView.animate(withDuration: 0.2, animations: {
            point.center = pointDestination
        }, completion: nil)
    }
}
