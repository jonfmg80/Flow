//
//  ForecastCard.swift
//  Flow
//
//  Created by Jonathan Gonzalez on 5/6/26.
//

import SwiftUI

struct ForecastCard: View {
    let forecast: Forecast
    
    var body: some View {
        
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
    }
}

#Preview {
    let weather = CurrentWeather(coord: Coordinates(lat: 14.6042, lon: 120.9822), weather: [Weather(id: 501, main: "Rain", description: "moderate rain", icon: "10d")], base: "stations", main: Main(temp: 298.48, feels_like: 298.74, temp_min: 297.56, temp_max: 300.05, pressure: 1015, humidity: 64, sea_level: 1015, grnd_level: 933), visibility: 10000, wind: Wind(speed: 0.62, deg: 349, gust: 1.18), rain: Rain(hour: 12.0), clouds: Cloud(all: 10), sys: System(type: 2, id: 2075663, country: "IT", sunrise: 1661834187, sunset: 1661882248, pod: ""), timezone: 7200, id: 3163858, name: "Zocca", cod: 200, dt: 1661870592, dt_txt: "")
    
    let forecast = Forecast(list: [weather], cnt: 40, message: 0, cod: "200", city: City(id: 3163858, name: "Zocca", country: "IT", population: 4593, timezone: 7200, sunrise: 1661834187, sunset: 1661882248, coord: Coordinates(lat: 44.34, lon: 10.99)))
        
    ForecastCard(forecast: forecast)
        .background(Color.black, in: RoundedRectangle(cornerRadius: 15))
}
