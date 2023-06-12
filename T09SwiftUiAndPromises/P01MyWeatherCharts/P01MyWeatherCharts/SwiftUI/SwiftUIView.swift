//
//  SwiftUIView.swift
//  SwiftUIDemo
//
//  Created by Georgi Manev on 30.01.23.
//

import SwiftUI

struct WeatherDataViewCell: View {
    var title: String
    var detail: String
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(detail)
        }
    }
}

struct SwiftUIView: View {
    @ObservedObject var viewModel = WeatherViewModel.instance
    
    var body: some View {
        VStack {
            Spacer()

            Text(viewModel.locationText)
            Spacer(minLength: 20)

            Text(viewModel.weatherConditionText)
            Image(systemName: viewModel.weatherConditionIconName).resizable().foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/).scaledToFit().frame(width: 128, height: 128)
            
            Spacer(minLength: 20)
            List {
                WeatherDataViewCell(title: "Temperature", detail: viewModel.temperatureDetail )
                
                WeatherDataViewCell(title: "Humidity", detail: viewModel.humidityDetail )
                
                WeatherDataViewCell(title: "Air pressure", detail: viewModel.surfacePressureDetail )
                
                WeatherDataViewCell(title: "Wind direction", detail: viewModel.winddirectionDetail )
                
                WeatherDataViewCell(title: "Wind speed", detail: viewModel.windspeedDetail )
                
                WeatherDataViewCell(title: "Visibility", detail: viewModel.visibilityDetail  )
                
                WeatherDataViewCell(title: "Last update", detail: viewModel.lastUpdatedDetail )
            }
            Spacer()
        }
        .onAppear{
            if let locationName = LocalDataManager.locationName {
                if LocalDataManager.getWeatherData(locationName: locationName) != nil {
                    NotificationCenter.default.post(name: .dataUpdated, object: nil)
                }
            }
            
            RequestManager.fetchData()
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
