//
//  MapView.swift
//  HAHACOFFEE
//
//  Created by Đinh Trung Quốc Anh on 30/12/24.
//

import Foundation
import SwiftUI
import MapKit
import Firebase

struct LocationAnnotation_1: Identifiable, Equatable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D

    static func == (lhs: LocationAnnotation_1, rhs: LocationAnnotation_1) -> Bool {
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 10.8231, longitude: 106.6297), // Ho Chi Minh City
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    @State private var searchQuery = ""
    @State private var searchResults: [MKLocalSearchCompletion] = []
    @State private var selectedLocation: LocationAnnotation_1? = nil
    @State private var showSuggestions = false

    @StateObject private var searchCompleter = LocalSearchCompleter()

    var orderDetails: [String: Any] // Pass the order details here

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: selectedLocation != nil ? [selectedLocation!] : []) { location in
                MapPin(coordinate: location.coordinate)
            }
            .ignoresSafeArea()

            VStack {
                HStack {
                    TextField("Search for a location", text: $searchQuery)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: searchQuery) { newValue in
                            showSuggestions = !newValue.isEmpty
                            searchCompleter.queryFragment = newValue
                        }
                        .padding(.horizontal)

                    Button("Clear") {
                        searchQuery = ""
                        searchResults = []
                        showSuggestions = false
                    }
                }
                .padding(.top, 1)
                

                if showSuggestions {
                    List(searchCompleter.completions, id: \..self) { result in
                        Button(action: {
                            selectSearchResult(result)
                            showSuggestions = false
                        }) {
                            VStack(alignment: .leading) {
                                Text(result.title)
                                    .font(.headline)
                                Text(result.subtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .frame(maxHeight: 300)
                }

                Spacer()

                if let selectedLocation = selectedLocation {
                    VStack {
                        Text("Latitude: \(selectedLocation.coordinate.latitude)")
                        Text("Longitude: \(selectedLocation.coordinate.longitude)")
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
            }
        }
        .onChange(of: selectedLocation) { newLocation in
            if let location = newLocation {
                region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02) // Zoom in on selected location
                )
                uploadOrderDetailsWithLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
        }
        .navigationBarHidden(true)
    }

    private func selectSearchResult(_ result: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = result.title

        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate, error == nil else {
                print("Error fetching location: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            selectedLocation = LocationAnnotation_1(coordinate: coordinate)
            region.center = coordinate
        }
    }

    private func uploadOrderDetailsWithLocation(latitude: Double, longitude: Double) {
        var updatedOrderDetails = orderDetails
        updatedOrderDetails["latitude"] = latitude
        updatedOrderDetails["longitude"] = longitude
        updatedOrderDetails["timestamp"] = Timestamp()

        let db = Firestore.firestore()

        db.collection("LatLon").addDocument(data: updatedOrderDetails) { error in
            if let error = error {
                print("Error uploading order details: \(error.localizedDescription)")
            } else {
                print("Order details uploaded successfully.")
            }
        }
    }
}

final class LocalSearchCompleter: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var completions: [MKLocalSearchCompletion] = []

    private let searchCompleter = MKLocalSearchCompleter()

    override init() {
        super.init()
        searchCompleter.delegate = self
    }

    var queryFragment: String {
        get { searchCompleter.queryFragment }
        set { searchCompleter.queryFragment = newValue }
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.completions = completer.results
        }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search completer error: \(error.localizedDescription)")
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(orderDetails: ["orderId": "12345", "customerName": "Nguyen Thanh Hau"])
    }
}
