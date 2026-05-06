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
