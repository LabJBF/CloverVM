import SwiftUI
import SwiftData

@main
struct CloverVMApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: VirtualMachine.self)
    }
}
