//
//  TimeLineController.swift
//  TimeLine
//
//  Created by CHERIF Yannis on 13/02/2018.
//  Copyright © 2018 CHERIF Yannis. All rights reserved.
//

import UIKit

protocol TimeLineControlDelegate: class {
    func userIsDragging(_ values: Array<CGFloat>)
    func userDidEndDrag(_ values: Array<CGFloat>)
}

class TimeLineControl: UIView, UIGestureRecognizerDelegate {
    
    private let verticalPosition : CGFloat = 10
    private let circleRadius : CGFloat = 8
    private var draggableZoneWidth : CGFloat!
    private var firstCircle : CircleView?
    private var secondCircle : CircleView?
    private var line : LineView?
    @IBInspectable var firstValue : CGFloat = 50
    @IBInspectable var secondValue : CGFloat = 100
    @IBInspectable var circlesSize : CGFloat = 32
    @IBInspectable var timelineMode : Bool = false
    @IBInspectable var timelineSteps : Int = 5
    @IBInspectable var timelineInitSteps : Int = 1
    private var viewDidInit = false
    private var circles : Array<CircleView> = []
    weak var delegate: TimeLineControlDelegate?

    
    
    /*
     *   Dessin du slider
     */
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        let width  = rect.size.width - circleRadius * 4 - 2
        
        if timelineMode {
            let intervalBetweenCircles = (width - ( CGFloat(timelineSteps) * (2*circleRadius)))/CGFloat(timelineSteps) - 1
            for i in 0..<timelineSteps + 1 {
                let strokes = (CGFloat(i) * intervalBetweenCircles)
                let circles = (CGFloat(i) * (circleRadius*2)) + (circleRadius*2) + 1
                let startStroke = strokes + circles
                ctx?.addEllipse(in: CGRect(origin: CGPoint(x: startStroke - (circleRadius*2), y: verticalPosition), size: CGSize(width: circleRadius * 2, height: circleRadius * 2)))
                if (i != timelineSteps) {
                    ctx?.move(to: CGPoint(x: startStroke, y: verticalPosition + circleRadius))
                    ctx?.addLine(to: CGPoint(x: startStroke + intervalBetweenCircles, y: verticalPosition + circleRadius))
                }
            }
        } else {
            ctx?.addEllipse(in: CGRect(origin: CGPoint(x: 1 , y: verticalPosition), size: CGSize(width: circleRadius * 2, height: circleRadius * 2)))
            ctx?.move(to: CGPoint(x: circleRadius * 2, y: verticalPosition + circleRadius))
            ctx?.addLine(to: CGPoint(x: rect.size.width - circleRadius * 2, y: verticalPosition + circleRadius))
            ctx?.addEllipse(in: CGRect(origin: CGPoint(x:rect.size.width - circleRadius * 2 - 1 , y: 10), size: CGSize(width: circleRadius * 2, height: circleRadius * 2)))
        }
        
