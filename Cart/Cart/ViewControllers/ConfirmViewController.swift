//
//  ConfirmViewController.swift
//  CARt
//
//  Created by Michael Ho on 10/17/16.
//  Copyright © 2016 cartrides.org. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tvBarcodeInstr: UILabel!
    @IBOutlet weak var tvRequestTitle: UILabel!
    @IBOutlet weak var tvRequestInfo: UILabel!
    @IBOutlet weak var tvRequestDetails: UILabel!
    @IBOutlet weak var tvWarning: UILabel!
    @IBOutlet weak var btnFinished: BorderedButton!
    @IBOutlet weak var progressSpinner: UIActivityIndicatorView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var ivBarcode: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var edHome: UITextField!
    @IBOutlet weak var edDestination: UITextField!
    @IBOutlet weak var ivHome: UIImageView!
    @IBOutlet weak var ivDestination: UIImageView!
    @IBOutlet weak var ivDriver: CornerRadiusImageView!
    @IBOutlet weak var tvDriverName: UILabel!
    @IBOutlet weak var tvDriverCar: UILabel!
    @IBOutlet weak var tvDriverLicense: UILabel!
    
    var time: Float = 0.0
    var timeSlow: Float = 0.0
    var timer = Timer()
    var timerSlow = Timer()
    var ifToEditCode1: Bool = false
    var ifKeyboardShown: Bool = false
    var blinking = false
    
    let defaults = UserDefaults.standard
    let imageResources = ImageResources()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startCounter()
        initUIViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func initUIViews(){
        self.scrollView.contentSize.height = 670
        progressSpinner.startAnimating()
        progressBar.setProgress(0, animated: true)
        
        // Set invisible initially
        ivBarcode.alpha = 0.0
        btnFinished.alpha = 0.0
        
        edHome.leftViewMode = UITextFieldViewMode.always
        edHome.leftView = ivHome
        edHome.text = defaults.string(forKey: addressKeys.myAddressKey)
        edHome.isEnabled = false
        edDestination.leftViewMode = UITextFieldViewMode.always
        edDestination.leftView = ivDestination
        edDestination.text = defaults.string(forKey: addressKeys.destAddressKey)
        edDestination.isEnabled = false
        
        btnFinished.setImage(imageResources.imgFinishClicked, for: .highlighted)
        btnFinished.setImage(imageResources.imgFinishClicked, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showBarcode(){
        self.progressSpinner.isHidden = true
        self.progressBar.isHidden = true
        fadeIn(imageView: ivBarcode, withDuration: 2.5)
        fadeIn(btnView: btnFinished)
    }
    
    func startCounter(){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:#selector(ConfirmViewController.setProgress), userInfo: nil, repeats: true)
        timerSlow = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector:#selector(ConfirmViewController.blinkingTitle), userInfo: nil, repeats: true)
    }
    
    func setProgress() {
        time += 0.1
        progressBar.progress = (time / 3)
        if time >= 0.1 {
            showBarcode()
        }
        if time >= 0.1 && time < 1 {
            tvRequestTitle.text = "Ride Requested"
            tvRequestTitle.textColor = tvBarcodeInstr.textColor
        } else if (time >= 10){
            tvRequestTitle.alpha = 1.0
            tvRequestTitle.text = "Driver Details"
            tvRequestTitle.textColor = tvBarcodeInstr.textColor
            edHome.isHidden = true
            edDestination.isHidden = true
            tvRequestInfo.isHidden = true
            ivDriver.isHidden = false
            tvDriverName.isHidden = false
            tvDriverCar.isHidden = false
            tvDriverLicense.isHidden = false
        }
    }
    
    func blinkingTitle(){
        timeSlow += 1
        if timeSlow <= 5 {
            blinkingLabel()
        } else {
            self.tvRequestTitle.alpha = 1.0
        }
    }
    
    func fadeIn(imageView: UIImageView, withDuration duration: TimeInterval = 2.0) {
        UIView.animate(withDuration: duration, animations: {
            imageView.alpha = 1.0
        })
    }
    
    func fadeIn(textView: UILabel, withDuration duration: TimeInterval = 2.0) {
        UIView.animate(withDuration: duration, animations: {
            textView.alpha = 1.0
        })
    }
    
    func fadeIn(btnView: BorderedButton, withDuration duration: TimeInterval = 2.0) {
        UIView.animate(withDuration: duration, animations: {
            btnView.alpha = 1.0
        })
    }
    
    func blinkingLabel(withDuration duration: TimeInterval = 1.5){
        if !blinking{
            self.tvRequestTitle.alpha = 1.0
            UIView.animate(withDuration: duration, animations: {
                self.tvRequestTitle.alpha = 0.0
            })
            blinking = true
        } else {
            UIView.animate(withDuration: duration, animations: {
                self.tvRequestTitle.alpha = 1.0
            })
            blinking = false
        }
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure you want to cancel the ride?", message: "By tapping yes, you will cancel the ride and return to home page.", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
        }
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "confirmToHomeIdentifier", sender: self)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if !ifKeyboardShown {
                self.view.frame.origin.y = self.view.frame.origin.y - keyboardSize.height - 45
                ifKeyboardShown = true
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                if ifKeyboardShown {
                    self.view.frame.origin.y = self.view.frame.origin.y + keyboardSize.height + 45
                    ifKeyboardShown = false
                }
            }
        }
    }
}
