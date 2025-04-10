//
//  TabBarEnvironment.swift
//  CustomTabBar
//
//  Created by Dingze Yu on 4/10/25.
//

import SwiftUI

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
