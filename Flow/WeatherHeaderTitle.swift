//
//  WeatherHeaderTitle.swift
//  Flow
//
//  Created by Jonathan Gonzalez on 4/25/26.
//

import SwiftUI

struct WeatherHeaderTitle: View {
    let locationName: String
    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text("\(locationName.uppercased())")
                .font(.largeTitle)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .foregroundColor(Color.white)
            Image(systemName: "mappin.and.ellipse.circle.fill")
                .resizable()
                .foregroundColor(Color.white)
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25, alignment: .top)
                .clipped()
        }
        .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .center))
    }
}
