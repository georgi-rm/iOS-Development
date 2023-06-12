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
    @IBOutlet weak var temperatureUnitSelector: UISegmentedControl!
    @IBOutlet weak var apearanceModeSelector: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationNameTextField.delegate = self
        locationLatitudeTextField.delegate = self
        locationLongitudeTextField.delegate = self
        
        switch LocalDataManager.temperatureUnits {
        case .celsius:
            temperatureUnitSelector.selectedSegmentIndex = 0
        case .fahrenheit:
            temperatureUnitSelector.selectedSegmentIndex = 1
        default:
            temperatureUnitSelector.selectedSegmentIndex = 0
            break
        }
        
        switch LocalDataManager.appearanceMode {
        case .system:
            apearanceModeSelector.selectedSegmentIndex = 0
        case .light:
            apearanceModeSelector.selectedSegmentIndex = 1
        case .dark:
            apearanceModeSelector.selectedSegmentIndex = 2
        default:
            apearanceModeSelector.selectedSegmentIndex = 0
            break
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationNameTextField.text = LocalDataManager.locationName
        locationLatitudeTextField.text = LocalDataManager.locationsLatitude
        locationLongitudeTextField.text = LocalDataManager.locationLongitude
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        LocalDataManager.locationName = locationNameTextField.text ?? ""
        LocalDataManager.locationsLatitude = locationLatitudeTextField.text ?? ""
        LocalDataManager.locationLongitude = locationLongitudeTextField.text ?? ""
    }
    
    @IBAction func appModeSelector(_ sender: UISegmentedControl) {
        var appearanceMode: AppearanceMode = LocalDataManager.appearanceMode ?? .system
        
        switch sender.selectedSegmentIndex {
        case 0:
            appearanceMode = .system
        case 1:
            appearanceMode = .light
        case 2:
            appearanceMode = .dark
        default:
            break;
        }
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        switch appearanceMode {
        case .system:
            window?.overrideUserInterfaceStyle = .unspecified
        case .dark:
            window?.overrideUserInterfaceStyle = .dark
        case .light:
            window?.overrideUserInterfaceStyle = .light
        }

        LocalDataManager.appearanceMode = appearanceMode
    }
    
    @IBAction func temperatureSelector(_ sender: UISegmentedControl) {
        var temperatureUnits: TemperatureUnits = LocalDataManager.temperatureUnits ?? .celsius
        
        switch sender.selectedSegmentIndex {
        case 0:
            temperatureUnits = .celsius
        case 1:
            temperatureUnits = .fahrenheit
        default:
            break;
        }

        LocalDataManager.temperatureUnits = temperatureUnits
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

//extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//    // Number of columns of data
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    // The number of rows of data
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return pickerData.count
//    }
//
//    // The data to return for the row and component (column) that's being passed in
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return pickerData[row].rawValue
//    }
//
//    // Capture the picker view selection
//        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//            // This method is triggered whenever the user makes a change to the picker selection.
//            // The parameter named row and component represents what was selected.
//            self.selectedTemperature = pickerData[row]
//        }
//}
