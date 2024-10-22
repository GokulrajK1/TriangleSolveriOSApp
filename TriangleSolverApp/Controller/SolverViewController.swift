//
//  ViewController.swift
//  TriangleSolverApp
//
//  Created by Gokulraj Kumarassamy on 8/17/22.
//

import UIKit

class SolverViewController: UIViewController {
    
    @IBOutlet weak var topLevelStackView: UIStackView!
    @IBOutlet weak var innerStackView: UIStackView!
    @IBOutlet weak var horzStack1: UIStackView!
    @IBOutlet weak var horzStack2: UIStackView!
    @IBOutlet weak var horzStack3: UIStackView!
    
    @IBOutlet weak var inputTypeSegmentalControl: UISegmentedControl!
    
    
    @IBOutlet weak var labelA: UILabel!
    @IBOutlet weak var labelB: UILabel!
    @IBOutlet weak var labelC: UILabel!
    
    @IBOutlet weak var textFieldA: UITextField!
    @IBOutlet weak var textFieldB: UITextField!
    @IBOutlet weak var textFieldC: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var modePicker: UIPickerView!
    
    @IBOutlet weak var stackViewConstraint: NSLayoutConstraint!
    
    var horzStacks = [UIStackView]()
    var textFields = [UITextField]()
    
    var sideTextValues : [String?] = [nil, nil, nil]
    var angleTextValues : [String?] = [nil, nil, nil]
    
    var model = SolverModel()
    
    var selectedTextField : UITextField?
    var selectedTextFieldIndex = 0
    
    var selectedInputSegment = 0
    
    let sideLabelTexts = ["Side A", "Side B", "Side C"]
    let angleLabelTexts = ["Angle A", "Angle B", "Angle C"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = storeTextFields()
        horzStacks = storeStackViews()
        modePicker.dataSource = self
        modePicker.delegate = self
        assignDelegateToTextFields()
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let info = notification.userInfo {
//            let rect : CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
//            let targetY = view.frame.size.height - rect.size.height - 20 - selectedTextField!.frame.size.height
//            let currentY = topLevelStackView.frame.origin.y + innerStackView.frame.origin.y + horzStacks[selectedTextFieldIndex].frame.origin.y
//            print(view.frame.height - rect.height)
//            let difference = targetY - currentY
//            let offSetConstraint = stackViewConstraint.constant + difference
//            self.view.layoutIfNeeded()
//            UIView.animate(withDuration: 0.25) {
//                self.stackViewConstraint.constant = offSetConstraint
//                self.view.layoutIfNeeded()
//            }
//            
//        }
//    }
    
    func assignDelegateToTextFields() {
        for textField in textFields {
            textField.delegate = self
        }
    }
    
    func resignTextFieldsAsFirstResponder() {
        for textField in textFields {
            textField.resignFirstResponder()
        }
    }
    
    func storeStackViews() -> [UIStackView] {
        return [horzStack1, horzStack2, horzStack3]
    }
    
    func storeTextFields() -> [UITextField] {
        return [textFieldA, textFieldB, textFieldC]
    }
    
    func storeLabels() -> [UILabel] {
        return [labelA, labelB, labelC]
    }
    

    @IBAction func solveButtonPressed(_ sender: UIButton) {
        if selectedInputSegment == 0 {
            if sideTextValues[selectedTextFieldIndex] == nil || sideTextValues[selectedTextFieldIndex] == "" {
                print("this happens")
                sideTextValues[selectedTextFieldIndex] = selectedTextField?.text
            }
        } else {
            if angleTextValues[selectedTextFieldIndex] == nil || angleTextValues[selectedTextFieldIndex] == "" {
                angleTextValues[selectedTextFieldIndex] = selectedTextField?.text
            }
        }
        let textValues = sideTextValues + angleTextValues
        do {
            print(textValues)
            try model.solveTriangle(with: textValues)
            performSegue(withIdentifier: "segueToAnswers", sender: self)
            errorLabel.text = "Enter in 3 values"
            errorLabel.textColor = .label
        } catch {
            errorLabel.textColor = .red
            switch error {
            case TriangleErrors.NotEnoughInputs:
                errorLabel.text = "ERORR: Must provide atleast 3 values."
            case TriangleErrors.InvalidAngles:
                errorLabel.text = "ERROR: Angles sum to more than 180° (𝛑 radians)."
            case TriangleErrors.ExcessInputs:
                errorLabel.text = "ERROR: More than 3 values were provided."
            case TriangleErrors.TriangleDNE:
                errorLabel.text = "ERROR: Triangle does not exist."
            case TriangleErrors.SidesInequalityFailed:
                errorLabel.text = "ERROR: Sum of 2 sides less than remaining side."
            case TriangleErrors.SideNotProvided:
                errorLabel.text = "ERROR: Must provide atleast 1 side"
            default:
                print("Something horrible and unfortunate has happened")
            }
        }
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        for textField in textFields {textField.text = nil}
        errorLabel.text = "Enter in 3 values"
        errorLabel.textColor = .label
    }
    
    @IBAction func inputTypeChanged(_ sender: UISegmentedControl) {
        selectedInputSegment = sender.selectedSegmentIndex
        changeTextFieldLabels()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ResultsViewController
        destinationVC.model = model
    }
    
    func changeTextFieldLabels() {
        let textFieldLabels = selectedInputSegment == 0 ? sideLabelTexts : angleLabelTexts
        for (index, label) in storeLabels().enumerated() {
            label.text = textFieldLabels[index]
        }
    }
}

extension SolverViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        selectedTextField = textField
        selectedTextFieldIndex = textFields.firstIndex(of: textField)!
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25) {
            self.stackViewConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        let index = textFields.firstIndex(of: textField)!
        if (selectedInputSegment == 0) {
            print(textField.text)
            sideTextValues[index] = textField.text
        } else {
            angleTextValues[index] = textField.text
        }
        
    }
}

extension SolverViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return model.modes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return model.modes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        model.mode = model.modes[row]
    }
    
}
