//
//  CustomTabView.swift
//  CustomTabBar
//
//  Created by Dingze Yu on 4/8/25.
//

import SwiftUI

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
