# TideTimes 🌊

A beautiful, intuitive iOS app for viewing real-time tide information and predictions for any coastal location worldwide.

## 📱 Features

- **Real-time Tide Data**: Get accurate tide predictions from WorldTides.info API
- **Interactive Tide Graphs**: Visualize tide patterns with smooth, animated curves
- **Location Search**: Find any coastal location using MapKit integration
- **Current Tide Indicator**: See exactly where you are in the current tide cycle
- **48-Hour Window**: View tide data 24 hours before and after the current time
- **Persistent Location**: Your selected location is automatically saved
- **Elegant UI**: Clean, modern SwiftUI interface optimized for iOS

## 🎯 Screenshots

| Main Interface | Location Search | Tide Graph |
|----------------|-----------------|------------|
| *Coming Soon*  | *Coming Soon*   | *Coming Soon* |

*Screenshots will be added once the app is built and running*

## 📋 Requirements

- **iOS**: 15.0 or later
- **Xcode**: 14.0 or later
- **Swift**: 5.7 or later
- **Internet Connection**: Required for fetching tide data
- **WorldTides.info API Key**: Required for accessing tide data

## 🚀 Installation

### Prerequisites

1. **Xcode**: Download and install Xcode from the Mac App Store
2. **WorldTides.info API Key**: 
   - Sign up at [worldtides.info](https://www.worldtides.info)
   - Subscribe to their API service
   - Get your API key from the dashboard

### Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/vini-ro/TideTimes.git
   cd TideTimes
   ```

2. **Configure API Key**:
   - Open `Services/APIConfig.swift`
   - Replace `"YOUR_API_KEY"` with your actual WorldTides.info API key:
   ```swift
   static let worldTidesAPIKey = "your_actual_api_key_here"
   ```

3. **Open in Xcode**:
   - Double-click the project folder or drag it into Xcode
   - Select your target device/simulator
   - Build and run (⌘+R)

## 🛠️ Configuration

### API Configuration

The app uses the WorldTides.info API for accurate tide predictions. Configuration is managed in `Services/APIConfig.swift`:

```swift
enum APIConfig {
    static let worldTidesAPIKey = "YOUR_API_KEY" // Replace with your key
    static let worldTidesBaseURL = "https://www.worldtides.info/api/v3"
}
```

### Required Permissions

The app requests the following permissions:
- **Location Services**: For location-based search (optional)
- **Network Access**: For fetching tide data (required)

## 📖 Usage

### Getting Started

1. **Launch the app**: Tap the TideTimes icon to open
2. **Select a Location**: 
   - Tap the location button (📍) in the top toolbar
   - Search for any coastal location
   - Select from the search results
3. **View Tide Data**: The main screen displays:
   - Interactive tide graph with height over time
   - Current tide position (red indicator)
   - High and low tide times and heights
   - Location name

### Understanding the Tide Graph

- **Blue Curve**: Shows tide height over time
- **Red Dot**: Current tide position
- **Time Labels**: Show specific high/low tide times
- **Height Values**: Displayed in meters
- **Grid Lines**: Help read approximate values

### Features in Detail

#### Location Search
- Type any coastal city, harbor, or landmark
- Results are powered by Apple's MapKit
- Selected locations are automatically saved

#### Tide Predictions
- Data covers 48 hours (24 hours before/after current time)
- Updates automatically when location changes
- Handles high/low tide classification
- Shows exact times and heights

## 🏗️ Project Structure

```
TideTimes/
├── TideTimesApp.swift          # Main app entry point
├── ContentView.swift           # Primary app interface
├── Models/
│   └── TideData.swift         # Data models (TideData, Location)
├── Services/
│   ├── APIConfig.swift        # API configuration
│   ├── TideService.swift      # Tide data fetching service
│   └── LocationManager.swift  # Location search and management
├── Views/
│   ├── TideGraphView.swift    # Tide visualization component
│   └── LocationSearchView.swift # Location picker interface
├── Extensions/
│   └── UserDefaults+Codable.swift # Persistence helpers
├── Assets.xcassets/           # App icons and images
└── Preview Content/           # SwiftUI preview assets
```

## 🎨 Architecture

### MVVM Pattern
The app follows the Model-View-ViewModel pattern with SwiftUI:

- **Models**: `TideData`, `Location` - Pure data structures
- **Views**: SwiftUI views for UI presentation
- **ViewModels**: `@StateObject` classes (`TideService`, `LocationManager`)

### Key Components

#### TideService
- Fetches tide data from WorldTides.info API
- Processes and formats tide information
- Publishes updates to the UI

#### LocationManager
- Handles location search using MapKit
- Manages selected location persistence
- Provides search completion functionality

#### TideGraphView
- Renders interactive tide curves
- Calculates point positions and curves
- Shows current tide indicator
- Displays time and height labels

### Data Flow
1. User selects location → LocationManager
2. Location change triggers → TideService
3. API call fetches tide data → TideService
4. UI updates automatically → SwiftUI @Published

## 🔧 Development

### Building
```bash
# Option 1: Build in Xcode (Recommended)
# Open the project in Xcode and press ⌘+B

# Option 2: Command line build
xcodebuild -scheme TideTimes build
```

### Running on Device/Simulator
1. Connect your iOS device or open iOS Simulator
2. Select your target device in Xcode
3. Press ⌘+R to build and run

### Testing
- Unit tests can be added for service classes
- UI tests can verify navigation and data display
- Currently no test suite is included (contributions welcome!)

### Code Style
- Follow Swift API Design Guidelines
- Use SwiftUI best practices
- Maintain clear separation of concerns
- Document complex algorithms
- Use meaningful variable and function names
- Keep functions small and focused

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Make your changes**: Follow the existing code style
4. **Test thoroughly**: Ensure your changes work as expected
5. **Commit your changes**: `git commit -m 'Add amazing feature'`
6. **Push to the branch**: `git push origin feature/amazing-feature`
7. **Open a Pull Request**: Describe your changes clearly

### Areas for Contribution
- Additional chart types and visualizations
- Offline data caching
- Widget support
- Apple Watch companion app
- Additional tide data sources
- Accessibility improvements
- Localization

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **WorldTides.info**: For providing accurate tide data API
- **Apple**: For SwiftUI, MapKit, and iOS development tools
- **Swift Community**: For excellent documentation and resources

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/vini-ro/TideTimes/issues) page
2. Create a new issue with detailed description
3. Contact the developer: Vinicius Oliveira

### Common Issues

**"API Error" or "No Data"**
- Verify your WorldTides.info API key is correctly set in `APIConfig.swift`
- Check your internet connection
- Ensure the selected location is coastal (inland locations won't have tide data)

**Location Search Not Working**
- Check location permissions in iOS Settings
- Ensure you have an internet connection
- Try more specific location names (e.g., "Santa Monica, CA" instead of just "Santa Monica")

**App Won't Build**
- Ensure you're using Xcode 14.0 or later
- Check that iOS deployment target is set to 15.0 or later
- Verify all dependencies are properly resolved

## 🔮 Future Plans

- [ ] Apple Watch companion app
- [ ] Tide widgets for home screen
- [ ] Offline data caching
- [ ] Multiple location favorites
- [ ] Tide notifications and alerts
- [ ] Chart customization options
- [ ] Export tide data functionality

---

*Made with ❤️ by Vinicius Oliveira*

*Last updated: November 2024*