import Foundation

struct TideData: Codable, Identifiable {
    let id: UUID
    let height: Double
    let time: Date
    let type: TideType
    
    enum TideType: String, Codable {
        case high = "high"
        case low = "low"
    }
    
    init(id: UUID = UUID(), height: Double, time: Date, type: TideType) {
        self.id = id
        self.height = height
        self.time = time
        self.type = type
    }
}

struct Location: Codable, Identifiable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
    
    init(id: UUID = UUID(), name: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
} 