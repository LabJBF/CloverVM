import Foundation

enum VMBackendError: LocalizedError {
    case notImplemented

    var errorDescription: String? {
        switch self {
        case .notImplemented:
            return "The emulation engine has not been integrated yet. This build can manage VM configurations, but it cannot boot guest operating systems."
        }
    }
}

/// Future integration point for QEMU or another compatible emulation backend.
protocol VirtualMachineBackend {
    func start(_ machine: VirtualMachine) async throws
    func stop(_ machine: VirtualMachine) async throws
}

struct UnavailableVMBackend: VirtualMachineBackend {
    func start(_ machine: VirtualMachine) async throws {
        throw VMBackendError.notImplemented
    }

    func stop(_ machine: VirtualMachine) async throws {
        throw VMBackendError.notImplemented
    }
}