        ctx?.strokePath()
    }
    
    
    
    /*
     *   Constructeur de la View
     */
    override func awakeFromNib() {
        draggableZoneWidth = self.bounds.size.width-circlesSize-2
        if (!timelineMode) {
            
            /*
            *   Init left Draggable Circle
            */
            let firstCirclePostion = calcXposition(percent: 0).left
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
            let secondCirclePostion = calcXposition(percent: 100).right
            secondCircle = CircleView(frame: CGRect(x:calcXBoundPosition(center: secondCirclePostion).right , y: 18-circlesSize/2, width: circlesSize, height: circlesSize))
            secondCircle?.backgroundColor = UIColor.clear
            secondCircle?.fillColor = tintColor
            self.addSubview(secondCircle!)
            let gestureForSecondValue = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
            gestureForSecondValue.delegate = self as UIGestureRecognizerDelegate
            secondCircle!.addGestureRecognizer(gestureForSecondValue)
        }
    }
    
    
    
    /*
     *   Initialise line & scale
     */
    override func layoutSubviews() {
        if (!viewDidInit) {
            draggableZoneWidth = self.bounds.size.width-circlesSize-2
            drawInitialLine()
            if !timelineMode {
               changeValues(first: firstValue, second: secondValue)
            }
            viewDidInit = !viewDidInit
        }
    }
    
    
    
    /*
     *   Gestion du drag
     */
    @objc func handleDrag(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        if let view = recognizer.view {
            
            //gestion pour le premier cercle
            if (view == firstCircle && firstCircle!.isScrollable) {
                if (firstValue < secondValue - 10) {
                    drag(circle: view, to: translation.x, value: "firstValue")
                    moveLineToCenter(animated: false)
                    changeLineSize(animated: false)
                }
                if (firstValue > secondValue - 10) {
                    firstCircle!.isScrollable = false
                    firstValue = secondValue - 10.1
                    let destination = calcXposition(percent: firstValue).left
                    move(point: view, to: destination)
                    moveLineToCenter(animated: false)
                    changeLineSize(animated: false)
                    
                }
                if (firstValue < 0) {
                    firstCircle!.isScrollable = false
                    firstValue = 0
                    let destination = calcXposition(percent: firstValue).left
                    move(point: view, to: destination)
                    moveLineToCenter(animated: false)
                    changeLineSize(animated: false)
                }
                delegate?.userIsDragging([firstValue, secondValue])
            }
            
            //gestion pour le deuxieme cercle
            if (view == secondCircle && secondCircle!.isScrollable) {
                if (secondValue > firstValue + 10) {
                    drag(circle: view, to: translation.x, value: "secondValue")
                    moveLineToCenter(animated: false)
                    changeLineSize(animated: false)
                }
                if (secondValue < firstValue + 10) {
                    secondCircle!.isScrollable = false
                    secondValue = firstValue + 10.1
                    let destination = calcXposition(percent: secondValue).right
                    move(point: view, to: destination)
                    moveLineToCenter(animated: false)
                    changeLineSize(animated: false)
                }
                
                if (secondValue > 100) {
                    secondCircle!.isScrollable = false
                    secondValue = 100
                    let destination = calcXposition(percent: secondValue).right
                    move(point: view, to: destination)
                    moveLineToCenter(animated: false)
                    changeLineSize(animated: false)
                }
                delegate?.userIsDragging([firstValue, secondValue])
            }
            
            // lors du relachement
            if(recognizer.state.rawValue == 3) {
                firstCircle!.isScrollable = true
                secondCircle!.isScrollable = true
                delegate?.userDidEndDrag([firstValue, secondValue])
            }
        }
        
        recognizer.setTranslation(CGPoint.zero, in: self)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let width  = self.bounds.width - circleRadius * 4 - 2
        let intervalBetweenCircl = (width - ( CGFloat(timelineSteps) * (2*circleRadius)))/CGFloat(timelineSteps) - 1

        let lineSize = ((5-2) * (2 * circleRadius) + ((5-1) * intervalBetweenCircl))
        let lineCenter = lineSize/2 + (2 * circleRadius) + 1
        UIView.animate(withDuration: 0.5, animations: {
            self.line!.bounds.size.width = lineSize
        }, completion: nil)
        UIView.animate(withDuration: 0.5, animations: {
            self.line?.center = CGPoint(x: lineCenter, y: 18)
        }, completion: nil)
        drawCircles(nbCirclesToDraw: 5, timelineWidth: width )
        
    }
    
    
    /*
     *   Anim change firstValue
     */
    public func changeFirstValue(to: CGFloat) {
        firstValue = to
        let destination = calcXposition(percent: firstValue).left
        move(point: firstCircle!, to: destination)
        moveLineToCenter(animated: true)
        changeLineSize(animated: true)
    }
    
    
    /*
     *  Anim change secondValue
     */
    public func changeSecondValue(to: CGFloat) {
        secondValue = to
        let destination = calcXposition(percent: secondValue).right
        move(point: secondCircle!, to: destination)
        moveLineToCenter(animated: true)
        changeLineSize(animated: true)
    }
    
    /*
     *   Anim change both Value
     */
    public func changeValues(first: CGFloat, second: CGFloat) {
        firstValue = first
        secondValue = second
        let destinationFirst = calcXposition(percent: firstValue).left
        let destinationSecond = calcXposition(percent: secondValue).right
        move(point: firstCircle!, to: destinationFirst)
        move(point: secondCircle!, to: destinationSecond)
        moveLineToCenter(animated: true)
        changeLineSize(animated: true)
    }
    
    
    
    
    
    
    
    
    
