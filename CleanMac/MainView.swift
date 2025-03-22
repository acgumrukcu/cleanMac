//
//  ContentView.swift
//  CleanMac
//
//  Created by Ahmet Can Gümrükçü on 21.03.2025.
//
import SwiftUI

struct MainView: View {
    @State private var selectedTab: SidebarItem = .allApps
    @State private var searchText = ""
    
    enum SidebarItem: String, CaseIterable {
        case allApps = "All Apps"
        case updates = "Updates"
        case categories = "Categories"
        case tools = "Tools"
        
        var icon: String {
            switch self {
            case .allApps: return "square.grid.2x2"
            case .updates: return "arrow.clockwise"
            case .categories: return "folder"
            case .tools: return "wrench.and.screwdriver"
            }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            // Sidebar
            List {
                Section {
                    ForEach(SidebarItem.allCases, id: \.self) { item in
                        Label(item.rawValue, systemImage: item.icon)
                            .foregroundColor(.white)
                    }
                }
                
                Section("Categories") {
                    Label("System Cleanup", systemImage: "cpu")
                    Label("Storage", systemImage: "externaldrive")
                    Label("Performance", systemImage: "gauge")
                    Label("Security", systemImage: "lock.shield")
                }
            }
            .navigationTitle("CleanMac")
            .listStyle(.sidebar)
            .background(Color(NSColor.darkGray))
        } detail: {
            VStack(spacing: 0) {
                // Top Bar
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search", text: $searchText)
                            .textFieldStyle(.plain)
                    }
                    .padding(8)
                    .background(Color(.windowBackgroundColor).opacity(0.3))
                    .cornerRadius(8)
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Image(systemName: "bell")
                        Image(systemName: "cloud")
                        Circle()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.windowBackgroundColor).opacity(0.2))
                
                // Main Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Featured Card
                        FeaturedCard()
                        
                        // Installed Apps Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Quick Actions")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 16) {
                                ActionCard(
                                    title: "System Cleanup",
                                    description: "Clean system cache and temporary files",
                                    icon: "trash",
                                    gradient: [Color.blue, Color.purple]
                                )
                                
                                ActionCard(
                                    title: "Safari Cleanup",
                                    description: "Clean browser cache and history",
                                    icon: "safari",
                                    gradient: [Color.pink, Color.orange]
                                )
                            }
                        }
                        
                        // System Status Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("System Status")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            SystemInfoView()
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.windowBackgroundColor).opacity(0.3))
                                )
                        }
                    }
                    .padding()
                }
            }
            .background(Color(.windowBackgroundColor))
        }
        .navigationSplitViewStyle(.balanced)
        .preferredColorScheme(.dark)
    }
}

struct FeaturedCard: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("System Optimization")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                
                Text("Boost your Mac's performance with one click")
                    .foregroundColor(.white.opacity(0.8))
                
                Button(action: {}) {
                    Text("Start now")
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.top, 8)
            }
            
            Spacer()
            
            Image(systemName: "bolt.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
                .padding()
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.pink, Color.purple]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(16)
    }
}

struct ActionCard: View {
    let title: String
    let description: String
    let icon: String
    let gradient: [Color]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.white)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
            
            Button(action: {}) {
                Text("Open")
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding()
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: gradient),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
    }
}

// Preview provider for SwiftUI canvas
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
