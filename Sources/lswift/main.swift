import Foundation
import TSCUtility

class Executor {
    private let shouldShowDodFiles: OptionArgument<Bool>
    
    init(parser: ArgumentParser) {
        shouldShowDodFiles = parser.add(option: "--show-dotfiles",
                                        shortName: "-a",
                                        kind: Bool.self,
                                        usage: "Include directory entries whose names begin with a dot (.).")
    }
    
    func execute(args: ArgumentParser.Result) {
//        print(args)
        let fileManager = FileManager.default
        let currentPath = fileManager.currentDirectoryPath
//        print(fileManager.currentDirectoryPath)

        let shouldShowDotFiles = args.get(self.shouldShowDodFiles) ?? false
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(atPath: currentPath)
//            print(fileURLs)
            let output = fileURLs.filter { shouldShowDotFiles ? true : $0.prefix(1) != "." }.reduce("") { (res, add) in
                res + "\t\(add)"
            }
            print(output.dropFirst())
        } catch {
            print("Error while enumerating files \(currentPath): \(error.localizedDescription)")
        }
    }
}

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

main()
