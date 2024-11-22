import SwiftUI

struct TideGraphView: View {
    let tideData: [TideData]
    
    var body: some View {
        GeometryReader { geometry in
            let points = calculatePoints(in: geometry)
            
            ZStack {
                // Draw grid lines
                GridLines(points: points)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                
                // Draw the tide curve
                TideCurve(points: points)
                    .stroke(Color.blue, lineWidth: 2)
                
                // Current tide indicator
                if let currentPoint = getCurrentPoint(in: geometry) {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 10, height: 10)
                        .position(currentPoint)
                }
                
                // Time labels
                TimeLabels(points: points, data: tideData)
            }
        }
        .padding()
    }
    
    private func calculatePoints(in geometry: GeometryProxy) -> [CGPoint] {
        guard !tideData.isEmpty else { return [] }
        
        let heights = tideData.map(\.height)
        let minHeight = heights.min() ?? 0
        let maxHeight = heights.max() ?? 1
        let heightRange = maxHeight - minHeight
        
        let timeRange = tideData.last?.time.timeIntervalSince(tideData[0].time) ?? 1
        
        return tideData.map { data in
            let x = geometry.size.width * CGFloat(data.time.timeIntervalSince(tideData[0].time) / timeRange)
            let y = geometry.size.height * (1 - CGFloat((data.height - minHeight) / heightRange))
            return CGPoint(x: x, y: y)
        }
    }
    
    private func getCurrentPoint(in geometry: GeometryProxy) -> CGPoint? {
        guard let currentHeight = getCurrentTideHeight(),
              !tideData.isEmpty else { return nil }
        
        let heights = tideData.map(\.height)
        let minHeight = heights.min() ?? 0
        let maxHeight = heights.max() ?? 1
        let heightRange = maxHeight - minHeight
        
        let now = Date()
        let timeRange = tideData.last?.time.timeIntervalSince(tideData[0].time) ?? 1
        let x = geometry.size.width * CGFloat(now.timeIntervalSince(tideData[0].time) / timeRange)
        let y = geometry.size.height * (1 - CGFloat((currentHeight - minHeight) / heightRange))
        
        return CGPoint(x: x, y: y)
    }
    
    private func getCurrentTideHeight() -> Double? {
        let now = Date()
        guard let beforeIndex = tideData.firstIndex(where: { $0.time > now }),
              beforeIndex > 0 else { return nil }
        
        let before = tideData[beforeIndex - 1]
        let after = tideData[beforeIndex]
        
        let timeDiff = after.time.timeIntervalSince(before.time)
        let currentDiff = now.timeIntervalSince(before.time)
        let progress = currentDiff / timeDiff
        
        return before.height + (after.height - before.height) * progress
    }
}

struct TideCurve: Shape {
    let points: [CGPoint]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard points.count > 1 else { return path }
        
        path.move(to: points[0])
        
        for i in 1..<points.count {
            let point = points[i]
            let previous = points[i - 1]
            
            let control1 = CGPoint(
                x: previous.x + (point.x - previous.x) / 3,
                y: previous.y
            )
            
            let control2 = CGPoint(
                x: previous.x + 2 * (point.x - previous.x) / 3,
                y: point.y
            )
            
            path.addCurve(to: point, control1: control1, control2: control2)
        }
        
        return path
    }
}

// Grid lines component
struct GridLines: Shape {
    let points: [CGPoint]
    let horizontalLines = 4
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Horizontal lines
        let spacing = rect.height / CGFloat(horizontalLines + 1)
        for i in 1...horizontalLines {
            let y = spacing * CGFloat(i)
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
        }
        
        // Vertical lines at high/low points
        for point in points {
            path.move(to: CGPoint(x: point.x, y: 0))
            path.addLine(to: CGPoint(x: point.x, y: rect.height))
        }
        
        return path
    }
}

// Time labels component
struct TimeLabels: View {
    let points: [CGPoint]
    let data: [TideData]
    
    var body: some View {
        ZStack {
            ForEach(Array(zip(points, data).enumerated()), id: \.offset) { index, item in
                let (point, tideData) = item
                VStack {
                    Text(formatTime(tideData.time))
                        .font(.caption)
                    Text(String(format: "%.1fm", tideData.height))
                        .font(.caption)
                    Text(tideData.type.rawValue)
                        .font(.caption)
                        .foregroundColor(tideData.type == .high ? .blue : .red)
                }
                .position(x: point.x, y: point.y - 40)
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

// Helper extension for date formatting
extension DateFormatter {
    static let timeOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
} 