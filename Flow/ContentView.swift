//
//  ContentView.swift
//  Flow
//
//  Created by Jonathan Gonzalez on 4/23/26.
//

import SwiftUI
import SwiftData

func sfSymbol(for code: Int) -> Image {
    let symbolName: String
    
    switch code {
        case 200...299:
            symbolName = "cloud.bolt.rain.fill" // Thunderstorm
        case 300...399:
            symbolName = "cloud.drizzle.fill"   // Drizzle
        case 500...599:
            symbolName = "cloud.rain.fill"      // Rain
        case 600...699:
            symbolName = "snow"                 // Snow
        case 700...799:
            symbolName = "cloud.fog.fill"       // Atmosphere/Fog
        case 800:
            symbolName = "sun.max.fill"         // Clear
        case 801...899:
            symbolName = "cloud.fill"           // Clouds
        default:
            symbolName = "questionmark.circle"  // Fallback
        }
    
    return Image(systemName: symbolName)
}

func sfSymbol(for description: String) -> Image {
    let mapping: [String: String] = [
        "clear sky": "sun.max.fill",
        "few clouds": "cloud.sun",
        "scattered clouds": "cloud.sun.fill",
        "broken clouds": "cloud.fill",
        "shower rain": "cloud.sun.rain.fill",
        "rain": "cloud.rain.fill",
        "thunderstorm": "cloud.bolt.rain.fill",
        "snow": "cloud.snow.fill",
        "mist": "cloud.fog.fill"
    ]
    
    // Normalize input to lowercase to handle variations like "Home" vs "home"
    let symbolName = mapping[description.lowercased()] ?? "questionmark.circle"
    
    return Image(systemName: symbolName)
}

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
       
   var body: some View {
       VStack {
           if let weather = viewModel.weather {
               Text("\(weather.name)")
               Text("Temp: \(weather.main.temp, specifier: "%.2f") °C")
               if (weather.weather.count > 0) {
                   HStack {
                       sfSymbol(for: weather.weather[0].id)
                       Text(weather.weather[0].description.capitalized)
                   }
               }
           } else if let error = viewModel.errorMessage {
               Text("Error: \(error)")
           } else {
               Text("Loading...")
           }
       }
       .onAppear {
           viewModel.loadWeather()
       }
   }
}

#Preview {
    ContentView()
}
