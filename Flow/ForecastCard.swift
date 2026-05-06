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
