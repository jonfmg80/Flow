//
//  WeatherContainerView.swift
//  Flow
//
//  Created by Jonathan Gonzalez on 5/6/26.
//

import SwiftUI

struct WeatherContainerView: View {
    
    let forecast: Forecast?
    let weather: CurrentWeather
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                CurrentWeatherCard(weather: weather)
                    .frame(width: geometry.size.width)
                
                if let forecast {
                    ForecastCard(forecast: forecast)
                        .frame(width: geometry.size.width)
                }
            }
            .frame(width: geometry.size.width, alignment: .top)
        }
        .padding(EdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 5))
    }
}

#Preview {
    let weather = CurrentWeather(coord: Coordinates(lat: 14.6042, lon: 120.9822), weather: [Weather(id: 501, main: "Rain", description: "moderate rain", icon: "10d")], base: "stations", main: Main(temp: 298.48, feels_like: 298.74, temp_min: 297.56, temp_max: 300.05, pressure: 1015, humidity: 64, sea_level: 1015, grnd_level: 933), visibility: 10000, wind: Wind(speed: 0.62, deg: 349, gust: 1.18), rain: Rain(hour: 12.0), clouds: Cloud(all: 10), sys: System(type: 2, id: 2075663, country: "IT", sunrise: 1661834187, sunset: 1661882248, pod: ""), timezone: 7200, id: 3163858, name: "Zocca", cod: 200, dt: 1661870592, dt_txt: "")
    
    let forecast = Forecast(list: [weather], cnt: 40, message: 0, cod: "200", city: City(id: 3163858, name: "Zocca", country: "IT", population: 4593, timezone: 7200, sunrise: 1661834187, sunset: 1661882248, coord: Coordinates(lat: 44.34, lon: 10.99)))
    
    WeatherContainerView(forecast: forecast, weather: weather)
        .background(Color.black)
}
