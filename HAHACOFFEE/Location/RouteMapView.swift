//
//  RouteMapView.swift
//  HAHACOFFEE
//
//  Created by Đinh Trung Quốc Anh on 14/1/25.
//
/*
import Foundation
import SwiftUI
import MapKit
import Firebase

struct RouteMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 10.8231, longitude: 106.6297), // Default to Ho Chi Minh City
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    @State private var route: MKRoute?
    @State private var distanceInKm: Double = 0.0
    @State private var shippingCost: Double = 0.0
    @State private var userLocation: CLLocationCoordinate2D?

    let shopLocation: CLLocationCoordinate2D
    let orderId: String // Pass the order ID to fetch the specific order

    var body: some View {
        ZStack {
            if let userLocation = userLocation {
                Map(coordinateRegion: $region, annotationItems: [shopLocation, userLocation].map { LocationAnnotation(coordinate: $0) }) { annotation in
                    MapPin(coordinate: annotation.coordinate)
                }
                .overlay(routeOverlay())
                .ignoresSafeArea()

                VStack {
                    Spacer()
                    if distanceInKm > 0 {
                        Text("Distance: \(String(format: "%.2f", distanceInKm)) km")
                            .font(.headline)
                            .padding(.bottom, 5)
                        Text("Shipping Cost: \(String(format: "%.0f", shippingCost)) VND")
                            .font(.headline)
                            .padding(.bottom, 20)
                    }
                }
            } else {
                Text("Fetching user location...")
                    .font(.headline)
            }
        }
        .onAppear {
            fetchUserLocation(for: orderId)
        }
    }

    private func fetchUserLocation(for orderId: String) {
        let db = Firestore.firestore()
        db.collection("Orders").whereField("orderId", isEqualTo: orderId).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching order: \(error.localizedDescription)")
                return
            }

            guard let document = snapshot?.documents.first, let data = document.data() as? [String: Any],
                  let latLon = data["LatLon"] as? [String: Double],
                  let latitude = latLon["latitude"],
                  let longitude = latLon["longitude"] else {
                print("Error parsing user location")
                return
            }

            self.userLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.drawRoute()
        }
    }

    private func drawRoute() {
        guard let userLocation = userLocation else { return }

        let shopPlacemark = MKPlacemark(coordinate: shopLocation)
        let userPlacemark = MKPlacemark(coordinate: userLocation)

        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: shopPlacemark)
        directionRequest.destination = MKMapItem(placemark: userPlacemark)
        directionRequest.transportType = .automobile

        let directions = MKDirections(request: directionRequest)
        directions.calculate { response, error in
            guard let route = response?.routes.first, error == nil else {
                print("Error calculating route: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self.route = route
            self.distanceInKm = route.distance / 1000.0 // Convert meters to kilometers
            self.shippingCost = self.distanceInKm * 5000 // Calculate cost based on 5000 VND per km

            self.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: (shopLocation.latitude + userLocation.latitude) / 2,
                    longitude: (shopLocation.longitude + userLocation.longitude) / 2
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: abs(shopLocation.latitude - userLocation.latitude) * 1.5,
                    longitudeDelta: abs(shopLocation.longitude - userLocation.longitude) * 1.5
                )
            )
        }
    }

    private func routeOverlay() -> some View {
        GeometryReader { geometry in
            if let route = route {
                MapOverlay(polyline: route.polyline, geometry: geometry)
            } else {
                EmptyView()
            }
        }
    }
}

struct MapOverlay: UIViewRepresentable {
    let polyline: MKPolyline
    let geometry: GeometryProxy

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.addOverlay(polyline)
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // No updates needed for now
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}


struct RouteMapView_Previews: PreviewProvider {
    static var previews: some View {
        RouteMapView(
            shopLocation: CLLocationCoordinate2D(latitude: 10.8231, longitude: 106.6297),
            orderId: "E69219D1-A6EE-4221-8254-9C0627D1F0C2"
        )
    }
}

import SwiftUI
import MapKit
import Firebase

struct RouteMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 10.8231, longitude: 106.6297), // Default to Ho Chi Minh City
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    @State private var route: MKRoute?
    @State private var distanceInKm: Double = 0.0
    @State private var shippingCost: Double = 0.0
    @State private var userLocation: CLLocationCoordinate2D?

    let shopLocation: CLLocationCoordinate2D

    var body: some View {
        ZStack {
            if let userLocation = userLocation {
                Map(coordinateRegion: $region, annotationItems: [shopLocation, userLocation].map { LocationAnnotation(coordinate: $0) }) { annotation in
                    MapPin(coordinate: annotation.coordinate)
                }
                .overlay(routeOverlay())
                .ignoresSafeArea()

                VStack {
                    Spacer()
                    if distanceInKm > 0 {
                        Text("Distance: \(String(format: "%.2f", distanceInKm)) km")
                            .font(.headline)
                            .padding(.bottom, 5)
                        Text("Shipping Cost: \(String(format: "%.0f", shippingCost)) VND")
                            .font(.headline)
                            .padding(.bottom, 20)
                    }
                }
            } else {
                Text("Fetching user location...")
                    .font(.headline)
            }
        }
        .onAppear {
            fetchUserLocation()
        }
    }

    private func fetchUserLocation() {
        let db = Firestore.firestore()
        db.collection("Orders").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching orders: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No orders found")
                return
            }

            // Example: Fetch the first order for demonstration
            if let firstOrder = documents.first, let data = firstOrder.data() as? [String: Any],
               let latLon = data["LatLon"] as? [String: Double],
               let latitude = latLon["latitude"],
               let longitude = latLon["longitude"] {
                self.userLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                self.drawRoute()
            } else {
                print("Error parsing user location")
            }
        }
    }

    private func drawRoute() {
        guard let userLocation = userLocation else { return }

        let shopPlacemark = MKPlacemark(coordinate: shopLocation)
        let userPlacemark = MKPlacemark(coordinate: userLocation)

        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: shopPlacemark)
        directionRequest.destination = MKMapItem(placemark: userPlacemark)
        directionRequest.transportType = .automobile

        let directions = MKDirections(request: directionRequest)
        directions.calculate { response, error in
            guard let route = response?.routes.first, error == nil else {
                print("Error calculating route: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self.route = route
            self.distanceInKm = route.distance / 1000.0 // Convert meters to kilometers
            self.shippingCost = self.distanceInKm * 5000 // Calculate cost based on 5000 VND per km

            self.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: (shopLocation.latitude + userLocation.latitude) / 2,
                    longitude: (shopLocation.longitude + userLocation.longitude) / 2
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: abs(shopLocation.latitude - userLocation.latitude) * 1.5,
                    longitudeDelta: abs(shopLocation.longitude - userLocation.longitude) * 1.5
                )
            )
        }
    }

    private func routeOverlay() -> some View {
        GeometryReader { geometry in
            if let route = route {
                MapOverlay(polyline: route.polyline, geometry: geometry)
            } else {
                EmptyView()
            }
        }
    }
}

struct MapOverlay: UIViewRepresentable {
    let polyline: MKPolyline
    let geometry: GeometryProxy

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.addOverlay(polyline)
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
     
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}

struct LocationAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct RouteMapView_Previews: PreviewProvider {
    static var previews: some View {
        RouteMapView(
            shopLocation: CLLocationCoordinate2D(latitude: 10.8231, longitude: 106.6297)
        )
    }
}


import SwiftUI
import MapKit

struct RouteMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 10.8231, longitude: 106.6297), // Default to Ho Chi Minh City
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    @State private var route: MKRoute?
    @State private var distanceInKm: Double = 0.0
    @State private var shippingCost: Double = 0.0

    let shopLocation: CLLocationCoordinate2D
    let userLocation: CLLocationCoordinate2D

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: [shopLocation, userLocation].map { LocationAnnotation(coordinate: $0) }) { annotation in
                MapPin(coordinate: annotation.coordinate)
            }
            .overlay(routeOverlay())
            .ignoresSafeArea()

            VStack {
                Spacer()
                if distanceInKm > 0 {
                    Text("Distance: \(String(format: "%.2f", distanceInKm)) km")
                        .font(.headline)
                        .padding(.bottom, 5)
                    Text("Shipping Cost: \(String(format: "%.0f", shippingCost)) VND")
                        .font(.headline)
                        .padding(.bottom, 20)
                }
            }
        }
        .onAppear {
            drawRoute()
        }
    }

    private func drawRoute() {
        let shopPlacemark = MKPlacemark(coordinate: shopLocation)
        let userPlacemark = MKPlacemark(coordinate: userLocation)

        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: shopPlacemark)
        directionRequest.destination = MKMapItem(placemark: userPlacemark)
        directionRequest.transportType = .automobile

        let directions = MKDirections(request: directionRequest)
        directions.calculate { response, error in
            guard let route = response?.routes.first, error == nil else {
                print("Error calculating route: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self.route = route
            self.distanceInKm = route.distance / 1000.0 // Convert meters to kilometers
            self.shippingCost = self.distanceInKm * 5000 // Calculate cost based on 5000 VND per km

            self.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: (shopLocation.latitude + userLocation.latitude) / 2,
                    longitude: (shopLocation.longitude + userLocation.longitude) / 2
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: abs(shopLocation.latitude - userLocation.latitude) * 1.5,
                    longitudeDelta: abs(shopLocation.longitude - userLocation.longitude) * 1.5
                )
            )
        }
    }

    private func routeOverlay() -> some View {
        GeometryReader { geometry in
            if let route = route {
                MapOverlay(polyline: route.polyline, geometry: geometry)
            } else {
                EmptyView()
            }
        }
    }
}

struct MapOverlay: UIViewRepresentable {
    let polyline: MKPolyline
    let geometry: GeometryProxy

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.addOverlay(polyline)
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}

struct LocationAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct RouteMapView_Previews: PreviewProvider {
    static var previews: some View {
        RouteMapView(
            shopLocation: CLLocationCoordinate2D(latitude: 10.8231, longitude: 106.6297),
            userLocation: CLLocationCoordinate2D(latitude: 10.762622, longitude: 106.660172) // Example user location
        )
    }
}


import SwiftUI
import MapKit
import Firebase

struct RouteMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 10.8231, longitude: 106.6297), // Default to Ho Chi Minh City
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    @State private var route: MKRoute?
    @State private var distanceInKm: Double = 0.0
    @State private var shippingCost: Double = 0.0
    @State private var userLocation: CLLocationCoordinate2D?

    let shopLocation: CLLocationCoordinate2D

    var body: some View {
        ZStack {
            if let userLocation = userLocation {
                Map(coordinateRegion: $region, annotationItems: [shopLocation, userLocation].map { LocationAnnotation(coordinate: $0) }) { annotation in
                    MapPin(coordinate: annotation.coordinate)
                }
                .overlay(routeOverlay())
                .ignoresSafeArea()

                VStack {
                    Spacer()
                    if distanceInKm > 0 {
                        Text("Distance: \(String(format: "%.2f", distanceInKm)) km")
                            .font(.headline)
                            .padding(.bottom, 5)
                        Text("Shipping Cost: \(String(format: "%.0f", shippingCost)) VND")
                            .font(.headline)
                            .padding(.bottom, 20)
                    }
                }
            } else {
                Text("Fetching user location...")
                    .font(.headline)
            }
        }
        .onAppear {
            fetchUserLocation()
        }
    }

    private func fetchUserLocation() {
        let db = Firestore.firestore()
        db.collection("LatLon").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching user location: \(error.localizedDescription)")
                return
            }

            guard let document = snapshot?.documents.first, let data = document.data() as? [String: Any],
                  let latitude = data["latitude"] as? Double,
                  let longitude = data["longitude"] as? Double else {
                print("Error parsing user location")
                return
            }

            self.userLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.drawRoute()
        }
    }

    private func drawRoute() {
        guard let userLocation = userLocation else { return }

        let shopPlacemark = MKPlacemark(coordinate: shopLocation)
        let userPlacemark = MKPlacemark(coordinate: userLocation)

        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: shopPlacemark)
        directionRequest.destination = MKMapItem(placemark: userPlacemark)
        directionRequest.transportType = .automobile

        let directions = MKDirections(request: directionRequest)
        directions.calculate { response, error in
            guard let route = response?.routes.first, error == nil else {
                print("Error calculating route: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self.route = route
            self.distanceInKm = route.distance / 1000.0 // Convert meters to kilometers
            self.shippingCost = self.distanceInKm * 5000 // Calculate cost based on 5000 VND per km

            self.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: (shopLocation.latitude + userLocation.latitude) / 2,
                    longitude: (shopLocation.longitude + userLocation.longitude) / 2
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: abs(shopLocation.latitude - userLocation.latitude) * 1.5,
                    longitudeDelta: abs(shopLocation.longitude - userLocation.longitude) * 1.5
                )
            )
        }
    }

    private func routeOverlay() -> some View {
        GeometryReader { geometry in
            if let route = route {
                MapOverlay(polyline: route.polyline, geometry: geometry)
            } else {
                EmptyView()
            }
        }
    }
}

struct MapOverlay: UIViewRepresentable {
    let polyline: MKPolyline
    let geometry: GeometryProxy

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.addOverlay(polyline)
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // No updates needed for now
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}

struct LocationAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct RouteMapView_Previews: PreviewProvider {
    static var previews: some View {
        RouteMapView(
            shopLocation: CLLocationCoordinate2D(latitude: 10.8231, longitude: 106.6297)
        )
    }
}
*/
import SwiftUI
import MapKit
import Firebase
 
