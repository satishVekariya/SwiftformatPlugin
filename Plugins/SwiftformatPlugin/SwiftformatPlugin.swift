//
//  SwiftformatPlugin.swift
//  
//
//  Created by Satish Vekariya on 08/10/2022.
//

import PackagePlugin

// MARK: - CodeFormatPlugin
@main struct SwiftformatPlugin: BuildToolPlugin {
    
    /// Inherited from BuildToolPlugin.createBuildCommands(context:target:).
    /// - Parameters:
    ///   - context: Plugin Context
    ///   - target: Plugin target
    /// - Returns: Array of commands
    func createBuildCommands(context: PackagePlugin.PluginContext,
                             target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        guard let _ = target as? SourceModuleTarget else {
            return []
        }

        let tool = try context.tool(named: "swiftformat")
        let output = context.pluginWorkDirectory
        let packageDir = context.package.directory.string
        
        return [
            .prebuildCommand(
                displayName: "SwiftformatPlugin: Execute swiftformat at path: \(packageDir)",
                executable: tool.path,
                arguments: [
                    packageDir
                ],
                outputFilesDirectory: output
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftformatPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodeProjectPlugin.XcodePluginContext,
                             target: XcodeProjectPlugin.XcodeTarget) throws -> [PackagePlugin.Command] {
        guard let _ = target as? SourceModuleTarget else {
            return []
        }

        let tool = try context.tool(named: "swiftformat")
        let output = context.pluginWorkDirectory
        let projectDir = context.xcodeProject.directory
        
        return [
            .prebuildCommand(
                displayName: "SwiftformatPlugin: Execute swiftformat at path: \(projectDir)",
                executable: tool.path,
                arguments: [
                    projectDir
                ],
                outputFilesDirectory: output
            )
        ]
    }
}
#endif
