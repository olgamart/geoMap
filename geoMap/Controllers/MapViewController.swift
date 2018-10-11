//
//  MapViewController.swift
//  geoMap
//
//  Created by Olga Martyanova on 16/09/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import RxSwift


class MapViewController: UIViewController {
    private let locationManager = LocationManager.instance
    private var isUpdateLocation = false
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?
    private var marker: GMSMarker?    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    @IBOutlet var router: MapRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
    }
    
    private func configureLocationManager(){
        locationManager
        .location
        .asObservable()
            .bind { [weak self] location in
                guard let location = location else { return }
                self?.routePath?.add(location.coordinate)
                self?.route?.path = self?.routePath
                self?.addMarker(coordinate: location.coordinate)
                self?.configureMap(coordinate: location.coordinate)
        }
        .disposed(by: disposeBag)
    }
    
    private func configureMap(coordinate:CLLocationCoordinate2D){
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        mapView.animate(to: camera)
    }
    
    private func savePath(){
        locationManager.stopUpdatingLocation()
        if let savePath = self.routePath?.encodedPath(){
            let path = Path(path: savePath)
            RealmService.saveData(saveObjects: path, type: Path.self)
        }
    }
    
    private func loadPath(){
        self.routePath = nil
        if let loadPath = RealmService.loadData(type: Path.self) as? Path{
            self.routePath = GMSMutablePath(fromEncodedPath: loadPath.path)
        }
        
        DispatchQueue.main.async {
            self.mapView.clear()
            self.marker = nil
            self.route?.map = nil
            self.route = GMSPolyline(path: self.routePath)
            self.route?.strokeWidth = 4
            self.route?.strokeColor = .green
            self.route?.map = self.mapView
            if let setBoundsPath = self.routePath{
                let bounds = GMSCoordinateBounds(path: setBoundsPath)
                self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 100.0))
            }
        }
    }
    
    func addMarker(coordinate:CLLocationCoordinate2D){
        if let marker = marker {
            marker.position = coordinate
        } else {
        marker = GMSMarker(position: coordinate)
        marker?.map = mapView
        }
    }
    
    
    @IBAction func loadLocation(_ sender: Any) {
        if isUpdateLocation{
            let alert = UIAlertController(title: "Закончить трек?", message: nil,
                                          preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Да", style: UIAlertAction.Style.default,
                                          handler: { [weak self] action in
                                            self?.locationManager.stopUpdatingLocation()
                                            DispatchQueue.global().async {
                                                self?.savePath()
                                                self?.loadPath()
                                            }
                                            self?.updateButton.title = "Отслеживать"
                                            self?.isUpdateLocation = false
            }))
            alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            DispatchQueue.global().async {
                self.loadPath()
            }
        } 
    }
    
    @IBAction func backButton(_ sender: Any) {
        router.toLogin(controller: self)
        locationManager.stopUpdatingLocation()
    }
    @IBAction func updateLocation(_ sender: Any) {
        
        if isUpdateLocation {
            DispatchQueue.global().async {
                self.savePath()
            }
            updateButton.title = "Отслеживать"
            isUpdateLocation = false
        } else {
            photoMessage()
            route?.map = nil
            route = GMSPolyline()
            route?.strokeColor = .red
            route?.strokeWidth = 4
            routePath = GMSMutablePath()
            route?.map = mapView
            locationManager.startUpdatingLocation()
            updateButton.title = "Закончить"
            isUpdateLocation = true
        }
    }
    
    func photoMessage() {
        
        let alert = UIAlertController(title: "Сделать фото?", message: nil,
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Да", style: UIAlertAction.Style.default,
                                      handler: { [weak self] action in
                                      self?.takePicture()
                                        
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertAction.Style.default,
                                      handler:{[weak self] action in
            self?.marker?.iconView = nil
            self?.marker?.icon = GMSMarker.markerImage(with: .red)
            self?.marker?.map = self?.mapView
            self?.marker = self?.marker
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    private func savePhoto(photo: UIImage){
        let tmpDirectory = FileManager.default.temporaryDirectory
        let filePath = tmpDirectory.appendingPathComponent("photo.png").path
        let data = photo.pngData()
        FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
    }
    
    private func readPhoto() -> UIImage? {
        let tmpDirectory = FileManager.default.temporaryDirectory
        let filePath = tmpDirectory.appendingPathComponent("photo.png").path
        return UIImage(contentsOfFile: filePath)
    }
    
   private func takePicture(){
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true )
    }
  
}

extension MapViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true) {[weak self]  in
            guard let myImage = self?.extractImage(from: info) else { return }
            
            self?.savePhoto(photo: myImage)
            guard let photo = self?.readPhoto() else {return}

            let resImage = photo.resizeImageWith(sizeMax: 100.0)
       
            let imageView = UIImageView(image: resImage)
            imageView.cornerRadius(radius: 10)
            imageView.border(color: .green, width: 2)
            
            self?.marker?.iconView = imageView
            self?.marker?.map = self?.mapView
            self?.marker = self?.marker
        
        }
    }

    private func extractImage(from info: [UIImagePickerController.InfoKey : Any]) -> UIImage? {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            return image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            return image
        } else {
            return nil
        }
    }
}

    

