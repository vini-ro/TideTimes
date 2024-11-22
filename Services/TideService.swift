import Foundation

class TideService: ObservableObject {
    @Published var tideData: [TideData] = []
    
    func fetchTideData(for location: Location) async throws {
        let calendar = Calendar.current
        let now = Date()
        
        // Get data for 24 hours before and after current time
        guard let startDate = calendar.date(byAdding: .hour, value: -24, to: now),
              let endDate = calendar.date(byAdding: .hour, value: 24, to: now) else {
            throw TideError.invalidDateRange
        }
        
        let urlString = "\(APIConfig.worldTidesBaseURL)/heights" +
            "?lat=\(location.latitude)" +
            "&lon=\(location.longitude)" +
            "&start=\(Int(startDate.timeIntervalSince1970))" +
            "&end=\(Int(endDate.timeIntervalSince1970))" +
            "&apikey=\(APIConfig.worldTidesAPIKey)"
        
        guard let url = URL(string: urlString) else {
            throw TideError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(TideResponse.self, from: data)
        
        await MainActor.run {
            self.tideData = response.heights.map { height in
                TideData(
                    id: UUID(),
                    height: height.height,
                    time: Date(timeIntervalSince1970: TimeInterval(height.dt)),
                    type: height.height > response.heights.map(\.height).reduce(0, +) / Double(response.heights.count) 
                        ? .high 
                        : .low
                )
            }
        }
    }
}

struct TideResponse: Codable {
    let heights: [Height]
    
    struct Height: Codable {
        let dt: Int
        let height: Double
    }
}

enum TideError: Error {
    case invalidURL
    case invalidDateRange
    case apiError(String)
} 