/*  ==========================================================
    == Helper Functions ==
    ======================================================= */
    
    /*
     *   Init Line
     */
    private func drawInitialLine() {
        if timelineMode {
            if (timelineInitSteps <= timelineSteps) {
                timelineSteps = timelineSteps - 1
                let width  = self.bounds.width - circleRadius * 4 - 2
                let intervalBetweenCircl = (width - ( CGFloat(timelineSteps) * (2*circleRadius)))/CGFloat(timelineSteps) - 1
                let x = CGFloat(timelineInitSteps == 0 ? 0 : timelineInitSteps - 1)
                let lineSizeforInit = (x-1) * (2 * circleRadius) + x * intervalBetweenCircl
                line = LineView(frame: CGRect(x: 17 , y: 12, width: lineSizeforInit, height: 13))
                line?.backgroundColor = UIColor.clear
                line?.fillColor = tintColor
                drawCircles(nbCirclesToDraw: timelineInitSteps, timelineWidth: intervalBetweenCircl )
            }
        } else {
            line = LineView(frame: CGRect(x: calcStartLine(percent: firstValue) , y: 12, width: calculateLineSize(), height: 13))
            line?.backgroundColor = UIColor.clear
            line?.fillColor = tintColor
        }
        self.addSubview(line!)
    }
    
    private func drawCircles(nbCirclesToDraw : Int, timelineWidth: CGFloat) {
        let drawedCircles = circles.count
        let intervalBetweenCircl = (timelineWidth - ( CGFloat(timelineSteps) * (2*circleRadius)))/CGFloat(timelineSteps) - 1
        if drawedCircles != 0 {
            let circleLeftToDraw =  nbCirclesToDraw - circles.count
            if circleLeftToDraw > 0 {
                var i : Int = 0
                repeat {
                    let sumCircles = CGFloat(drawedCircles) * (2*circleRadius)
                    let sumInterval = CGFloat(drawedCircles) * intervalBetweenCircl
                    let pos = sumCircles + sumInterval - 5
                    //circles.append(createCircleWithAnimation(x: pos, y: 18-circlesSize/2))
                    i = i + 1
                    print(i)
                } while i < circleLeftToDraw
            }
            if circleLeftToDraw < 0 {
                var i : Int = circleLeftToDraw
                repeat {
                    let tableIndex = circles.count-1
                    circles[tableIndex].removeFromSuperview()
                    circles.remove(at: tableIndex)
                    i = i + 1
                } while i < 0
            }
        } else {
            var i : Int = 0
            repeat {
                let circlePostion = drawCircles_calcXposition(index: i, width: timelineWidth)
                let circle = CircleView(frame: CGRect(x: circlePostion, y: 18-circlesSize/2, width: circlesSize, height: circlesSize))
                circle.backgroundColor = UIColor.clear
                circle.fillColor = tintColor
                circles.append(circle)
                self.addSubview(circles.last!)
                i = i + 1
            } while i < nbCirclesToDraw
        }
        
    }
    
    private func drawCircles_calcXposition(index: Int, width: CGFloat) -> CGFloat {
        return ((2*circleRadius + width) * CGFloat(index)) - 5
    }
    
    private func createCircleWithAnimation(x: CGFloat, y: CGFloat) -> CircleView {
        let x = x + self.circlesSize / 2
        let y = y + self.circlesSize / 2
        let circle = CircleView(frame: CGRect(x: x, y: y, width: 0, height: 0))
        circle.backgroundColor = UIColor.clear
        circle.fillColor = tintColor
        circles.append(circle)
        self.addSubview(circles.last!)
        UIView.animate(withDuration: 0.6, animations: {
            circle.bounds.size.width = self.circlesSize
            circle.bounds.size.height = self.circlesSize
        }, completion: nil)
        return circle
    }
    
    private func calcXposition(percent: CGFloat) -> (left: CGFloat, right: CGFloat) {
        let l =  (draggableZoneWidth * percent / 100) + (1  + circlesSize/2) - 5
        let r = (draggableZoneWidth * percent / 100) + (1  + circlesSize/2) + 5
        return (left: l, right: r)
    }
    
    private func calcXBoundPosition (center: CGFloat) -> (left: CGFloat, right: CGFloat) {
        let l = center - (circlesSize / 2)
        let r = center - (circlesSize / 2)
        return (left: l, right: r)
    }
    
    private func calcStartLine (percent: CGFloat) ->  CGFloat {
        return (draggableZoneWidth * percent / 100) + (1 + circlesSize) - 10
    }
    
    
    private func move(point: UIView, to: CGFloat) {
        let pointDestination = CGPoint(x: to, y: 18)
        UIView.animate(withDuration: 0.5, animations: {
            point.center = pointDestination
        }, completion: nil)
    }
    
    private func moveStartLine(to: CGFloat) {
        let a = (draggableZoneWidth * to / 100)
        let dest = a + (1 + 16 + circlesSize - 10) + line!.bounds.size.width / 2
        let pointDestination = CGPoint(x: dest, y: 18)
        UIView.animate(withDuration: 0.2, animations: {
            self.line!.center = pointDestination
        }, completion: nil)
    }
    
    private func moveLineToCenter(animated: Bool) {
        let center = (firstValue + secondValue)/2
        let XPosition = (draggableZoneWidth * center / 100) + circlesSize/2
        
        
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                self.line?.center = CGPoint(x: XPosition, y: 18)
            }, completion: nil)
        } else {
            line?.center = CGPoint(x: XPosition, y: 18)
        }
    }
    
    private func changeLineSize(animated: Bool) {
        let center = (secondValue - firstValue)
        let width = ( center * draggableZoneWidth / 100)
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                self.line!.bounds.size.width = width
            }, completion: nil)
        } else {
            line!.bounds.size.width = width
        }
    }
    
    private func calculateLineSize() -> CGFloat {
        let center = (secondValue - firstValue)
        return( center * draggableZoneWidth / 100)
    }
    
    private func drag(circle: UIView, to: CGFloat, value: String){
        if (value == "firstValue") {
            firstValue += to * 100 / draggableZoneWidth
            circle.center = CGPoint(x:circle.center.x + to, y:18)
        }
        
        if (value == "secondValue") {
            secondValue += to * 100 / draggableZoneWidth
            circle.center = CGPoint(x:circle.center.x + to, y:18)
        }
    }
}







