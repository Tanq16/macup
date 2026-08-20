// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "macup",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(name: "macup", path: "Sources/macup")
    ]
)
