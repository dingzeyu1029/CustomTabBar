//
//  CustomTabBar.swift
//  CustomTabBar
//
//  Created by Dingze Yu on 4/8/25.
//

import SwiftUI

// MARK: - Public Types

/// Represents a single tab item in the CustomTabView.
public struct TabItem {
    /// The title of the tab item.
    let title: String
    
    /// The SF Symbol name to use as the tab icon.
    let systemImage: String
    
    /// The content view to display when this tab is selected.
    let content: AnyView
    
    /// Creates a new tab item with the specified title, image, and content.
    /// - Parameters:
    ///   - title: The title of the tab.
    ///   - systemImage: The name of the SF Symbol to use as the icon.
    ///   - content: A closure returning the view to display when this tab is selected.
    public init<Content: View>(_ title: String, systemImage: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.systemImage = systemImage
        self.content = AnyView(content())
    }
}

/// The shape style to use for the tab bar and selection indicator.
public enum TabBarShape: Sendable, Equatable {
    /// A capsule shape with rounded ends.
    case capsule
    
    /// A rectangle with customizable corner radius.
    case roundedRectangle(cornerRadius: CGFloat)
}

/// Controls whether the tab bar is visible or hidden.
public enum Visibility: Equatable, Sendable {
    /// The tab bar is visible.
    case visible
    
    /// The tab bar is hidden.
    case hidden
}

/// Customization options for the appearance of the tab bar.
public struct CustomTabBarStyle: Equatable, Sendable {
    /// The color of the icon for the selected tab.
    public var selectedIconColor: Color
    
    /// The color of icons for unselected tabs.
    public var unselectedIconColor: Color
    
    /// The background color of the selected tab indicator.
    public var selectionBackgroundColor: Color
    
    /// The color of the tab bar outline stroke.
    public var strokeColor: Color
    
    /// The shape to use for the tab bar and selected tab indicator.
    public var shape: TabBarShape
    
    /// The animation to use when switching between tabs.
    public var selectionAnimation: Animation
    
    /// Creates a new tab bar style with the specified customization options.
    /// - Parameters:
    ///   - selectedIconColor: The color of the selected tab icon. Default is white.
    ///   - unselectedIconColor: The color of unselected tab icons. Default is gray.
    ///   - selectionBackgroundColor: The background color of the selected tab indicator. Default is the accent color.
    ///   - strokeColor: The color of the tab bar outline. Default is gray with opacity 0.2.
    ///   - shape: The shape of the tab bar and selection indicator. Default is capsule.
    ///   - selectionAnimation: The animation to use when switching tabs. Default is smooth.
    public init(
        selectedIconColor: Color = .white,
        unselectedIconColor: Color = .gray,
        selectionBackgroundColor: Color = .accentColor,
        strokeColor: Color = .gray.opacity(0.2),
        shape: TabBarShape = .capsule,
        selectionAnimation: Animation = .smooth
    ) {
        self.selectedIconColor = selectedIconColor
        self.unselectedIconColor = unselectedIconColor
        self.selectionBackgroundColor = selectionBackgroundColor
        self.strokeColor = strokeColor
        self.shape = shape
        self.selectionAnimation = selectionAnimation
    }
}

// MARK: - CustomTabView

/// A customizable tab view that provides a tab-based navigation interface.
///
/// `CustomTabView` allows you to create a tab bar with a fully customizable appearance.
/// You can customize colors, shapes, animations, and visibility of the tab bar.
///
/// Example:
/// ```
/// CustomTabView {
///     TabItem("Home", systemImage: "house.fill") {
///         Text("Home Screen")
///     }
///
///     TabItem("Profile", systemImage: "person.fill") {
///         Text("Profile Screen")
///     }
/// }
/// .tabSelectionBackgroundColor(.blue)
/// .tabBarRoundedRectangle(cornerRadius: 20)
/// ```
public struct CustomTabView: View {
    /// The currently selected tab index.
    @State private var selectedTab = 0
    
    /// Namespace for the tab selection animation.
    @Namespace private var animation
    
    /// The tab items to display in the tab bar.
    private var tabItems: [TabItem]
    
