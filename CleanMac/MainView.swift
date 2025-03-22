//
//  ContentView.swift
//  CleanMac
//
//  Created by Ahmet Can Gümrükçü on 21.03.2025.
//
import SwiftUI

struct MainView: View {
    @State private var selectedTab: SidebarItem = .dashboard
    
    enum SidebarItem: String, CaseIterable {
        case dashboard = "Dashboard"
        case cleanup = "Cleanup"
        case settings = "Settings"
        
        var icon: String {
            switch self {
            case .dashboard: return "gauge"
            case .cleanup: return "trash"
            case .settings: return "gear"
            }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            // Sidebar
            List(SidebarItem.allCases, id: \.self, selection: $selectedTab) { item in
                Label(item.rawValue, systemImage: item.icon)
            }
            .navigationTitle("CleanMac")
            .listStyle(.sidebar)
        } detail: {
            // Main Content
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome to CleanMac")
                            .font(.title)
                            .bold()
                        Text("Optimize your Mac's performance")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // System Info Card
                    VStack(alignment: .leading, spacing: 16) {
                        Label("System Information", systemImage: "info.circle.fill")
                            .font(.headline)
                        
                        SystemInfoView()
                    }
                    .padding()
                    .background(Color(.windowBackgroundColor))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: 16) {
                        Label("Quick Actions", systemImage: "bolt.fill")
                            .font(.headline)
                        
                        HStack(spacing: 16) {
                            CleanButtonView()
                                .frame(maxWidth: .infinity)
                            
                            SafariCleanButtonView()
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .background(Color(.windowBackgroundColor))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                .padding()
            }
            .background(Color(.controlBackgroundColor))
        }
        .navigationSplitViewStyle(.balanced)
    }
}

// Preview provider for SwiftUI canvas
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
