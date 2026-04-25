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
           LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]), startPoint:.trailing, endPoint: .leading)
               .ignoresSafeArea()
           GeometryReader { geometry in
               if let location = viewModel.weather {
                   VStack {
                       VStack {
                           if let locationName = location.name {
                               WeatherHeaderTitle(locationName: locationName)
                           }
                           
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
                           } else {
                               Text("Missing weather forecast for your city")
                           }
                       }
                       .padding()
                       .background(Color.white.opacity(30.0/255.0), in: RoundedRectangle(cornerRadius: 15))
                       .shadow(color: Color.white.opacity(100.0/255.0), radius: 15)
                       .frame(width: geometry.size.width, alignment: .top)
                       
                       if let forecast = viewModel.forecast {
                           VStack {
                               Text("Weekly Forecast")
                                   .font(.largeTitle)
                                   .fontWeight(.bold)
                                   .fontDesign(.rounded)
                                   .foregroundColor(Color.white)
                                   .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .center))
                               HStack {
                                   ForEach(forecast.list.indices.prefix(7), id:\.self) { index in
                                       VStack {
                                           if (forecast.list[index].weather.count > 0) {
                                               if let timeString =  forecast.list[index].dt_txt {
                                                   Text("\(getDayName(for: timeString))")
                                                       .foregroundColor(.white)
                                                       .bold()
                                               }
                                               
                                               sfSymbol(for: forecast.list[index].weather[0].id)
                                                   .resizable()
                                                   .aspectRatio(contentMode: .fit)
                                                   .frame(width: 50, height: 50)
                                                   .foregroundColor(Color.white)
                                                   .clipped()
                                                   .padding(.bottom, 10)
                                               
                                               Text("H:\(forecast.list[index].main.temp_max, specifier: "%.2f")°")
                                                   .font(.footnote)
                                                   .foregroundColor(Color.white)
                                               Text("L:\(forecast.list[index].main.temp_min, specifier: "%.2f")° ")
                                                   .font(.footnote)
                                                   .foregroundColor(Color.white)
                                           }
                                       }
                                   }
                                   .frame(maxWidth: .infinity)
                               }
                           }
                           .padding()
                           .background(Color.white.opacity(30.0/255.0), in: RoundedRectangle(cornerRadius: 15))
                           .shadow(color: Color.white.opacity(100.0/255.0), radius: 15)
                           .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
                       }
                   }
               } else if let error = viewModel.errorMessage {
                   Text("Error: \(error)")
               } else {
                   Text("Loading...")
                       .foregroundColor(.white)
               }
           }
           .padding(EdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 5))
           .onAppear {
               viewModel.loadWeather()
               
           }
       }
   }
}

#Preview {
    ContentView()
}