    /// The style configuration for the tab bar.
    @Environment(\.customTabBarStyle) private var style
    
    /// Whether the tab bar is visible or hidden.
    @Environment(\.tabBarVisibility) private var visibility
    
    /// Creates a new custom tab view with the specified tab items.
    /// - Parameter builder: A result builder that creates the tab items.
    public init(@CustomTabViewBuilder builder: () -> [TabItem]) {
        self.tabItems = builder()
    }
    
    /// The body of the view.
    public var body: some View {
        VStack(spacing: 0) {
            // Display the selected tab's content
            if !tabItems.isEmpty && selectedTab < tabItems.count {
                tabItems[selectedTab].content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // Show tab bar if not hidden
            if visibility == .visible {
                ZStack(alignment: .bottom){
                    customTabBar()
                }
            }
        }
    }
    
    /// Creates the custom tab bar.
    @ViewBuilder
    private func customTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(Array(tabItems.enumerated()), id: \.offset) { index, item in
                tabButton(title: item.title, icon: item.systemImage, index: index)
            }
        }
        .frame(height: 40)
        .padding(6)
        .background(
            Group {
                switch style.shape {
                case .capsule:
                    Capsule()
                        .stroke(style.strokeColor, lineWidth: 1)
                case .roundedRectangle(let cornerRadius):
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(style.strokeColor, lineWidth: 1)
                }
            }
        )
        .padding(.horizontal)
        .padding(.bottom, 10)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Tab Navigation")
    }
    
    /// Creates a single tab button.
    @ViewBuilder
    private func tabButton(title: String, icon: String, index: Int) -> some View {
        Button(action: {
            withAnimation(style.selectionAnimation) {
                selectedTab = index
            }
        }) {
            Image(systemName: icon)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(selectedTab == index ? style.selectedIconColor : style.unselectedIconColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(
            ZStack{
                if selectedTab == index {
                    Group {
                        switch style.shape {
                        case .capsule:
                            Capsule()
                                .fill(style.selectionBackgroundColor)
                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                        case .roundedRectangle(let cornerRadius):
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(style.selectionBackgroundColor)
                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                        }
                    }
                }
            }
        )
        // Accessibility
        .accessibilityLabel(title)
        .accessibilityHint("Tab \(index + 1) of \(tabItems.count)")
        .accessibilityAddTraits(selectedTab == index ? .isSelected : [])
        .accessibilityIdentifier("tab.\(title.lowercased())")
    }
}

// MARK: - Builder Pattern

/// A result builder for creating tab items.
@resultBuilder
public struct CustomTabViewBuilder {
    /// Builds a block of tab items.
    public static func buildBlock(_ components: TabItem...) -> [TabItem] {
        return components
    }
    
    /// Builds an optional block of tab items.
    public static func buildOptional(_ component: [TabItem]?) -> [TabItem] {
        return component ?? []
    }
    
    /// Builds an either-or block of tab items (first case).
    public static func buildEither(first component: [TabItem]) -> [TabItem] {
        return component
    }
    
    /// Builds an either-or block of tab items (second case).
    public static func buildEither(second component: [TabItem]) -> [TabItem] {
        return component
    }
    
    /// Builds an array of tab items.
    public static func buildArray(_ components: [[TabItem]]) -> [TabItem] {
        return components.flatMap { $0 }
    }
}

// MARK: - Style System

/// A view modifier that updates the tab bar style.
public struct CustomTabBarStyleModifier: ViewModifier {
    /// The update function that modifies the style.
    let update: (inout CustomTabBarStyle) -> Void
    
    /// The body of the modifier.
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.customTabBarStyle) { style in
            update(&style)
        }
    }
}

// MARK: - Environment Keys

/// Environment key for the custom tab bar style.
private struct CustomTabBarStyleKey: EnvironmentKey {
    /// The default tab bar style.
    static let defaultValue = CustomTabBarStyle()
}

/// Environment key for tab bar visibility.
private struct TabBarVisibilityKey: EnvironmentKey {
    /// The default visibility (visible).
    static let defaultValue: Visibility = .visible
}

// MARK: - Environment Values Extension

