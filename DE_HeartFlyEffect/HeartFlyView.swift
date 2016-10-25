//
//  HeartFlyView.swift
//  DE_HeartFlyEffect
//
//  Created by go.yaro on 10/25/16.
//  Copyright © 2016 DDDrop. All rights reserved.
//

import UIKit

fileprivate class HeartFlyButton : UIButton {
    var bgColor : UIColor

    init?(withSize size: Double, color bgColor: UIColor) {
        self.bgColor = bgColor

        super.init(frame: CGRect(x: 0.0, y: 0.0, width: size, height: size))

        self.tintColor = UIColor.white

        if !drawBackgound(withColor: bgColor) {
            return nil
        }

        let image = #imageLiteral(resourceName: "heart").withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: size/2, height: size/2)
        imageView.center = self.center
        imageView.frame.origin.y *= 1.15
        imageView.tintColor = .white

        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func drawBackgound(withColor color: UIColor) -> Bool {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        guard let ctf = UIGraphicsGetCurrentContext() else {
            return false
        }
        ctf.setFillColor(color.cgColor)
        ctf.addEllipse(in: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))

        ctf.drawPath(using: .fill)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.setBackgroundImage(image, for: .normal)

        return true
    }
}

class HeartFlyView : UIView {
    fileprivate let heartBtn = HeartFlyButton(withSize: 40, color: UIColor(red: 0.51, green: 0.81, blue: 1, alpha: 1))

    var subViewCounter = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white


        if heartBtn != nil {
            self.addSubview(heartBtn!)
            heartBtn!.frame.origin = CGPoint(x: self.frame.width/2 - 20, y: self.frame.height - 40)
            heartBtn!.addTarget(self, action: #selector(showHeart(_:)), for: .touchUpInside)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let colors : [UIColor] = [
        UIColor(red: 1.00, green: 0.70, blue: 0.51, alpha :1),
        UIColor(red: 0.56, green: 1.00, blue: 0.51, alpha :1),
        UIColor(red: 0.51, green: 0.80, blue: 1.00, alpha :1),
        UIColor(red: 0.94, green: 0.51, blue: 1.00, alpha :1)
    ]

    func showHeart(_ sender: UIButton) {
        guard subViewCounter < 20 else {
            return
        }
        let image = #imageLiteral(resourceName: "heart").withRenderingMode(.alwaysTemplate)
        let index = Int(arc4random_uniform(4))
        let color = colors[index]
        let heartFlyingView = UIImageView(image: image)
        heartFlyingView.tintColor = color
        heartFlyingView.frame.size = CGSize(width: 20, height: 20)
        heartFlyingView.center = self.heartBtn!.center

        self.insertSubview(heartFlyingView, belowSubview: sender)
        subViewCounter += 1

        heartFlyingView.transform = CGAffineTransform(scaleX: 0, y: 0)
        heartFlyingView.alpha = 0

        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: { 
            heartFlyingView.transform = CGAffineTransform(scaleX: 1, y: 1)
            heartFlyingView.alpha = 0.9
            }, completion: nil)

        let rotationDirection = 1 - (2 * CGFloat(arc4random_uniform(2)))
        let rotationFraction = CGFloat(arc4random_uniform(10))

        UIView.animate(withDuration: 4) { 
            heartFlyingView.transform = CGAffineTransform(rotationAngle: rotationDirection * CGFloat(M_PI) / (4 + rotationFraction * 0.2))
        }

        let cx = heartBtn!.center.x
        let cy = heartBtn!.center.y

        let heartTravelPath = UIBezierPath()
        heartTravelPath.move(to: heartBtn!.center)
        let endX = CGFloat(arc4random_uniform(UInt32(self.frame.width - 40))) + 20
        let endY = (1 - fabs(endX - cx) / cx) * 20 + 20
        let endPoint = CGPoint(x: endX, y: endY)

        let travelDirection = 1 - (2 * CGFloat(arc4random_uniform(2)))

        let point1 = CGPoint(x: cx + travelDirection * (CGFloat(arc4random_uniform(20)) + 50),
                             y: cy - 60 + travelDirection * CGFloat(arc4random_uniform(20)))
        let point2 = CGPoint(x: cx - travelDirection * (CGFloat(arc4random_uniform(20)) + 50),
                             y: cy - 90 + travelDirection * CGFloat(arc4random_uniform(20)))

        heartTravelPath.addCurve(to: endPoint, controlPoint1: point1, controlPoint2: point2)

        let keyAnimation = CAKeyframeAnimation(keyPath: "position")
        keyAnimation.path = heartTravelPath.cgPath
        keyAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        keyAnimation.duration = 3

        heartFlyingView.layer.add(keyAnimation, forKey: "positionOnPath")

        UIView.animate(withDuration: 3, animations: { 
            heartFlyingView.alpha = 0
            }) { (finish) in
                heartFlyingView.removeFromSuperview()
                self.subViewCounter -= 1
        }
    }
    
}
