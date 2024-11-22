//
//  ContentView.swift
//  TideTimes
//
//  Created by Vinicius Oliveira on 22/11/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var tideService = TideService()
    @State private var searchText = ""
    @State private var showingLocationSearch = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView()
                } else if let error = errorMessage {
                    ContentUnavailableView(
                        "Error",
                        systemImage: "exclamationmark.triangle",
                        description: Text(error)
                    )
                } else if let location = locationManager.selectedLocation {
                    TideGraphView(tideData: tideService.tideData)
                        .frame(height: 300)
                        .padding()
                    
                    Text(location.name)
                        .font(.title2)
                } else {
                    ContentUnavailableView(
                        "Select Location",
                        systemImage: "location",
                        description: Text("Choose a location to view tide times")
                    )
                }
            }
            .navigationTitle("Tide Times")
            .toolbar {
                Button {
                    showingLocationSearch = true
                } label: {
                    Image(systemName: "location")
                }
            }
            .sheet(isPresented: $showingLocationSearch) {
                LocationSearchView(searchText: $searchText)
                    .environmentObject(locationManager)
            }
        }
        .task {
            locationManager.loadSavedLocation()
            if let location = locationManager.selectedLocation {
                await loadTideData(for: location)
            }
        }
    }
    
    private func loadTideData(for location: Location) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await tideService.fetchTideData(for: location)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

#Preview {
    ContentView()
}
