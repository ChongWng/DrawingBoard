//
//  ViewController.swift
//  DrawingBoard
//
//  Created by wang on 9/04/17.
//  Copyright © 2017 Unitec. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //make references for all needed components
    @IBOutlet weak var drawingView: UIView!
    @IBOutlet weak var toolView: UIView!
    @IBOutlet weak var colorStack: UIStackView!
    @IBOutlet weak var shapeStack: UIStackView!
    @IBOutlet weak var btnPencil: UIButton!
    @IBOutlet weak var btnLine: UIButton!
    @IBOutlet weak var btnEclipse: UIButton!
    @IBOutlet weak var btnRec: UIButton!
    @IBOutlet weak var btnRoundedRec: UIButton!
    @IBOutlet weak var btnTri: UIButton!
    @IBOutlet weak var btnEraser: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    var drawShape: Int = 0
    var drawLayer: CAShapeLayer?
    var drawFreePath: UIBezierPath = UIBezierPath()
    var startPoint: CGPoint = CGPoint.zero
    var selectedShapeTag: Int = 0
    var drawLineWidth: CGFloat = 3.0  //default line width when the app starts
    let strokeWidth: CGFloat = 3.0  //the width for the border of rectangle, eclipse and triangle
    var opacity: CGFloat = 1.0 //default opacity when the app starts
    var radius: CGFloat = 15.0 //default radius for rounded rectangle
    var red:CGFloat = 0.0
    var green:CGFloat = 0.0
    var blue:CGFloat = 0.0
    var shapeButtons = [UIButton]()
    
    enum Color: Int {
        case red = 0
        case orange
        case yellow
        case green
        case blue
        case purple
        case black
    }
    
    enum Shape: Int {
        case pencil = 0
        case line
        case eclipse
        case rect
        case roundedRec
        case tri
        case eraser
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Use pencil as the default shape and darken the background color of the pencil button
        shapeButtons = [btnEclipse, btnRec, btnRoundedRec, btnTri, btnLine, btnPencil, btnEraser]
        btnPencil.backgroundColor = UIColor.darkGray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Use the color selection button group to allow users to select color directly
    @IBAction func colorSelected(_ sender: UIButton) {
        switch sender.tag{
        case Color.red.rawValue:
            (red,green,blue) = (1, 0, 0)
        case Color.orange.rawValue:
            (red,green,blue) = (1, 0.5, 0)
        case Color.yellow.rawValue:
            (red,green,blue) = (1, 1, 0)
        case Color.green.rawValue:
            (red,green,blue) = (0, 1, 0)
        case Color.blue.rawValue:
            (red,green,blue) = (0, 0, 1)
        case Color.purple.rawValue:
            (red,green,blue) = (0.5, 0, 0.5)
        case Color.black.rawValue:
            (red,green,blue) = (0, 0, 0)
        default:
            (red,green,blue) = (0, 0, 0)
        }
    }
    
    //Use the shape selection button group to allow users to select shapes
    @IBAction func shapeSelected(_ sender: UIButton) {
        switch sender.tag{
        case Shape.pencil.rawValue:
            drawShape = Shape.pencil.rawValue
        case Shape.line.rawValue:
            drawShape = Shape.line.rawValue
        case Shape.eclipse.rawValue:
            drawShape = Shape.eclipse.rawValue
        case Shape.rect.rawValue:
            drawShape = Shape.rect.rawValue
        case Shape.roundedRec.rawValue:
            drawShape = Shape.roundedRec.rawValue
        case Shape.tri.rawValue:
            drawShape = Shape.tri.rawValue
        case Shape.eraser.rawValue:
            drawShape = Shape.eraser.rawValue
        default:
            drawShape = Shape.pencil.rawValue
        }
        selectedShapeTag = sender.tag
        setBgColor(selectedShapeTag)  //pass the selected shape index to change the background color of selected shape button
    }
    
    //Set background color for shape buttons.
    func setBgColor(_ shapeTag:Int) {
        for button in shapeButtons {
            if button.tag == shapeTag {
                button.backgroundColor = UIColor.darkGray
            }
            else {
                button.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    
    //Set the color and line width and add a sublayer to the drawview before drawing
    func initDrawLayer(_ point: CGPoint)
    {
        drawLayer = CAShapeLayer()
        drawLayer?.fillColor = UIColor.clear.cgColor
        drawLayer?.strokeColor = UIColor(red: red, green: green, blue: blue, alpha: opacity).cgColor
        drawLayer?.lineWidth = strokeWidth
        
        if drawShape == Shape.eraser.rawValue {
            drawLayer?.strokeColor = drawingView.backgroundColor?.cgColor
        } //set drawing canvas background color as the eraser color
        drawingView.layer.addSublayer(drawLayer!)
        drawFreePath.move(to: point)
    }

    //the function to draw all the shapes
    @IBAction func drawingPan(_ sender: UIPanGestureRecognizer) {
        
        let drawPath = UIBezierPath()
        
        if sender.state == .began {
            startPoint = sender.location(in: sender.view)
            initDrawLayer(startPoint)
        }
        else if sender.state == .changed {
            let translation = sender.translation(in: sender.view)
            switch drawShape {
                
            //draw eclipse
            case Shape.eclipse.rawValue:
                drawLayer?.fillColor = UIColor(red: red, green: green, blue: blue, alpha: opacity).cgColor
                drawLayer?.path = (UIBezierPath(ovalIn: CGRect(x: startPoint.x, y: startPoint.y, width: translation.x, height: translation.y))).cgPath
            
            //draw rectangle
            case Shape.rect.rawValue:
                drawLayer?.fillColor = UIColor(red: red, green: green, blue: blue, alpha: opacity).cgColor
                drawLayer?.path = (UIBezierPath(rect: CGRect(x: startPoint.x, y: startPoint.y, width: translation.x, height: translation.y))).cgPath

            //draw rounded rectangle
            case Shape.roundedRec.rawValue:
                drawLayer?.fillColor = UIColor(red: red, green: green, blue: blue, alpha: opacity).cgColor
                drawLayer?.path = (UIBezierPath(roundedRect: CGRect(x: startPoint.x, y: startPoint.y, width: translation.x, height: translation.y),cornerRadius:radius)).cgPath

            //draw line
            case Shape.line.rawValue:
                drawLayer?.lineWidth = drawLineWidth
                drawPath.move(to: startPoint)
                drawPath.addLine(to: sender.location(in: sender.view))
                drawPath.close()
                drawLayer?.path = drawPath.cgPath

            //free draw and eraser
            case Shape.pencil.rawValue, Shape.eraser.rawValue:
                drawLayer?.lineWidth = drawLineWidth
                drawFreePath.addLine(to: sender.location(in: sender.view))
                drawLayer?.path = drawFreePath.cgPath

            //draw triangle
            case Shape.tri.rawValue:
                let point2: CGPoint = sender.location(in: sender.view)
                let point3: CGPoint = CalcPoint(point2)
                drawPath.move(to: startPoint)
                drawPath.addLine(to: point2)
                drawPath.addLine(to: point3)
                drawPath.close()
                drawLayer?.fillColor = UIColor(red: red, green: green, blue: blue, alpha: opacity).cgColor
                drawLayer?.path = drawPath.cgPath
                
            default: break
            }
        }
        else if sender.state == .ended {
            drawFreePath = UIBezierPath()
            btnDelete.isEnabled = true
            btnSave.isEnabled = true
        }

    }
    
    //Calculate the 3rd point of the triangle when user is drawing a triangle shape
    func CalcPoint(_ givenPoint: CGPoint) -> CGPoint
    {
        var point: CGPoint = CGPoint()
        if givenPoint.x < startPoint.x{
            point.x = startPoint.x - givenPoint.x
        }
        else{
            point.x = givenPoint.x - (givenPoint.x - startPoint.x) * 2
        }
        point.y = givenPoint.y
        
        return point
    }

    //delete drawing with warning message
    @IBAction func deleteDraw(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure you want to delete?", message: "The drawing will be deleted immediately. You can't undo this action.", preferredStyle: UIAlertControllerStyle.alert)
        let actionConfirm = UIAlertAction(title: "Delete All", style: UIAlertActionStyle.destructive, handler: {action in self.deleteConfirmed()})
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(actionConfirm)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
    

    //implement the confirm action of delete alert
    func deleteConfirmed() {
        for layer: CALayer in drawingView.layer.sublayers!{
            layer.removeFromSuperlayer()
        }
        btnDelete.isEnabled = false
        btnSave.isEnabled = false
    }
    
    //save the drawing to photo album
    @IBAction func saveDraw(_ sender: UIButton) {
        UIGraphicsBeginImageContextWithOptions(drawingView.frame.size, true, 0);
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        context.translateBy(x: -drawingView.frame.origin.x, y: -drawingView.frame.origin.y);
        drawingView.layer.render(in: context);
        let renderImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(renderImage, nil, nil, nil)
        
        let alert = UIAlertController(title: "Success", message: "Your drawing has been saved.", preferredStyle: UIAlertControllerStyle.alert)
        let actionOK = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(actionOK)
        self.present(alert, animated: true, completion: nil)
    }

    //function to pass values to SettingsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let settingsViewController = segue.destination as! SettingsViewController
        settingsViewController.delegate = self
        settingsViewController.red = red
        settingsViewController.green = green
        settingsViewController.blue = blue
        settingsViewController.lineWidth = drawLineWidth
        settingsViewController.opacity = opacity
        settingsViewController.radius = radius
    }

}

//get values from SettingsViewController
extension ViewController: SettingsVCDelegate {
    func settingsViewControllerDidFinish(_ settingsViewController: SettingsViewController) {
        self.red = settingsViewController.red
        self.green = settingsViewController.green
        self.blue = settingsViewController.blue
        self.drawLineWidth = settingsViewController.lineWidth
        self.opacity = settingsViewController.opacity
        self.radius = settingsViewController.radius
    }
}

