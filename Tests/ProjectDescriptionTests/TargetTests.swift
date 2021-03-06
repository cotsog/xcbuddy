import Foundation
@testable import ProjectDescription
import XCTest

final class TargetTests: XCTestCase {
    func test_toJSON_returns_the_right_value() {
        let subject = Target(name: "name",
                             platform: .ios,
                             product: .app,
                             infoPlist: "info.plist",
                             entitlements: "entitlements",
                             dependencies: [.framework(path: "path")],
                             settings: Settings(debug: .settings([:], xcconfig: "debug.xcconfig"),
                                                release: .settings([:], xcconfig: "release.xcconfig")),
                             buildPhases: [.headers()])
        let json = subject.toJSON()
        let expected = """
        {"build_phases": [{"private": [], "project": [], "public": [], "type": "headers"}], "dependencies": [{"path": "path", "type": "framework"}], "entitlements": "entitlements", "info_plist": "info.plist", "name": "name", "platform": "ios", "product": "app", "settings": {"base": {}, "debug": {"settings": {}, "xcconfig": "debug.xcconfig"}, "release": {"settings": {}, "xcconfig": "release.xcconfig"}}}
        """
        XCTAssertEqual(json.toString(), expected)
    }
}
