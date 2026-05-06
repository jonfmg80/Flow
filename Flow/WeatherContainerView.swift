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
                VStack {
                    if let locationName = weather.name {
                        WeatherHeaderTitle(locationName: locationName)
                    }
                    
                    if (weather.weather.count > 0) {
                        HStack {
                            sfSymbol(for: weather.weather[0].id)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .foregroundColor(Color.white)
                                .clipped()
                            Text("\(weather.main.temp, specifier: "%.2f")°")
                                .font(.system(size: 50, weight: .bold, design: .rounded))
                                .foregroundColor(Color.white)
                        }
                        Text(weather.weather[0].description.capitalized)
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
                .frame(width: geometry.size.width, alignment: .top)
                
                if let forecast {
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
        }
        .padding(EdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 5))
    }
}
