import Basic
import Foundation

/// Loads the graph that starts at the given path.
protocol GraphLoading: AnyObject {
    func load(path: AbsolutePath) throws -> Graph
}

/// Default graph loader.
class GraphLoader: GraphLoading {
    /// Loads the graph at the given path.
    ///
    /// - Parameter path: path where the graph starts from. It's the path where the Workspace.swift or the Project.swift file is.
    /// - Returns: a graph controller with that contains the graph representation.
    /// - Throws: an error if the graph cannot be loaded.
    func load(path: AbsolutePath) throws -> Graph {
        let context = GraphLoaderContext()
        if context.fileHandler.exists(path.appending(component: Constants.Manifest.project)) {
            return try loadProject(path: path, context: context)
        } else if context.fileHandler.exists(path.appending(component: Constants.Manifest.workspace)) {
            return try loadWorkspace(path: path, context: context)
        } else {
            throw GraphLoadingError.manifestNotFound(path)
        }
    }

    /// Loads a project graph.
    ///
    /// - Parameters:
    ///   - path: path to the Project.swift.
    ///   - context: loader context.
    /// - Returns: a graph controller with that contains the graph representation.
    /// - Throws: an error if the graph cannot be loaded.
    fileprivate func loadProject(path: AbsolutePath, context: GraphLoaderContext) throws -> Graph {
        let project = try Project.at(path, context: context)
        let entryNodes: [GraphNode] = try project.targets.map({ $0.name }).map { targetName in
            return try TargetNode.read(name: targetName, path: path, context: context)
        }
        return Graph(name: project.name,
                     entryPath: path,
                     cache: context.cache,
                     entryNodes: entryNodes)
    }

    /// Loads a workspace graph.
    ///
    /// - Parameters:
    ///   - path: path to the Project.swift.
    ///   - context: loader context.
    /// - Returns: a graph controller with that contains the graph representation.
    /// - Throws: an error if the graph cannot be loaded.
    fileprivate func loadWorkspace(path: AbsolutePath, context: GraphLoaderContext) throws -> Graph {
        let workspace = try Workspace.at(path, context: context)
        let projects = try workspace.projects.map { (projectPath) -> (AbsolutePath, Project) in
            return try (projectPath, Project.at(projectPath, context: context))
        }
        let entryNodes = try projects.flatMap { (project) -> [TargetNode] in
            return try project.1.targets.map({ $0.name }).map { targetName in
                try TargetNode.read(name: targetName, path: project.0, context: context)
            }
        }
        return Graph(name: workspace.name,
                     entryPath: path,
                     cache: context.cache,
                     entryNodes: entryNodes)
    }
}
