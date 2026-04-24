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
    @Published var errorMessage: String?
    
    private let locationManager = LocationManager()
    private let apiService = APIService()
    
    func loadWeather() {
        Task {
            do {
                let location = try await locationManager.requestLocation()
                
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                
                let result = try await apiService.getCurrentWeather(lat: lat, lon: lon)
                
                self.weather = result
                
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
