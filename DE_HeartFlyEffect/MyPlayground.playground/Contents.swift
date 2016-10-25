//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


UIGraphicsBeginImageContextWithOptions(CGSize(width: 100, height: 100), false, 0)
let ctf = UIGraphicsGetCurrentContext()

ctf?.setFillColor(UIColor.red.cgColor)
ctf?.addEllipse(in: CGRect(x: 0, y: 0, width: 100, height: 100))

ctf?.drawPath(using: .fill)

let image = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()