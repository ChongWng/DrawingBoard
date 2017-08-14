//
//  SettingsViewController.swift
//  DrawingBoard
//
//  Created by wang on 10/04/17.
//  Copyright © 2017 Unitec. All rights reserved.
//

import UIKit

protocol SettingsVCDelegate:class {
    func settingsViewControllerDidFinish(_ settingsViewController:SettingsViewController)
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var opacityLabel: UILabel!
    @IBOutlet weak var radiusLabel: UILabel!
    
    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var opacitySlider: UISlider!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    var delegate:SettingsVCDelegate?
    var red:CGFloat = 0.0
    var green:CGFloat = 0.0
    var blue:CGFloat = 0.0
    var lineWidth:CGFloat = 0.0
    var opacity:CGFloat = 0.0
    var radius:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set slider values from ViewController and display the values on corresponding labels
        
        widthSlider.value = Float(lineWidth/100)
        widthLabel.text = String(Int(widthSlider.value * 100))
        
        
        opacitySlider.value = Float(opacity)
        opacityLabel.text = String(format: "%.2f", opacitySlider.value)
        
        radiusSlider.value = Float(radius/100)
        radiusLabel.text = String(Int(radiusSlider.value * 100))
        
        redSlider.value = Float(red)
        redLabel.text = String(Int(redSlider.value * 255))
        
        greenSlider.value = Float(green)
        greenLabel.text = String(Int(greenSlider.value * 255))
        
        blueSlider.value = Float(blue)
        blueLabel.text = String(Int(blueSlider.value * 255))
        
        drawPreview(red: red, green: green, blue: blue) //set the preview color
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //function to go back to ViewController
    @IBAction func backToDraw(_ sender: UIButton) {
        if delegate != nil {
            delegate?.settingsViewControllerDidFinish(self)
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    //function to change the red slider value and the corresponding label value
    @IBAction func redSliderChanged(_ sender: UISlider) {
        red = CGFloat(sender.value)
        drawPreview(red: red, green: green, blue: blue)
        redLabel.text = "\(Int(sender.value * 255))"
    }
    
    //function to change the green slider value and the corresponding label value
    @IBAction func greenSliderChanged(_ sender: UISlider) {
        green = CGFloat(sender.value)
        drawPreview(red: red, green: green, blue: blue)
        greenLabel.text = "\(Int(sender.value * 255))"
    }
    
    //function to change the blue slider value and the corresponding label value
    @IBAction func blueSliderChanged(_ sender: UISlider) {
        blue = CGFloat(sender.value)
        drawPreview(red: red, green: green, blue: blue)
        blueLabel.text = "\(Int(sender.value * 255))"
    }
    
    //function to display the color on the image view
    func drawPreview (red:CGFloat,green:CGFloat,blue:CGFloat) {
        imageView.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    //function to change the opacity slider value and the corresponding label value
    @IBAction func opacitySliderChanged(_ sender: UISlider) {
        opacity = CGFloat(sender.value)
        opacityLabel.text = String(format: "%.2f", sender.value)
    }
    
    //function to change the line width slider value and the corresponding label value
    @IBAction func widthSliderChanged(_ sender: UISlider) {
        lineWidth = CGFloat(sender.value) * 100
        widthLabel.text = "\(Int(sender.value * 100))"
    }

    //function to change the radius slider value and the corresponding label value
    @IBAction func radiusSliderChanged(_ sender: UISlider) {
        radius = CGFloat(sender.value) * 100
        radiusLabel.text = "\(Int(sender.value * 100))"
    }

}
