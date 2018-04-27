import Basic
import Foundation
import Utility

/// Shell error.
struct ShellError: Error, CustomStringConvertible, Equatable {
    let description: String
}

/// Protocol that represents a shell interface.
protocol Shelling: AnyObject {
    /// Runs a shell command synchronously and returns the output.
    ///
    /// - Parameter args: shell command to be run.
    /// - Returns: the command output.
    /// - Throws: an error if the execution fails.
    func run(_ args: String...) throws -> String
}

/// Default implementation of Shelling.
class Shell: Shelling {
    /// Runs a shell command synchronously and returns the output.
    ///
    /// - Parameter args: shell command to be run.
    /// - Returns: the command output.
    /// - Throws: an error if the execution fails.
    func run(_ args: String...) throws -> String {
        let result = try Process.popen(arguments: args)
        if result.exitStatus == .terminated(code: 0) {
            return try result.utf8Output()
        } else {
            throw ShellError(description: try result.utf8stderrOutput())
        }
    }
}
