//
//  WeatherData.swift
//  WeatherShow
//
//  Created by Anton Grishin on 18.03.2026.
//

import Foundation

public enum WeatherResponse {
	case data(WeatherData)
	case error(Error)
	case noData
	case updating
}

public struct LocationStruct: Decodable {
	let name: String
	let region: String
	let country: String
	let lat: Double
	let lon: Double
	let tz_id: String
	let localtime_epoch: Int
	let localtime: String
}

public struct WeatherCondition: Decodable {
	let text: String
	let icon: String
	let code: Int
}
public struct CurrentWeather: Decodable {
	let last_updated_epoch: Int
	let last_updated: String
	let temp_c: Double
	let temp_f: Double
	let is_day: Int
	let condition: WeatherCondition
	let wind_mph: Double
	let wind_kph: Double
	let wind_degree: Double
	let wind_dir: String
	let pressure_mb: Double
	let pressure_in: Double
	let precip_mm:  Double
	let precip_in: Double
	let humidity: Double
	let cloud: Double
	let feelslike_c: Double
	let feelslike_f: Double
	let windchill_c: Double
	let windchill_f: Double
	let heatindex_c: Double
	let heatindex_f: Double
	let dewpoint_c: Double
	let dewpoint_f: Double
	let vis_km: Double
	let vis_miles: Double
	let uv: Double
	let gust_mph: Double
	let gust_kph: Double
}

public struct DayWeather: Decodable {
	let maxtemp_c: Double
	let maxtemp_f: Double
	let mintemp_c: Double
	let mintemp_f: Double
	let avgtemp_c: Double
	let avgtemp_f: Double
	let maxwind_mph: Double
	let maxwind_kph: Double
	let totalprecip_mm: Double
	let totalprecip_in: Double
	let totalsnow_cm: Double
	let avgvis_km: Double
	let avgvis_miles: Double
	let avghumidity: Double
	let daily_will_it_rain: Double
	let daily_chance_of_rain: Double
	let daily_will_it_snow: Double
	let daily_chance_of_snow: Double
	let condition: WeatherCondition
	let uv: Double
}

public struct AstroData: Decodable {
	let sunrise: String
	let sunset: String
	let moonrise: String
	let moonset: String
	let moon_phase: String
	let moon_illumination: Double
	let is_moon_up: Int
	let is_sun_up: Int
}
public struct HourData: Decodable {
	let time_epoch: Int
	let time: String
	let temp_c: Double
	let temp_f: Double
	let is_day: Int
	let condition: WeatherCondition
	let wind_mph: Double
	let wind_kph: Double
	let wind_degree: Double
	let wind_dir: String
	let pressure_mb: Double
	let pressure_in: Double
	let precip_mm: Double
	let precip_in: Double
	let snow_cm: Double
	let humidity: Double
	let cloud: Double
	let feelslike_c: Double
	let feelslike_f: Double
	let windchill_c: Double
	let windchill_f: Double
	let heatindex_c: Double
	let heatindex_f: Double
	let dewpoint_c: Double
	let dewpoint_f: Double
	let will_it_rain: Double
	let chance_of_rain: Double
	let will_it_snow: Double
	let chance_of_snow: Double
	let vis_km: Double
	let vis_miles: Double
	let gust_mph: Double
	let gust_kph: Double
	let uv: Double
}
public struct ForecastDay: Decodable {
	let date: String
	let date_epoch: Int
	let day: DayWeather
	let astro: AstroData
	let hour: [HourData]
}

public struct ForecastData: Decodable {
	let forecastday: [ForecastDay]
}

public struct WeatherData: Decodable {
	let location: LocationStruct
	let current: CurrentWeather
	let forecast: ForecastData?
}
