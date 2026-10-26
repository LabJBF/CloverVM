
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \VirtualMachine.createdAt, order: .reverse)
    private var machines: [VirtualMachine]

    @State private var showingCreateVM = false
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "square.grid.2x2.fill", value: 0) {
                NavigationStack {
                    dashboard
                        .navigationTitle("CloverVM")
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    showingCreateVM = true
                                } label: {
                                    Image(systemName: "plus")
                                        .fontWeight(.semibold)
                                }
                                .tint(CloverTheme.accent)
                                .accessibilityLabel("Create virtual machine")
                            }
                        }
                }
            }

            Tab("Machines", systemImage: "desktopcomputer", value: 1) {
                NavigationStack {
                    MachineListView()
                        .navigationTitle("Virtual Machines")
                }
            }

            Tab("Settings", systemImage: "gearshape.fill", value: 2) {
                NavigationStack {
                    SettingsView()
                        .navigationTitle("Settings")
                }
            }
        }
        .tint(CloverTheme.accent)
        .toolbarBackground(.visible, for: .tabBar)
        .sheet(isPresented: $showingCreateVM) {
            CreateVMView()
        }
    }

    private var dashboard: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                heroCard

                HStack(spacing: 12) {
                    StatCard(
                        title: "Machines",
                        value: "\(machines.count)",
                        symbol: "desktopcomputer"
                    )

                    StatCard(
                        title: "Storage",
                        value: "\(machines.reduce(0) { $0 + $1.diskGB }) GB",
                        symbol: "internaldrive"
                    )
                }

                HStack {
                    Text("Your Machines")
                        .font(.title3.bold())

                    Spacer()

                    Button {
                        selectedTab = 1
                    } label: {
                        HStack(spacing: 5) {
                            Text("See All")
                            Image(systemName: "arrow.right")
                        }
                        .font(.subheadline.weight(.semibold))
                    }
                    .buttonStyle(.glass)
                    .tint(CloverTheme.accent)
                }

                if machines.isEmpty {
                    EmptyMachinesCard {
                        showingCreateVM = true
                    }
                } else {
                    ForEach(machines.prefix(3)) { machine in
                        NavigationLink {
                            MachineDetailView(machine: machine)
                        } label: {
                            MachineRow(machine: machine)
                        }
                        .buttonStyle(.plain)
                    }
                }

                Label(
                    "Emulation engine not installed",
                    systemImage: "info.circle.fill"
                )
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.top, 2)
            }
            .padding()
        }
        .background(CloverTheme.background)
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "shippingbox.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(
                        .white.opacity(0.18),
                        in: RoundedRectangle(cornerRadius: 15)
                    )

                Spacer()

                Text("PREVIEW")
                    .font(.caption2.bold())
                    .tracking(1.2)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.white.opacity(0.16), in: Capsule())
            }

            VStack(alignment: .leading, spacing: 5) {
                Text("Your systems.\nOne place.")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .fixedSize(horizontal: false, vertical: true)

                Text("Create and organize virtual machine configurations on your iPad.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.82))
            }

            Button {
                showingCreateVM = true
            } label: {
                Label("Create a Machine", systemImage: "plus")
                    .font(.subheadline.bold())
                    .foregroundStyle(CloverTheme.accent)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 11)
                    .background(.white, in: Capsule())
            }
            .buttonStyle(.plain)
        }
        .foregroundStyle(.white)
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            CloverTheme.gradient,
            in: RoundedRectangle(cornerRadius: 26)
        )
    }
}

private struct StatCard: View {
    let title: String
    let value: String
    let symbol: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: symbol)
                .font(.headline)
                .foregroundStyle(CloverTheme.accent)

            Text(value)
                .font(.title2.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            CloverTheme.card,
            in: RoundedRectangle(cornerRadius: 20)
        )
    }
}

struct EmptyMachinesCard: View {
    let action: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "desktopcomputer")
                .font(.system(size: 34))
                .foregroundStyle(CloverTheme.accent)
                .padding(.bottom, 4)

            Text("Nothing here yet")
                .font(.headline)

            Text("Create your first machine to start building your library.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(action: action) {
                Text("Create Machine")
                    .font(.subheadline.bold())
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(
                        CloverTheme.gradient,
                        in: Capsule()
                    )
                    .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(
            CloverTheme.card,
            in: RoundedRectangle(cornerRadius: 22)
        )
    }
}

struct MachineRow: View {
    let machine: VirtualMachine

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: machine.operatingSystem.symbol)
                .font(.title2)
                .foregroundStyle(CloverTheme.accent)
                .frame(width: 52, height: 52)
                .background(
                    CloverTheme.accent.opacity(0.12),
                    in: RoundedRectangle(cornerRadius: 16)
                )

            VStack(alignment: .leading, spacing: 5) {
                Text(machine.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text("\(machine.operatingSystem.rawValue) · \(machine.architecture.rawValue)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("\(machine.memoryGB) GB RAM · \(machine.diskGB) GB disk")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundStyle(.tertiary)
        }
        .padding(14)
        .background(
            CloverTheme.card,
            in: RoundedRectangle(cornerRadius: 20)
        )
    }
}

struct MachineListView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \VirtualMachine.createdAt, order: .reverse)
    private var machines: [VirtualMachine]

    @State private var showingCreateVM = false

    var body: some View {
        Group {
            if machines.isEmpty {
                ContentUnavailableView {
                    Label("No Machines", systemImage: "desktopcomputer")
                } description: {
                    Text("Your virtual machine configurations will appear here.")
                } actions: {
                    Button("Create Machine") {
                        showingCreateVM = true
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(CloverTheme.accent)
                }
            } else {
                List {
                    ForEach(machines) { machine in
                        NavigationLink {
                            MachineDetailView(machine: machine)
                        } label: {
                            MachineRow(machine: machine)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                        }
                    }
                    .onDelete(perform: deleteMachines)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(CloverTheme.background)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingCreateVM = true
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(.glass)
                .tint(CloverTheme.accent)
                .accessibilityLabel("Create virtual machine")
            }
        }
        .sheet(isPresented: $showingCreateVM) {
            CreateVMView()
        }
    }

    private func deleteMachines(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(machines[index])
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to delete virtual machines: \(error)")
        }
    }
}
