import Foundation
import SwiftData

enum VMOperatingSystem: String, CaseIterable, Codable, Identifiable {
    case linux = "Linux"
    case windows = "Windows"
    case macOS = "macOS"
    case other = "Other"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .linux: return "terminal"
        case .windows: return "pc"
        case .macOS: return "desktopcomputer"
        case .other: return "cpu"
        }
    }
}

enum VMArchitecture: String, CaseIterable, Codable, Identifiable {
    case arm64 = "ARM64"
    case x86_64 = "x86_64"

    var id: String { rawValue }
}

@Model
final class VirtualMachine {
    var id: UUID
    var name: String
    var operatingSystemRaw: String
    var architectureRaw: String
    var memoryGB: Int
    var diskGB: Int
    var isoFileName: String
    var isoRelativePath: String
    var createdAt: Date

    init(
        name: String,
        operatingSystem: VMOperatingSystem,
        architecture: VMArchitecture,
        memoryGB: Int,
        diskGB: Int,
        isoFileName: String = "",
        isoRelativePath: String = ""
    ) {
        self.id = UUID()
        self.name = name
        self.operatingSystemRaw = operatingSystem.rawValue
        self.architectureRaw = architecture.rawValue
        self.memoryGB = memoryGB
        self.diskGB = diskGB
        self.isoFileName = isoFileName
        self.isoRelativePath = isoRelativePath
        self.createdAt = .now
    }

    var operatingSystem: VMOperatingSystem {
        get { VMOperatingSystem(rawValue: operatingSystemRaw) ?? .other }
        set { operatingSystemRaw = newValue.rawValue }
    }

    var architecture: VMArchitecture {
        get { VMArchitecture(rawValue: architectureRaw) ?? .arm64 }
        set { architectureRaw = newValue.rawValue }
    }

    var isoURL: URL? {
        guard !isoRelativePath.isEmpty else { return nil }
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(isoRelativePath)
    }
}
