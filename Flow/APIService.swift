//
//  APIService.swift
//  Flow
//
//  Created by Jonathan Gonzalez on 4/24/26.
//
import Foundation

struct Coordinates: Codable {
    let lat: Double
    let lon: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let sea_level: Int
    let grnd_level: Int
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

struct Rain: Codable {
    let hour: Double
    
    private enum CodingKeys: String, CodingKey {
        case hour = "1h"
    }
}

struct Cloud: Codable {
    let all: Int
}

struct System: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int64
    let sunset: Int64
    
}

struct CurrentWeather: Codable {
    let coord: Coordinates
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int32
    let wind: Wind
    let rain: Rain?
    let clouds: Cloud?
    let sys: System
    let timezone: Int32
    let id: Int
    let name: String
    let cod: Int32
}

enum APIError: Error {
    case invalidUrl, requestError, decodingError, statusNotOk
}

struct APIService {

    //let appID = Bundle.main.object(forInfoDictionaryKey: "AppId") as? String ?? ""
    let appID = "ca357bc9cfc66493539c3580c1273dab"

    let BASE_URL = "https://api.openweathermap.org/data/2.5"
    func getCurrentWeather(lat: Double, lon: Double) async throws -> CurrentWeather {

        if (appID.isEmpty) {
            print("Missing AppID")
            throw APIError.statusNotOk
        }
        
        guard let url = URL(string:  "\(BASE_URL)/weather?lat=\(lat)&lon=\(lon)&appid=\(appID)&units=metric") else{
            throw APIError.invalidUrl
        }
        
        print("Requesting:", url.absoluteString)
        let (data, response) = try await URLSession.shared.data(from: url)
//        guard let (data, response) = try? await URLSession.shared.data(from: url) else{
//            throw APIError.requestError
//        }

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw APIError.statusNotOk
        }
        
        print("Status:", response.statusCode)
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString)
        }
        
        do {
            let decoder = JSONDecoder()
            // If your API is snake_case, enable this. It won't fix 'username' vs 'userName', so keep CodingKeys above.
            decoder.keyDecodingStrategy = .useDefaultKeys
            let weather = try decoder.decode(CurrentWeather.self, from: data)
            print("Decoded weather:", weather)
            
            return weather
        } catch {
            if let body = String(data: data, encoding: .utf8) {
                print("Decoding failed. Raw body:", body)
            }
            print("Decoding error:", error)
            throw APIError.decodingError
        }
    }

}
