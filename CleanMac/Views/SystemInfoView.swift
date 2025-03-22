//
//  SystemInfoView.swift
//  CleanMac
//
//  Created by Ahmet Can Gümrükçü on 21.03.2025.
//

import SwiftUI
import Darwin // Sistem istatistikleri için

struct SystemInfoView: View {
    @State private var cpuUsage: Double = 0.0
    @State private var memoryUsed: Double = 0.0
    @State private var memoryTotal: Double = 0.0
    
    private let cpuCores = ProcessInfo.processInfo.processorCount
    private let physicalMemory = Double(ProcessInfo.processInfo.physicalMemory) / 1_073_741_824 // byte -> GB

    var body: some View {
        VStack(spacing: 10) {
            Text("System Info")
                .font(.headline)
            HStack {
                Text("CPU Cores:")
                Spacer()
                Text("\(cpuCores)")
            }
            HStack {
                Text("CPU Usage:")
                Spacer()
                Text(String(format: "%.1f%%", cpuUsage))
            }
            HStack {
               Text("Total RAM:")
               Spacer()
               Text(String(format: "%.1f GB", physicalMemory))
           }

            HStack {
                Text("Memory Usage:")
                Spacer()
                Text(String(format: "%.1f / %.1f GB", memoryUsed, memoryTotal))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .onAppear {
            updateSystemStats()
        }
    }

    func updateSystemStats() {
        cpuUsage = getCPUUsage()
        let memory = getMemoryUsage()
        memoryUsed = memory.used
        memoryTotal = memory.total
    }
    
    func getCPUUsage() -> Double {
        var kr: kern_return_t
        var count: mach_msg_type_number_t = UInt32(MemoryLayout<host_cpu_load_info_data_t>.size / MemoryLayout<integer_t>.size)
        var cpuInfo = host_cpu_load_info()

        kr = withUnsafeMutablePointer(to: &cpuInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &count)
            }
        }

        if kr != KERN_SUCCESS {
            return -1
        }

        let user = Double(cpuInfo.cpu_ticks.0)
        let system = Double(cpuInfo.cpu_ticks.1)
        let idle = Double(cpuInfo.cpu_ticks.2)
        let nice = Double(cpuInfo.cpu_ticks.3)

        let totalTicks = user + system + idle + nice
        return ((user + system + nice) / totalTicks) * 100.0
    }

    func getMemoryUsage() -> (used: Double, total: Double) {
        var stats = vm_statistics64()
        var count = mach_msg_type_number_t(UInt32(MemoryLayout<vm_statistics64_data_t>.size) / UInt32(MemoryLayout<integer_t>.size))

        let result = withUnsafeMutablePointer(to: &stats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
            }
        }

        guard result == KERN_SUCCESS else { return (0, 0) }

        let pageSize = Double(vm_kernel_page_size)
        let used = pageSize * Double(stats.active_count + stats.inactive_count + stats.wire_count) / 1_073_741_824 // GB
        let total = pageSize * Double(stats.active_count + stats.inactive_count + stats.wire_count + stats.free_count) / 1_073_741_824 // GB

        return (used, total)
    }
}
