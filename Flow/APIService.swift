//
//  APIService.swift
//  Flow
//
//  Created by Jonathan Gonzalez on 4/24/26.
//
import Foundation

struct City: Codable {
    let id: Int
    let name: String
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int64
    let sunset: Int64
    let coord: Coordinates
}

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
    let hour: Double?
    
    private enum CodingKeys: String, CodingKey {
        case hour = "1h"
    }
}

struct Cloud: Codable {
    let all: Int
}

struct System: Codable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Int64?
    let sunset: Int64?
    let pod: String?
    
}

struct CurrentWeather: Codable {
    let coord: Coordinates?
    let weather: [Weather]
    let base: String?
    let main: Main
    let visibility: Int32
    let wind: Wind
    let rain: Rain?
    let clouds: Cloud?
    let sys: System
    let timezone: Int32?
    let id: Int?
    let name: String?
    let cod: Int32?
    let dt: Int64?
    let dt_txt: String?
}

struct Forecast: Codable {
    var list: [CurrentWeather]
    let cnt: Int
    let message: Double
    let cod: String
    let city: City
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
        
//        if let jsonString = String(data: data, encoding: .utf8) {
//            print(jsonString)
//        }
        
        do {
            let decoder = JSONDecoder()
            // If your API is snake_case, enable this. It won't fix 'username' vs 'userName', so keep CodingKeys above.
            decoder.keyDecodingStrategy = .useDefaultKeys
            let weather = try decoder.decode(CurrentWeather.self, from: data)
            //print("Decoded weather:", weather)
            
            return weather
        } catch {
            if let body = String(data: data, encoding: .utf8) {
                print("Decoding failed. Raw body:", body)
            }
            print("Decoding error:", error)
            throw APIError.decodingError
        }
    }

    func getDayName(for timeString: String) -> String {
        let parser = DateFormatter()
        parser.dateFormat = "yyyy-MM-dd HH:mm:ss"
        parser.timeZone = TimeZone(abbreviation: "UTC") // Matches your UTC requirement

        // 2. Set up the output formatter
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "EEE" // Full day name

        if let date = parser.date(from: timeString) {
            let dayName = displayFormatter.string(from: date)
            return dayName
        }
        return ""
    }
    
    func getForecast(lat: Double, lon: Double) async throws -> Forecast {
        
        //api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={API key}
        if (appID.isEmpty) {
            print("Missing AppID")
            throw APIError.statusNotOk
        }
        
        guard let url = URL(string:  "\(BASE_URL)/forecast?lat=\(lat)&lon=\(lon)&appid=\(appID)&units=metric") else{
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
            var forecast = try decoder.decode(Forecast.self, from: data)
            //print("Decoded forecast:", forecast)
            
            var foreCastList: [CurrentWeather] = []
            var lastDay = ""
            let currentShort = Date().formatted(Date.FormatStyle().weekday(.abbreviated))
            print (currentShort)
            for weather in forecast.list {
                if let timeString = weather.dt_txt {
                    let dayName = getDayName(for: timeString)
                    if lastDay.isEmpty {
                        if dayName != currentShort {
                            foreCastList.append(weather)
                            lastDay = dayName
                        }
                    } else if lastDay != dayName {
                        foreCastList.append(weather)
                        lastDay = dayName
                    }
                }
            }
            forecast.list = foreCastList
            //modify forecasted depending on current time +
            
            return forecast
        } catch {
            if let body = String(data: data, encoding: .utf8) {
                print("Decoding failed. Raw body:", body)
            }
            print("Decoding error:", error)
            throw APIError.decodingError
        }
    }
}
