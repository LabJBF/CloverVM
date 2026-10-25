import SwiftUI

struct SettingsView: View {
    @AppStorage("showExperimentalFeatures") private var showExperimentalFeatures = false

    var body: some View {
        Form {
            Section("Application") {
                LabeledContent("Version", value: "0.1.0 Preview")
                LabeledContent("Developer", value: "Mac.Clover")
                LabeledContent("Engine", value: "Not integrated")
            }

            Section("Preferences") {
                Toggle("Experimental Features", isOn: $showExperimentalFeatures)
                Text("Experimental options will become available as the emulation engine is integrated.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("About CloverVM") {
                Label("Built for iPhone and iPad", systemImage: "ipad.and.iphone")
                Label("QEMU integration planned", systemImage: "cpu")
                Link(destination: URL(string: "https://github.com/LabJBF/CloverVM")!) {
                    Label("GitHub Repository", systemImage: "chevron.left.forwardslash.chevron.right")
                }
            }

            Section {
                Text("CloverVM is an independent project by Mac.Clover. This preview manages configurations only and does not yet emulate or boot operating systems.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .tint(CloverTheme.accent)
    }
}
