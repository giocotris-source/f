import Foundation

class WeatherManager {
    func fetchWeather(completion: @escaping (String) -> Void) {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=45.8081&longitude=9.0832&current_weather=true"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let current = json["current_weather"] as? [String: Any],
                  let temp = current["temperature"] as? Double else {
                DispatchQueue.main.async { completion("--°C") }
                return
            }
            DispatchQueue.main.async {
                completion("\(temp)°C")
            }
        }.resume()
    }
}
