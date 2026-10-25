import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct CreateVMView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name = ""
    @State private var operatingSystem: VMOperatingSystem = .linux
    @State private var architecture: VMArchitecture = .arm64
    @State private var memoryGB = 2
    @State private var diskGB = 16
    @State private var selectedISOURL: URL?
    @State private var selectedISOName = ""
    @State private var showingImporter = false
    @State private var errorMessage: String?

    private let memoryOptions = [1, 2, 4, 6, 8]
    private let diskOptions = [8, 16, 32, 64, 128, 256]

    var body: some View {
        NavigationStack {
            Form {
                Section("General") {
                    TextField("Machine name", text: $name)
                        .textInputAutocapitalization(.words)

                    Picker("Operating System", selection: $operatingSystem) {
                        ForEach(VMOperatingSystem.allCases) { os in
                            Label(os.rawValue, systemImage: os.symbol).tag(os)
                        }
                    }

                    Picker("Architecture", selection: $architecture) {
                        ForEach(VMArchitecture.allCases) { item in
                            Text(item.rawValue).tag(item)
                        }
                    }
                }

                Section("Resources") {
                    Picker("Memory", selection: $memoryGB) {
                        ForEach(memoryOptions, id: \.self) { amount in
                            Text("\(amount) GB").tag(amount)
                        }
                    }
                    Picker("Disk Size", selection: $diskGB) {
                        ForEach(diskOptions, id: \.self) { amount in
                            Text("\(amount) GB").tag(amount)
                        }
                    }
                    Text("These values save a configuration only. They do not reserve physical memory or create a virtual disk yet.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("Boot Image") {
                    Button {
                        showingImporter = true
                    } label: {
                        Label(selectedISOName.isEmpty ? "Choose ISO File" : selectedISOName,
                              systemImage: "doc.badge.plus")
                    }

                    if !selectedISOName.isEmpty {
                        Text("The ISO will be copied into CloverVM's app storage when you save.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("Optional for this prototype. You can add an ISO later.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("New Machine")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveMachine() }
                        .fontWeight(.semibold)
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .fileImporter(
                isPresented: $showingImporter,
                allowedContentTypes: [.data],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    selectedISOURL = urls.first
                    selectedISOName = urls.first?.lastPathComponent ?? ""
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
            .alert("Could Not Save ISO", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "An unknown error occurred.")
            }
        }
        .tint(CloverTheme.accent)
    }

    private func saveMachine() {
        var relativeISOPath = ""
        var isoName = ""

        if let sourceURL = selectedISOURL {
            let didAccess = sourceURL.startAccessingSecurityScopedResource()
            defer {
                if didAccess { sourceURL.stopAccessingSecurityScopedResource() }
            }

            do {
                let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let isoDirectory = documents.appendingPathComponent("ISOs", isDirectory: true)
                try FileManager.default.createDirectory(at: isoDirectory, withIntermediateDirectories: true)

                let destination = isoDirectory.appendingPathComponent(sourceURL.lastPathComponent)
                if FileManager.default.fileExists(atPath: destination.path) {
                    try FileManager.default.removeItem(at: destination)
                }
                try FileManager.default.copyItem(at: sourceURL, to: destination)
                relativeISOPath = "ISOs/\(sourceURL.lastPathComponent)"
                isoName = sourceURL.lastPathComponent
            } catch {
                errorMessage = error.localizedDescription
                return
            }
        }

        let machine = VirtualMachine(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            operatingSystem: operatingSystem,
            architecture: architecture,
            memoryGB: memoryGB,
            diskGB: diskGB,
            isoFileName: isoName,
            isoRelativePath: relativeISOPath
        )
        modelContext.insert(machine)

        do {
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
