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

func getDayName(for timeString: String) -> String {
    let parser = DateFormatter()
    parser.dateFormat = "yyyy-MM-dd HH:mm:ss"
    parser.timeZone = TimeZone(abbreviation: "UTC") // Matches your UTC requirement

    // 2. Set up the output formatter
    let displayFormatter = DateFormatter()
    displayFormatter.dateFormat = "EEE" // Full day name

    if let date = parser.date(from: timeString) {
        let dayName = displayFormatter.string(from: date)
        return dayName
    }
    return ""
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
        ZStack {
           WeatherBackgroundView()
           content
           .onAppear {
               viewModel.loadWeather()
           }
       }
   }
    
    @ViewBuilder
    private var content: some View {
        if let weather = viewModel.weather {
            WeatherContainerView(
                forecast: viewModel.forecast,
                weather: weather
            )
        } else if let errorMessage = viewModel.errorMessage {
            Text("Error: \(errorMessage)")
                .foregroundColor(.red)
        } else {
            Text("Loading…")
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ContentView()
}
