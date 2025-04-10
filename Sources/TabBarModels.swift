//
//  TabBarModels.swift
//  CustomTabBar
//
//  Created by Dingze Yu on 4/10/25.
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
