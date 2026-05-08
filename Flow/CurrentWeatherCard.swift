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

#Preview {
    let weather = CurrentWeather(coord: Coordinates(lat: 14.6042, lon: 120.9822), weather: [Weather(id: 501, main: "Rain", description: "moderate rain", icon: "10d")], base: "stations", main: Main(temp: 298.48, feels_like: 298.74, temp_min: 297.56, temp_max: 300.05, pressure: 1015, humidity: 64, sea_level: 1015, grnd_level: 933), visibility: 10000, wind: Wind(speed: 0.62, deg: 349, gust: 1.18), rain: Rain(hour: 12.0), clouds: Cloud(all: 10), sys: System(type: 2, id: 2075663, country: "IT", sunrise: 1661834187, sunset: 1661882248, pod: ""), timezone: 7200, id: 3163858, name: "Zocca", cod: 200, dt: 1661870592, dt_txt: "")
    CurrentWeatherCard(weather: weather)
        .background(Color.black, in: RoundedRectangle(cornerRadius: 15))
}
