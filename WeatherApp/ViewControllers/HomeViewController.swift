//
//  ViewController.swift
//  CoordinatorTemplate
//
//  Created by Kayo on 2025-03-27.
//

import UIKit
import SDWebImage
import CoreLocation

class HomeViewController: BaseViewController {

    let viewModel: HomeViewModel
    let locationManager = LocationManager()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "City, Country"
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = CGSize(width: 200, height: 200)
        return imageView
    }()
    
    private lazy var weatherLabel: UILabel = {
        let label = UILabel()
        label.text = "Weather"
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return label
    }()

    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.text = "Temperature C"
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return label
    }()

    private lazy var feelslikeLabel: UILabel = {
        let label = UILabel()
        label.text = "Feels Like:"
        label.textAlignment = .center
        return label
    }()
    
    private var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDate = dateFormatter.string(from: Date())
        return todayDate
    }
    
    private lazy var minMaxTempLabel: UILabel = {
        let label = UILabel()
        label.text = "H: L:"
        label.textAlignment = .center
        return label
    }()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        locationManager.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    
    func configureLayout() {
        view.addSubview(containerStackView)
        containerStackView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(30)
            make.leading.trailing.equalToSuperview().inset(25)
        }
        containerStackView.addArrangedSubview(weatherLabel)
        containerStackView.addArrangedSubview(iconImageView)
        containerStackView.addArrangedSubview(locationLabel)
        containerStackView.addArrangedSubview(tempLabel)
        containerStackView.addArrangedSubview(feelslikeLabel)
        containerStackView.addArrangedSubview(minMaxTempLabel)
    }
    
    func updateView(with weather: Weather) {
        if let iconUrl = weather.current.weather_icons.first {
            iconImageView.sd_setImage(with: URL(string: iconUrl))
        }
        if let weatherDesc = weather.current.weather_descriptions.first {
            weatherLabel.text = weatherDesc
        }
        tempLabel.text = "\(weather.current.temperature) C"
        locationLabel.text = "\(weather.location.name), \(weather.location.country)"
        feelslikeLabel.text = "Feels Like: \(weather.current.feelslike) C"
        if let forecast = weather.forecast[dateString] {
            minMaxTempLabel.text = "H: \(forecast.maxtemp), L: \(forecast.mintemp)"
        }
    }
}

extension HomeViewController: LocationManagerDelegate {
    func didUpdatesLocation(_ location: CLLocation) {
        Task {
            do {
                let weather = try await viewModel.getWeatherForecast(from: location)
                updateView(with: weather)
            } catch {
                presentErrorAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}
