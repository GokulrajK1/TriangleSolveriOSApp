//
//  ResultsViewController.swift
//  TriangleSolverApp
//
//  Created by Gokulraj Kumarassamy on 8/19/22.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var sideALabel: UILabel!
    @IBOutlet weak var sideBLabel: UILabel!
    @IBOutlet weak var sideCLabel: UILabel!
    
    @IBOutlet weak var angleALabel: UILabel!
    @IBOutlet weak var angleBLabel: UILabel!
    @IBOutlet weak var angleCLabel: UILabel!
    
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var perimeterLabel: UILabel!
    @IBOutlet weak var semiperimeterLabel: UILabel!
    
    @IBOutlet weak var heightALabel: UILabel!
    @IBOutlet weak var heightBLabel: UILabel!
    @IBOutlet weak var heightCLabel: UILabel!
    
    @IBOutlet weak var medianALabel: UILabel!
    @IBOutlet weak var medianBLabel: UILabel!
    @IBOutlet weak var medianCLabel: UILabel!
    
    @IBOutlet weak var inradiusLabel: UILabel!
    @IBOutlet weak var circumradiusLabel: UILabel!
    
    @IBOutlet weak var show2ndTriangleButton: UIButton!
    
    var model : SolverModel?
    var currentTriangle : Triangle?
    
    var propertyDescriptions = [String]()
    var propertyLabels = [UILabel]()
    
    let secondTriangleShow = "Show 2nd Triangle"
    let firstTriangleShow = "Show 1st Triangle"

    override func viewDidLoad() {
        super.viewDidLoad()
        propertyLabels = storePropertyLabels()
        propertyDescriptions = storeDescriptions()
        currentTriangle = model?.triangle
        updateDisplay()
    }
    
    func storePropertyLabels() -> [UILabel] {
        return [sideALabel, sideBLabel, sideCLabel, angleALabel, angleBLabel, angleCLabel, areaLabel, perimeterLabel, semiperimeterLabel, heightALabel, heightBLabel, heightCLabel, medianALabel, medianBLabel, medianCLabel, inradiusLabel, circumradiusLabel]
    }
    
    func storeDescriptions() -> [String] {
        return propertyLabels.map {$0.text!}
    }
    
    func updateDisplay() {
        titleLabel.text = currentTriangle?.name
        descriptionLabel.text = currentTriangle?.createDescription()
        var index = 0
        while index < propertyLabels.count {
            if let tri = currentTriangle {
                let value = model?.formatValue(currentTriangle: tri, index: index)
                let description = propertyDescriptions[index]
                propertyLabels[index].text = description + " " + value!
                index += 1
            }
            
        }
        if model?.triangle2 != nil{
            show2ndTriangleButton.setTitle(secondTriangleShow, for: .normal)
        }
    }
    
    @IBAction func show2ndButtonPressed(_ sender: UIButton) {
        if show2ndTriangleButton.currentTitle == secondTriangleShow {
            currentTriangle = model?.triangle2
            updateDisplay()
            show2ndTriangleButton.setTitle(firstTriangleShow, for: .normal)
        } else if show2ndTriangleButton.currentTitle == firstTriangleShow {
            currentTriangle = model?.triangle
            updateDisplay()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
