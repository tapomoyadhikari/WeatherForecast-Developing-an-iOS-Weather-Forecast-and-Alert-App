import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getWeatherData()
    }
    
    func getWeatherData() {
        let apiKey = "your_api_key_here"
        let city = "New York"
        let urlString = "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=imperial"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                    DispatchQueue.main.async {
                        self.currentTempLabel.text = "\(weatherData.main.temp)°F"
                        self.cityNameLabel.text = weatherData.name
                        let iconCode = weatherData.weather[0].icon
                        let iconUrl = URL(string: "http://openweathermap.org/img/w/\(iconCode).png")
                        if let imageData = try? Data(contentsOf: iconUrl!) {
                            self.weatherImageView.image = UIImage(data: imageData)
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let icon: String
}
