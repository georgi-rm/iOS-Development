//
//  SofiaTableViewController.swift
//  P01MyWeather
//
//  Created by Georgi Manev on 19.01.23.
//

import UIKit

class DataTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let appearanceMode = LocalDataManager.appearanceMode {
        
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
        }
        
        NotificationCenter.default.addObserver(forName: .dataUpdated, object: nil, queue: OperationQueue.main) { _ in
            self.reloadDataOnScreen()
            
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let locationName = LocalDataManager.locationName {
            LocalDataManager.getWeatherData(locationName: locationName)
        }
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            RequestManager.fetchData()
//        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		
		switch section {
		case 0:
			return 1
		case 1:
			return 1
		case 2:
			return 7
		default:
			break
		}
		
        return 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCellIdentifier", for: indexPath)
        
		switch indexPath.section {
        case 0:
            if let locationName = LocalDataManager.locationName,
                  let latitude = LocalDataManager.locationsLatitude,
                  let longitude = LocalDataManager.locationLongitude,
                  locationName.count > 0,
                  latitude.count > 0,
                  longitude.count > 0 {
                cell.textLabel?.text = "\(locationName) ( \(latitude), \(longitude) )"
                
            } else {
                cell.textLabel?.text = "Invalid location"
            }
            cell.detailTextLabel?.text = ""
        case 1:
		    let weatherConditions: String
			let weatherConditionsText: String
			
            switch LocalDataManager.dataForLocation?.weatherForecast?.current_weather?.weathercode {
			case 0:
				weatherConditionsText = "Clear sky"
				weatherConditions = "sun.max"
			case 1, 2, 3:
				weatherConditionsText = "Cloudy"
				weatherConditions = "cloud"
			case 45, 48:
				weatherConditionsText = "Fog"
				weatherConditions = "cloud.fog"
			case 51, 53, 55, 56, 57:
				weatherConditionsText = "Drizzle"
				weatherConditions = "cloud.drizzle"
			case 61, 63, 65, 66, 67:
				weatherConditionsText = "Rain"
				weatherConditions = "cloud.rain"
			case 71, 73, 75, 77:
				weatherConditionsText = "Snow fall"
				weatherConditions = "cloud.snow"
			case 80, 81, 82:
				weatherConditionsText = "Rain showers"
				weatherConditions = "cloud.heavyrain"
			case 85, 86:
				weatherConditionsText = "Snow showers"
				weatherConditions = "cloud.hail"
			case 95, 96, 99:
				weatherConditionsText = "Thunderstorm"
				weatherConditions = "cloud.bolt.rain"
			default:
				weatherConditionsText = "Loading ..."
				weatherConditions = "clear"
			}
		
			cell.textLabel?.text = weatherConditionsText
            cell.imageView?.image = UIImage(systemName: weatherConditions)
            cell.detailTextLabel?.text = ""
        case 2:
			switch indexPath.row {
			case 0:
				cell.textLabel?.text = "Temperature"
			case 1:
				cell.textLabel?.text = "Humidity"
			case 2:
				cell.textLabel?.text = "Air pressure"
			case 3:
				cell.textLabel?.text = "Wind direction"
			case 4:
				cell.textLabel?.text = "Wind speed"
			case 5:
				cell.textLabel?.text = "Visibility"
			case 6:
				cell.textLabel?.text = "Last update"
			default:
				cell.detailTextLabel?.text = ""
			}
			
			if let weatherForecast = LocalDataManager.dataForLocation?.weatherForecast {
				switch indexPath.row {
				case 0:
                    cell.detailTextLabel?.text = "\(weatherForecast.current_weather?.temperature.description ?? "") \(LocalDataManager.temperatureUnits?.rawValue ?? TemperatureUnits.celsius.rawValue)"
                    
				case 1:
                    cell.detailTextLabel?.text = "\(weatherForecast.hourly?.relativehumidity_2m [0].description ?? "") \(weatherForecast.hourly_units?.relativehumidity_2m ?? "")"
				case 2:
                    cell.detailTextLabel?.text = "\(weatherForecast.hourly?.surface_pressure[0].description ?? "") \(weatherForecast.hourly_units?.surface_pressure ?? "")"
				case 3:
                    cell.detailTextLabel?.text = "\(weatherForecast.current_weather?.winddirection ?? 0.0)"
				case 4:
                    cell.detailTextLabel?.text = "\(weatherForecast.current_weather?.windspeed ?? 0.0)"
				case 5:
                    cell.detailTextLabel?.text = "\(weatherForecast.hourly?.visibility[0].description ?? "") \(weatherForecast.hourly_units?.visibility ?? "")"
				case 6:
                    cell.detailTextLabel?.text = "\(weatherForecast.current_weather?.time ?? "")"
				default:
					cell.detailTextLabel?.text = "Loading ..."
				}
            } else {
                cell.detailTextLabel?.text = "Loading ..."
            }
        default:
            cell.detailTextLabel?.text = ""
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func reloadDataOnScreen(){
        self.tableView.reloadData()
    }
}
