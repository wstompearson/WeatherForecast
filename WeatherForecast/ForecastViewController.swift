//
//  ForecastViewController.swift
//  WeatherForecast
//
//  Created by Tom Pearson on 26/04/2018.
//  Copyright © 2018 Tom Pearson. All rights reserved.
//

import UIKit
import CoreLocation

class ForecastViewController: UIViewController {
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var locationButtonImageView: UIImageView!
    private var backgroundImageView: UIImageView!
    
    let locationManager = CLLocationManager()
    
    var dataSource: WeatherDataSource?
    private var selectedDay: DayOfWeather?
    private var selectedWeatherOverview: WeatherDisplayable?
    
    private var dayForecastCVC: DayForecastCVC {
        return childViewControllers[0] as! DayForecastCVC
    }
    
    private var selectedItemWindAngle: CGFloat {
        guard let selectedWeatherOverview = selectedWeatherOverview else {
            return 0.0
        }
        return CGFloat(selectedWeatherOverview.windDirection) * CGFloat.pi / 180
    }
    
    private var selectedIndex: IndexPath = IndexPath(item: 0, section: 0) {
        didSet {
            collectionView.reloadItems(at: [oldValue])
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchBar.isHidden = false
        searchButton.isHidden = true
        locationButtonImageView.isHidden = true
        searchBar.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isHidden = true
        
        initialiseLocationServices()
        configureSearchBar()
        setupWeatherForCurrentLocationButton()
        setupBackground()
        
        refreshData()
    }
    
    private func initialiseLocationServices() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        default:
            break
        }
    }
    
    private func configureSearchBar() {
        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysTemplate)
        let cancelImage = UIImage(named: "cancel")?.withRenderingMode(.alwaysTemplate)
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        searchBar.setImage(searchImage, for: .search, state: .normal)
        searchBar.setImage(cancelImage, for: .clear, state: .normal)
        searchBar.tintColor = UIColor.white
        searchBar.delegate = self
        searchBar.isHidden = true
        searchButton.setImage(searchImage, for: .normal)
        searchButton.tintColor = UIColor.white
    }
    
    private func setupWeatherForCurrentLocationButton() {
        locationButtonImageView.image = UIImage(named: "directionArrow")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(locationButtonImageViewTapped))
        locationButtonImageView.addGestureRecognizer(tapGesture)
        locationButtonImageView.isUserInteractionEnabled = true
    }
    
    @objc
    func locationButtonImageViewTapped(_ sender: UIGestureRecognizer) {
        guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways else {
            let alert = UIAlertController(title: "Location Services Disabled", message: "To re-enable, please go to Settings and turn on Location Service for this app", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        guard let location: CLLocationCoordinate2D = locationManager.location?.coordinate else {
            return
        }
        let query = "lat=\(location.latitude)&lon=\(location.longitude)"
        URLWeatherDataFetcher.makeURLRequestForData(locationQuery: query, errorHandler: errorHandler) { (dataSource) in
            self.dataAvailable(dataSource: dataSource)
        }
    }
    
    private func setupBackground() {
        backgroundImageView = UIImageView(frame: view.frame)
        view.insertSubview(backgroundImageView, at: 0)
        backgroundImageView.contentMode = .scaleToFill
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.8
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 1)
        
        collectionView.backgroundColor = UIColor.clear
        dayForecastCVC.collectionView?.backgroundColor = UIColor.clear
    }
    
    func refreshData() {
        let previousQuery = UserDefaults.standard.string(forKey: "previousQuery")
        let query = previousQuery ?? "q=London,uk"
        URLWeatherDataFetcher.makeURLRequestForData(locationQuery: query, errorHandler: errorHandler) { (dataSource) in
            self.dataAvailable(dataSource: dataSource)
            DispatchQueue.main.async {
                self.view.isHidden = false
            }
        }
    }
    
    func errorHandler(error: WeatherError) {
        let alert = UIAlertController(title: "Whoops", message: error.messgae, preferredStyle: .alert)
        switch error.error {
        case .dataRequestFailure:
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (_) in
                self.refreshData()
            }))
            if !view.isHidden {
                fallthrough
            }
        default:
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        }
        present(alert, animated: true)
    }
    
    private func dataAvailable(dataSource: URLWeatherDataSource) {
        self.dataSource = dataSource
        self.selectedDay = dataSource.daysOfWeather.first
        self.selectedWeatherOverview = selectedDay?.first
        self.dayForecastCVC.dataSource = dataSource.daysOfWeather.first
        UserDefaults.standard.set(dataSource.city.name, forKey: "city")
        DispatchQueue.main.async {
            self.dayForecastCVC.collectionView?.reloadData()
            self.dayForecastCVC.collectionView?.scrollToStart()
            self.locationLbl.text = dataSource.city.name
            self.dateLbl.text = "Today"
            self.updateBackgroundImageView(withWeather: self.dataSource?.daysOfWeather.first)
            self.collectionView.reloadData()
            self.collectionView.scrollToStart()
            self.collectionView(self.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
        }
    }
    
    private func updateBackgroundImageView(withWeather weather: WeatherDisplayable?) {
        guard let weather = weather, let image = AssetFactory.getBackgroundImage(forWeatherType: weather.weatherIcon) else {
            return
        }
        UIView.transition(with: backgroundImageView, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.backgroundImageView.image = image
        })
    }
    
    let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
}

extension ForecastViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.daysOfWeather.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WeatherDayCell
        guard let data = dataSource?.daysOfWeather[indexPath.row] else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = indexPath.row == selectedIndex.row ? UIColor.clear : UIColor.gray.withAlphaComponent(0.2)
        cell.maxTempLbl.text = data.maxTemp.temperatureDescription
        cell.minTempLbl.text = data.minTemp.temperatureDescription
        cell.dayLbl.text = indexPath.row == 0 ? "Today" : dayFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(data[0].dt)))
        cell.weatherImageView.image = AssetFactory.getImage(forWeatherType: data.weatherIcon)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            dayForecastCVC.todaysWeather = true
            dateLbl.text = "Today"
        } else {
            dayForecastCVC.todaysWeather = false
            dateLbl.text = dataSource?.daysOfWeather[indexPath.row].day
        }
        dayForecastCVC.dataSource = dataSource?.daysOfWeather[indexPath.row]
        dayForecastCVC.collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
        updateBackgroundImageView(withWeather: dataSource?.daysOfWeather[indexPath.row])
        dayForecastCVC.collectionView?.reloadData()
        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.clear
        selectedIndex = indexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
    }
}

extension ForecastViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text != "" else {
            finishSearching()
            return
        }
        
        URLWeatherDataFetcher.makeURLRequestForData(locationQuery: "q=\(text),uk", errorHandler: errorHandler) { (dataSource) in
            self.dataAvailable(dataSource: dataSource)
        }
        finishSearching()
    }
    
    private func finishSearching() {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.isHidden = true
        locationButtonImageView.isHidden = false
        searchButton.isHidden = false
    }
}

extension ForecastViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let radianNewHeading = CGFloat(newHeading.trueHeading) * CGFloat.pi / 180
        dayForecastCVC.orientationChanged(to: radianNewHeading)
    }
}
