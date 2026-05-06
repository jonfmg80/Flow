//
//  CurrentWeatherCard.swift
//  Flow
//
//  Created by Jonathan Gonzalez on 5/6/26.
//

import SwiftUI

struct CurrentWeatherCard: View {
    let weather: CurrentWeather
    
    var body: some View {
        VStack {
            if let locationName = weather.name {
                WeatherHeaderTitle(locationName: locationName)
            }
            
            if let condition = weather.weather.first { // Do something is there's more than one
                HStack {
                    sfSymbol(for: condition.id)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.white)
                        .clipped()
                    Text("\(weather.main.temp, specifier: "%.2f")°")
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .foregroundColor(Color.white)
                }
                Text(condition.description.capitalized)
                    .font(.footnote)
                    .foregroundColor(Color.white)
                Text("H:\(weather.main.temp_max, specifier: "%.2f")° L:\(weather.main.temp_min, specifier: "%.2f")° ")
                    .font(.footnote)
                    .foregroundColor(Color.white)
            } else {
                Text("Missing weather forecast for your city")
            }
        }
        .padding()
        .background(Color.white.opacity(30.0/255.0), in: RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color.white.opacity(100.0/255.0), radius: 15)
    }
}
