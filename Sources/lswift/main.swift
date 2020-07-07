import Foundation
import TSCUtility

main()

func main() {
    let parser = ArgumentParser(usage: "<options>", overview: "lswift: ls command made with swift language.")
    
    let command = Executor(parser: parser)
    let inputs = Array(CommandLine.arguments.dropFirst())
    
    do {
        let args = try parser.parse(inputs)
        command.execute(args: args)
    } catch {
        fatalError("Command-line pasing error: \(error)")
    }
}

class Executor {
    private let shouldShowDodFiles: OptionArgument<Bool>
    
    init(parser: ArgumentParser) {
        shouldShowDodFiles = parser.add(option: "--show-dotfiles",
                                        shortName: "-a",
                                        kind: Bool.self,
                                        usage: "Include directory entries whose names begin with a dot (.).")
    }
    
    func execute(args: ArgumentParser.Result) {
        let fileManager = FileManager.default
        let shouldShowDotFiles = args.get(self.shouldShowDodFiles) ?? false
        
        do {
            var options: FileManager.DirectoryEnumerationOptions = []
            if !shouldShowDotFiles {
                options.insert(.skipsHiddenFiles)
            }
            let fileURLs = try fileManager.contentsOfDirectory(at: URL(string: fileManager.currentDirectoryPath)!,
                                                               includingPropertiesForKeys: nil,
                                                               options: options)
            let models = fileURLs.map { FileModel(URL: $0) }
            let valList = models.map { $0.makeOutputVal() }
            
            let builder = OutputStringBuilder()
            valList.forEach { builder.set(val: $0) }
            
            let output = builder.build()
            print(output)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
}

struct FileModel {
    enum `Type` {
        case file
        case dir
        
        func ASCIIColor() -> ASCIIColor {
            switch self {
            case .dir:
                return .green
            case .file:
                return .none
            }
        }
    }
    let URL: Foundation.URL
    let type: Type
    
    init(URL: Foundation.URL) {
        self.URL = URL
        type = URL.hasDirectoryPath ? .dir : .file
    }
    
    func makeOutputVal() -> OutputVal {
        return OutputVal(string: URL.lastPathComponent, color: type.ASCIIColor())
    }
}

class OutputStringBuilder {
    private var outputValList: [OutputVal] = []
    
    func set(val: OutputVal) {
        outputValList.append(val)
    }
    
    func build() -> String {
        return String(outputValList.reduce("") { (res, add) in
            if add.color == .none { return res + "\t\(add.string)"}
            let tab = "\t"
            let color = add.color.rawValue
            let clearColor = "\u{001B}[m"
            return res + tab + color + add.string + clearColor
        }.dropFirst())
    }
}

struct OutputVal {
    let string: String
    let color: ASCIIColor
}

enum ASCIIColor: String {
    case none = ""
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"
    
    func name() -> String {
        switch self {
        case .none: return ""
        case .red: return "Red"
        case .green: return "Green"
        case .yellow: return "Yellow"
        }
    }
}