extension EnvironmentValues {
    /// The style of the custom tab bar.
    var customTabBarStyle: CustomTabBarStyle {
        get { self[CustomTabBarStyleKey.self] }
        set { self[CustomTabBarStyleKey.self] = newValue }
    }
    
    /// The visibility of the tab bar.
    var tabBarVisibility: Visibility {
        get { self[TabBarVisibilityKey.self] }
        set { self[TabBarVisibilityKey.self] = newValue }
    }
}

// MARK: - View Extensions

extension View {
    /// Sets the complete style of the tab bar.
    /// - Parameter style: The style to apply to the tab bar.
    /// - Returns: A view with the specified tab bar style.
    public func tabBarStyle(_ style: CustomTabBarStyle) -> some View {
        modifier(CustomTabBarStyleModifier { $0 = style })
    }
    
    /// Sets the color of the selected tab icon.
    /// - Parameter color: The color to use for the selected tab icon.
    /// - Returns: A view with the specified selected tab icon color.
    public func tabSelectedIconColor(_ color: Color) -> some View {
        modifier(CustomTabBarStyleModifier { $0.selectedIconColor = color })
    }
    
    /// Sets the color of unselected tab icons.
    /// - Parameter color: The color to use for unselected tab icons.
    /// - Returns: A view with the specified unselected tab icon color.
    public func tabUnselectedIconColor(_ color: Color) -> some View {
        modifier(CustomTabBarStyleModifier { $0.unselectedIconColor = color })
    }
    
    /// Sets the background color of the selected tab indicator.
    /// - Parameter color: The color to use for the selected tab background.
    /// - Returns: A view with the specified selection background color.
    public func tabSelectionBackgroundColor(_ color: Color) -> some View {
        modifier(CustomTabBarStyleModifier { $0.selectionBackgroundColor = color })
    }
    
    /// Sets the color of the tab bar outline stroke.
    /// - Parameter color: The color to use for the tab bar outline.
    /// - Returns: A view with the specified tab bar stroke color.
    public func tabStrokeColor(_ color: Color) -> some View {
        modifier(CustomTabBarStyleModifier { $0.strokeColor = color })
    }
    
    /// Sets the shape of the tab bar and selection indicator.
    /// - Parameter shape: The shape to use for the tab bar.
    /// - Returns: A view with the specified tab bar shape.
    public func tabBarShape(_ shape: TabBarShape) -> some View {
        modifier(CustomTabBarStyleModifier { $0.shape = shape })
    }
    
    /// Sets the tab bar shape to a rounded rectangle with the specified corner radius.
    /// - Parameter cornerRadius: The corner radius to use for the rectangle. Default is 12.
    /// - Returns: A view with a rounded rectangle tab bar.
    public func tabBarRoundedRectangle(cornerRadius: CGFloat = 12) -> some View {
        tabBarShape(.roundedRectangle(cornerRadius: cornerRadius))
    }
    
    /// Sets the tab bar shape to a capsule.
    /// - Returns: A view with a capsule-shaped tab bar.
    public func tabBarCapsule() -> some View {
        tabBarShape(.capsule)
    }
    
    /// Sets the animation to use when switching between tabs.
    /// - Parameter animation: The animation to use for tab transitions.
    /// - Returns: A view with the specified tab selection animation.
    public func tabSelectionAnimation(_ animation: Animation) -> some View {
        modifier(CustomTabBarStyleModifier { $0.selectionAnimation = animation })
    }
    
    /// Sets the visibility of the tab bar.
    /// - Parameter visibility: Whether the tab bar should be visible or hidden.
    /// - Returns: A view with the specified tab bar visibility.
    public func tabBarVisibility(_ visibility: Visibility) -> some View {
        environment(\.tabBarVisibility, visibility)
    }
    
    /// Hides the tab bar.
    /// - Returns: A view with the tab bar hidden.
    public func hideTabBar() -> some View {
        tabBarVisibility(.hidden)
    }
    
    /// Shows the tab bar.
    /// - Returns: A view with the tab bar visible.
    public func showTabBar() -> some View {
        tabBarVisibility(.visible)
    }
}
