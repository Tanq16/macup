import Foundation
import Observation

@Observable
final class CaffeineController {
    private(set) var isActive = false
    private var process: Process?

    func toggle() {
        isActive ? stop() : start()
    }

    func start() {
        guard process == nil else { return }
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/caffeinate")
        task.arguments = ["-d", "-i", "-m"]
        try? task.run()
        process = task
        isActive = true
    }

    func stop() {
        process?.terminate()
        process = nil
        isActive = false
    }
}
