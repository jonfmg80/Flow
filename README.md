#  Flow — SwiftUI Weather App

A modern iOS weather application built with SwiftUI and async/await, demonstrating MVVM architecture, REST API integration, reusable UI components, and responsive state-driven interfaces.

## Tech Stack
- Swift
- SwiftUI
- Async/Await
- MVVM
- URLSession
- XCTest

## Features
- Current weather
- Forecast display
- Async API loading
- Error handling
- Loading states
- Responsive SwiftUI UI

## Architecture
The app uses MVVM to separate presentation and business logic, with async/await-based networking for clean asynchronous code.

```mermaid
flowchart TD
    A[ContentView<br/>SwiftUI View] --> B[WeatherViewModel<br/>ViewModel]
    B --> C[APIService<br/>Networking Layer]
    C --> D[OpenWeather REST API]
    D --> E[Weather Data Structs / Models]
    E --> C
    C --> B
    B --> A
```

## Screenshots

<img width="328" height="679" alt="Screenshot 2026-04-25 at 9 29 32 PM" src="https://github.com/user-attachments/assets/81be2a3c-6cc2-4877-ba8e-74bb7c52b6ac" />

Currently uses openweathermap.org to get realtime weather
