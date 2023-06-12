//
//  ChartViewController.swift
//  P01MyWeatherCharts
//
//  Created by Georgi Manev on 29.01.23.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    var weather: WeatherForecast?
    
    var timePeriod: [String] = []
    var temperatureArr: [Double] = []
    var relativeHumidityArr: [Double] = []
    var precipitationArr: [Double] = []
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = UIColor(named: "chartColor")
        chartView.rightAxis.enabled = false
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12.0)
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lineChartView.frame = CGRect(x: 0,
                                     y: 0,
                                     width: self.view.frame.size.width,
                                     height: self.view.frame.size.width)
        lineChartView.center = view.center
        view.addSubview(lineChartView)
        lineChartView.xAxis.valueFormatter = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let locationName = LocalDataManager.locationName {
            self.weather = LocalDataManager.getWeatherData(locationName: locationName)?.weatherForecast
            self.loadingData()
        }
    }
    
    private func loadingData() {
        guard let time = self.weather?.hourly?.time,
              let temperature = self.weather?.hourly?.temperature_2m,
              let humidity = self.weather?.hourly?.relativehumidity_2m,
              let precipitation = self.weather?.hourly?.precipitation else {
            return
        }
        
        self.timePeriod = Array(time)
        self.temperatureArr = Array(temperature)
        self.relativeHumidityArr = Array(humidity)
        self.precipitationArr = Array(precipitation)
        
        self.setChartData()
    }
    
    private func setChartData(){
        
        var yVals1: [ChartDataEntry] = [ChartDataEntry]()
                
        for i in 0..<timePeriod.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: temperatureArr[i])
            yVals1.append(dataEntry)
        }
             
        let tempUnit: String = LocalDataManager.dataForLocation?.weatherForecast?.hourly_units?.temperature_2m == "Celsius °C" ? "°C" : "°F"
        let chartDataSet1 = LineChartDataSet(entries: yVals1, label: "temperature(\(tempUnit))")
        chartDataSet1.drawCirclesEnabled = false
        chartDataSet1.setColor(.white)
        
        var yVals2: [ChartDataEntry] = [ChartDataEntry]()
                
        for i in 0..<timePeriod.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: relativeHumidityArr[i])
            yVals2.append(dataEntry)
        }
                
        let chartDataSet2 = LineChartDataSet(entries: yVals2, label: "relative_humidity(%)")
        chartDataSet2.drawCirclesEnabled = false
        chartDataSet2.setColor(.red)
        
        var yVals3: [ChartDataEntry] = [ChartDataEntry]()
                
        for i in 0..<timePeriod.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: precipitationArr[i])
            yVals3.append(dataEntry)
        }
                
        let chartDataSet3 = LineChartDataSet(entries: yVals3, label: "precipitation(mm)")
        chartDataSet3.drawCirclesEnabled = false
        chartDataSet3.setColor(.green)
        
        let chartData = LineChartData(dataSets: [chartDataSet1, chartDataSet2, chartDataSet3])
        self.lineChartView.data = chartData
        self.lineChartView.animate(xAxisDuration: 2.5)
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

extension ChartViewController: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: Charts.AxisBase?) -> String {
        return "" //timePeriod[Int(value)]
    }

}
