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
       GeometryReader { geometry in
           if let location = viewModel.weather {
               VStack {
                   Text("\(location.name.uppercased())")
                       .frame(maxWidth: .infinity, alignment: .leading)
                       .font(.largeTitle)
                       .fontWeight(.bold)
                       .fontDesign(.rounded)
                       .padding(.bottom, 10)
                       .foregroundColor(Color.white)
                   if (location.weather.count > 0) {
                       HStack {
                           sfSymbol(for: location.weather[0].id)
                               .resizable()
                               .aspectRatio(contentMode: .fit)
                               .frame(width: 100, height: 100)
                               .foregroundColor(Color.white)
                               .clipped()
                           Text("\(location.main.temp, specifier: "%.2f")°")
                               .font(.system(size: 50, weight: .bold, design: .rounded))
                               .foregroundColor(Color.white)
                       }
                       Text(location.weather[0].description.capitalized)
                           .font(.footnote)
                           .foregroundColor(Color.white)
                       Text("H:\(location.main.temp_max, specifier: "%.2f")° L:\(location.main.temp_min, specifier: "%.2f")° ")
                           .font(.footnote)
                           .foregroundColor(Color.white)
                   }
               }
               .padding()
               .background(Color.blue, in: RoundedRectangle(cornerRadius: 15))
               .shadow(color: Color.white.opacity(100.0/255.0), radius: 15)
               .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
               
           } else if let error = viewModel.errorMessage {
               Text("Error: \(error)")
           } else {
               Text("Loading...")
           }
       }
       .padding()
       .onAppear {
           viewModel.loadWeather()
       }
   }
}

#Preview {
    ContentView()
        .background(Color.black)
}
