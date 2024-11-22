import SwiftUI

struct LocationSearchView: View {
    @EnvironmentObject var locationManager: LocationManager
    @Binding var searchText: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List(locationManager.searchResults) { location in
                Button {
                    locationManager.selectedLocation = location
                    locationManager.saveSelectedLocation()
                    dismiss()
                } label: {
                    Text(location.name)
                }
            }
            .searchable(text: $searchText)
            .onChange(of: searchText) { _, newValue in
                locationManager.searchLocations(newValue)
            }
            .navigationTitle("Search Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    LocationSearchView(searchText: .constant(""))
        .environmentObject(LocationManager())
} 