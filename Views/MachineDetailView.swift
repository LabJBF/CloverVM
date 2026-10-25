import SwiftUI
import SwiftData

struct MachineDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showingEngineAlert = false
    @State private var showingDeleteConfirmation = false

    let machine: VirtualMachine
    private let backend = UnavailableVMBackend()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(spacing: 12) {
                    Image(systemName: machine.operatingSystem.symbol)
                        .font(.system(size: 42))
                        .foregroundStyle(.white)
                        .frame(width: 92, height: 92)
                        .background(CloverTheme.gradient, in: RoundedRectangle(cornerRadius: 26))
                    Text(machine.name)
                        .font(.title.bold())
                        .multilineTextAlignment(.center)
                    Text("\(machine.operatingSystem.rawValue) · \(machine.architecture.rawValue)")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)

                Button {
                    showingEngineAlert = true
                } label: {
                    Label("Start Virtual Machine", systemImage: "play.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .tint(CloverTheme.accent)

                VStack(alignment: .leading, spacing: 0) {
                    DetailRow(title: "Memory", value: "\(machine.memoryGB) GB", symbol: "memorychip")
                    Divider().padding(.leading, 44)
                    DetailRow(title: "Virtual Disk", value: "\(machine.diskGB) GB", symbol: "internaldrive")
                    Divider().padding(.leading, 44)
                    DetailRow(title: "Boot Image", value: machine.isoFileName.isEmpty ? "Not selected" : machine.isoFileName, symbol: "opticaldisc")
                    Divider().padding(.leading, 44)
                    DetailRow(title: "Created", value: machine.createdAt.formatted(date: .abbreviated, time: .omitted), symbol: "calendar")
                }
                .padding(.horizontal, 14)
                .background(CloverTheme.card, in: RoundedRectangle(cornerRadius: 20))

                Text("This is a configuration manager preview. The QEMU engine, virtual disk creation, and guest display will be added in a later stage.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 2)

                Button(role: .destructive) {
                    showingDeleteConfirmation = true
                } label: {
                    Label("Delete Configuration", systemImage: "trash")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .padding(.top, 4)
            }
            .padding()
        }
        .background(CloverTheme.background)
        .navigationTitle("Machine Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Engine Not Available", isPresented: $showingEngineAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(VMBackendError.notImplemented.localizedDescription ?? "The engine has not been integrated yet.")
        }
        .confirmationDialog("Delete this machine configuration?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                modelContext.delete(machine)
                try? modelContext.save()
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}

private struct DetailRow: View {
    let title: String
    let value: String
    let symbol: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: symbol)
                .foregroundStyle(CloverTheme.accent)
                .frame(width: 28)
            Text(title)
                .foregroundStyle(.secondary)
            Spacer(minLength: 12)
            Text(value)
                .multilineTextAlignment(.trailing)
                .lineLimit(2)
        }
        .font(.subheadline)
        .padding(.vertical, 14)
    }
}
