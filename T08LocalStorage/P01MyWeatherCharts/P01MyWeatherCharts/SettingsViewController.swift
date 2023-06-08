//
//  SettingsViewController.swift
//  P01MyWeatherCharts
//
//  Created by Georgi Manev on 24.01.23.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var locationLatitudeTextField: UITextField!
    @IBOutlet weak var locationLongitudeTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var temperatureUnitPickerView: UIPickerView!
    
    var pickerData: [TemperatureUnits] = [.celsius, .fahrenheit]
    
    var selectedTemperature: TemperatureUnits = .celsius
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveBtn.layer.borderColor = UIColor.systemBlue.cgColor
        saveBtn.layer.cornerRadius = 5
        saveBtn.layer.borderWidth = 1
        saveBtn.tintColor = UIColor.systemBlue
    
        
        locationNameTextField.delegate = self
        locationLatitudeTextField.delegate = self
        locationLongitudeTextField.delegate = self
        
        self.temperatureUnitPickerView.delegate = self
        self.temperatureUnitPickerView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationNameTextField.text = LocalDataManager.locationName
        locationLatitudeTextField.text = LocalDataManager.locationsLatitude
        locationLongitudeTextField.text = LocalDataManager.locationLongitude
    }
    
    @IBAction func onSavePressed(_ sender: Any) {
        LocalDataManager.locationName = locationNameTextField.text ?? ""
        LocalDataManager.locationsLatitude = locationLatitudeTextField.text ?? ""
        LocalDataManager.locationLongitude = locationLongitudeTextField.text ?? ""
        LocalDataManager.temperatureUnits = selectedTemperature.rawValue
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

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.locationNameTextField:
            self.locationLatitudeTextField.becomeFirstResponder()
        case self.locationLatitudeTextField:
            self.locationLongitudeTextField.becomeFirstResponder()
        case self.locationLongitudeTextField:
            self.locationLongitudeTextField.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].rawValue
    }
    
    // Capture the picker view selection
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            // This method is triggered whenever the user makes a change to the picker selection.
            // The parameter named row and component represents what was selected.
            self.selectedTemperature = pickerData[row]
        }
}
