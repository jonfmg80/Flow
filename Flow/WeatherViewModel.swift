//
//  WeatherViewModel.swift
//  Flow
//
//  Created by Jonathan Gonzalez on 4/24/26.
//

import SwiftUI
import CoreLocation
import Combine

@MainActor
class WeatherViewModel: ObservableObject {
    
    @Published var weather: CurrentWeather?
    @Published var forecast: Forecast?
    @Published var errorMessage: String?
    @Published var location: CLLocation?
    
    private let locationManager = LocationManager()
    private let apiService = APIService()
    
    func loadWeather() {
        Task {
            do {
                let location = try await locationManager.requestLocation()
                
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                
//                let lat = 14.3939
//                let lon = 121.0412
                
                let result = try await apiService.getCurrentWeather(lat: lat, lon: lon)
                let forecastResult = try await apiService.getForecast(lat: lat, lon: lon)
                
                print(forecastResult.list.count)
                
                self.weather = result
                self.forecast = forecastResult
                
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
