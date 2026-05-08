//
//  WeatherBackgroundView.swift
//  Flow
//
//  Created by Jonathan Gonzalez on 5/6/26.
//

import SwiftUI

struct WeatherBackgroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]), startPoint:.trailing, endPoint: .leading)
            .ignoresSafeArea()
    }
}

#Preview {
    WeatherBackgroundView()
}
