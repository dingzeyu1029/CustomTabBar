# CustomTabBar

A beautiful, flexible, and highly customizable tab bar for SwiftUI applications.

![CustomTabBar Demo](screenshot.png)

## Features

- 🎨 **Fully customizable** - Colors, shapes, animations, and more
- 🔄 **Smooth animations** - Beautiful transitions when switching tabs
- 🧩 **Simple integration** - Works seamlessly with existing SwiftUI views
- 📱 **iOS compatible** - Works with iOS devices

## Installation

### Swift Package Manager

1. Go to File > Add Package Dependencies...
2. Paste the repository URL: `https://github.com/dingzeyu1029/CustomTabBar.git`
3. Click Add Package

## Usage

### Basic Usage

```swift
import SwiftUI
import CustomTabBar

struct ContentView: View {
    var body: some View {
        CustomTabView {
            TabItem("Home", systemImage: "house.fill") {
                Text("Home Screen")
            }
            
            TabItem("Search", systemImage: "magnifyingglass") {
                Text("Search Screen")
            }
            
            TabItem("Profile", systemImage: "person.fill") {
                Text("Profile Screen")
            }
        }
    }
}
```

### Customization

Customize the appearance of your tab bar with built-in modifiers:

```swift
CustomTabView {
    // Tab items...
}
.tabSelectionBackgroundColor(.blue)
.tabSelectedIconColor(.white)
.tabUnselectedIconColor(.gray.opacity(0.7))
.tabStrokeColor(.blue.opacity(0.3))
.tabBarRoundedRectangle(cornerRadius: 20)
.tabSelectionAnimation(.spring(response: 0.3, dampingFraction: 0.7))
```

### Change Tab Bar Shape

Choose between capsule or rounded rectangle shapes:

```swift
// Capsule shape (default)
.tabBarCapsule()

// Rounded rectangle with custom corner radius
.tabBarRoundedRectangle(cornerRadius: 15)
```

### Hide/Show Tab Bar

You can programmatically hide or show the tab bar:

```swift
@State private var isTabBarVisible = true

var body: some View {
    CustomTabView {
        // Tab items...
    }
    .tabBarVisibility(isTabBarVisible ? .visible : .hidden)
    
    // OR use these convenience methods
    // .hideTabBar()
    // .showTabBar()
}
```

## Advanced Usage

### Complete Custom Style

Create a completely custom tab bar style:

```swift
let customStyle = CustomTabBarStyle(
    selectedIconColor: .white,
    unselectedIconColor: .gray.opacity(0.6),
    selectionBackgroundColor: .purple,
    strokeColor: .purple.opacity(0.2),
    shape: .roundedRectangle(cornerRadius: 15),
    selectionAnimation: .spring(response: 0.3, dampingFraction: 0.7)
)

CustomTabView {
    // Tab items...
}
.tabBarStyle(customStyle)
```

## Requirements

- iOS 17.0+
- Swift 6.0+
- Xcode 15.0+

## License

This project is available under the MIT license. See the LICENSE file for more info.

## Acknowledgements

- Created by Dingze Yu
- Special thanks to everyone who provided feedback and testing

## Support

If you find any bugs or have a feature request, please open an issue on GitHub.
