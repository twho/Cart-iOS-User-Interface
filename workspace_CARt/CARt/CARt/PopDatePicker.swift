//
//  PopDatePicker.swift
//  CARt
//
//  Created by Michael Ho on 11/24/16.
//  Copyright © 2016 cartrides.org. All rights reserved.
//

import UIKit

public class PopDatePicker : NSObject, UIPopoverPresentationControllerDelegate, DataPickerViewControllerDelegate {
    
    public typealias PopDatePickerCallback = (_ newDate : Date, _ forTextField : UITextField)->()
    
    var datePickerVC : PopDateViewController
    var popover : UIPopoverPresentationController?
    var textField : UITextField!
    var dataChanged : PopDatePickerCallback?
    var presented = false
    var offset : CGFloat = 5.0
    
    public init(forTextField: UITextField) {
        
        datePickerVC = PopDateViewController()
        self.textField = forTextField
        super.init()
    }
    
    public func pick(_ inViewController : UIViewController, initDate : Date?, dataChanged : @escaping PopDatePickerCallback) {
        
        if presented {
            return  // we are busy
        }
        
        datePickerVC.delegate = self
        datePickerVC.modalPresentationStyle = UIModalPresentationStyle.popover
        datePickerVC.preferredContentSize = CGSize(width: 500, height: 310)
        datePickerVC.currentDate = initDate
        
        popover = datePickerVC.popoverPresentationController
        if let _popover = popover {
            
            _popover.sourceView = textField
            _popover.sourceRect = CGRect(x: self.offset, y: textField.bounds.size.height,width: 0,height: 0)
            _popover.delegate = self
            self.dataChanged = dataChanged
            inViewController.present(datePickerVC, animated: true, completion: nil)
            presented = true
        }
    }
    
    public func adaptivePresentationStyle(
        for controller: UIPresentationController,
        traitCollection: UITraitCollection)
        -> UIModalPresentationStyle {
            return .none
    }
    
    func datePickerVCDismissed(_ date : Date?) {
        
        if let _dataChanged = dataChanged {
            
            if let _date = date {
                
                _dataChanged(_date, textField)
                
            }
        }
        presented = false
    }
}
