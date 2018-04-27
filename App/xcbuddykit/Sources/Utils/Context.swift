import Foundation

/// Context protocol.
protocol Contexting: AnyObject {
    /// Shell.
    var shell: Shelling { get }

    /// Util to handle files.
    var fileHandler: FileHandling { get }

    /// Printer.
    var printer: Printing { get }

    /// Resource locator.
    var resourceLocator: ResourceLocating { get }

    /// Error handler.
    var errorHandler: ErrorHandling { get }
}

/// xcbuddy uses contexts as a dependency injection mechanism.
/// Contexts are initialized by the commands and passed to the different components that will use the dependencies defined in them.
class Context: Contexting {
    /// Util to handle files.
    let fileHandler: FileHandling

    /// Shell.
    let shell: Shelling

    /// Printer.
    let printer: Printing

    /// Resource locator.
    let resourceLocator: ResourceLocating

    /// Error handler.
    let errorHandler: ErrorHandling

    /// Initializes the context with its attributess.
    ///
    /// - Parameters:
    ///   - fileHandler: file handler.
    ///   - shell: shell.
    ///   - printer: printer.
    ///   - resourceLocator: resource locator.
    init(fileHandler: FileHandling = FileHandler(),
         shell: Shelling = Shell(),
         printer: Printing = Printer(),
         resourceLocator: ResourceLocating = ResourceLocator(),
         errorHandler: ErrorHandling = ErrorHandler()) {
        self.fileHandler = fileHandler
        self.shell = shell
        self.printer = printer
        self.resourceLocator = resourceLocator
        self.errorHandler = errorHandler
    }
}