struct RouteMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 10.8231, longitude: 106.6297), // Default to Ho Chi Minh City
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
 
    @State private var route: MKRoute?
    @State private var distanceInKm: Double = 0.0
    @State private var shippingCost: Double = 0.0
    @State private var userLocation: CLLocationCoordinate2D?
    @State private var nearestShopLocation: CLLocationCoordinate2D?
 
    var body: some View {
        ZStack {
            if let userLocation = userLocation, let nearestShopLocation = nearestShopLocation {
                Map(coordinateRegion: $region, annotationItems: [nearestShopLocation, userLocation].map { LocationAnnotation(coordinate: $0) }) { annotation in
                    MapPin(coordinate: annotation.coordinate)
                }
                .overlay(routeOverlay())
                .ignoresSafeArea()
 
                VStack {
                    Spacer()
                    if distanceInKm > 0 {
                        Text("Distance: \(String(format: "%.2f", distanceInKm)) km")
                            .font(.headline)
                            .padding(.bottom, 5)
                        Text("Shipping Cost: \(String(format: "%.0f", shippingCost)) VND")
                            .font(.headline)
                            .padding(.bottom, 20)
                    }
                }
            } else {
                Text("Fetching locations...")
                    .font(.headline)
            }
        }
        .onAppear {
            fetchUserLocation()
        }
    }
 
    private func fetchUserLocation() {
        let db = Firestore.firestore()
        db.collection("LatLon").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching user location: \(error.localizedDescription)")
                return
            }
 
            guard let document = snapshot?.documents.first, let data = document.data() as? [String: Any],
                  let latitude = data["latitude"] as? Double,
                  let longitude = data["longitude"] as? Double else {
                print("Error parsing user location")
                return
            }
 
            self.userLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.fetchNearestShopLocation()
        }
    }
 
    private func fetchNearestShopLocation() {
        guard let userLocation = userLocation else { return }
 
        let db = Firestore.firestore()
        db.collection("Test Lat Lon").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching shop locations: \(error.localizedDescription)")
                return
            }
 
            guard let documents = snapshot?.documents else {
                print("No shop locations found")
                return
            }
 
            var nearestLocation: CLLocationCoordinate2D?
            var shortestDistance: Double = Double.greatestFiniteMagnitude
 
            for document in documents {
                if let data = document.data() as? [String: Any],
                   let latitude = data["Lat"] as? Double,
                   let longitude = data["Lon"] as? Double {
                    let shopLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let distance = calculateDistance(from: userLocation, to: shopLocation)
 
                    if distance < shortestDistance {
                        shortestDistance = distance
                        nearestLocation = shopLocation
                    }
                }
            }
 
            if let nearestLocation = nearestLocation {
                self.nearestShopLocation = nearestLocation
                self.drawRoute()
            } else {
                print("No valid shop locations found")
            }
        }
    }
 
    private func calculateDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLocation.distance(from: toLocation)
    }
 
    private func drawRoute() {
        guard let userLocation = userLocation, let nearestShopLocation = nearestShopLocation else { return }
 
        let shopPlacemark = MKPlacemark(coordinate: nearestShopLocation)
        let userPlacemark = MKPlacemark(coordinate: userLocation)
 
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: shopPlacemark)
        directionRequest.destination = MKMapItem(placemark: userPlacemark)
        directionRequest.transportType = .automobile
 
        let directions = MKDirections(request: directionRequest)
        directions.calculate { response, error in
            guard let route = response?.routes.first, error == nil else {
                print("Error calculating route: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
 
            self.route = route
            self.distanceInKm = route.distance / 1000.0 // Convert meters to kilometers
            self.shippingCost = self.distanceInKm * 5000 // Calculate cost based on 5000 VND per km
 
            self.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: (nearestShopLocation.latitude + userLocation.latitude) / 2,
                    longitude: (nearestShopLocation.longitude + userLocation.longitude) / 2
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: abs(nearestShopLocation.latitude - userLocation.latitude) * 1.5,
                    longitudeDelta: abs(nearestShopLocation.longitude - userLocation.longitude) * 1.5
                )
            )
        }
    }
 
    private func routeOverlay() -> some View {
        GeometryReader { geometry in
            if let route = route {
                MapOverlay(polyline: route.polyline, geometry: geometry)
            } else {
                EmptyView()
            }
        }
    }
}
 
struct MapOverlay: UIViewRepresentable {
    let polyline: MKPolyline
    let geometry: GeometryProxy
 
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.addOverlay(polyline)
        mapView.delegate = context.coordinator
        return mapView
    }
 
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // No updates needed for now
    }
 
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
 
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}
 
struct LocationAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
 
struct RouteMapView_Previews: PreviewProvider {
    static var previews: some View {
        RouteMapView()
    }
}

