#!/usr/bin/swift

import Foundation

func work() {
    print("salve")
    let contents = try! getWalkthroughContents()
    
    let tokens = contents
        .split(separator: "\n")
        .map { String($0) }
        .map {
            $0.replacingOccurrences(of: "\t", with: "") }
        .flatMap { try! Lexer(str: $0).tokens() }
    
    let parsed = Parser(tokens: tokens).parse()
    dump(parsed)
    
    var res = [String: String]()

    parsed.forEach { result in
        result.keys.forEach {
            res[$0] = result[$0]
        }
    }
    
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .binary
    let encoded = try! encoder.encode(res)
    try! encoded.write(to: createLocalizableFile())
}

func createLocalizableFile() -> URL {
    URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        .appendingPathComponent("Resources")
        .appendingPathComponent("en.lproj")
        .appendingPathComponent("Localizable")
        .appendingPathExtension("strings")
}

func getWalkthroughContents() throws -> String {
    let sourcePath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        .appendingPathComponent("Walkthrough")
        .appendingPathExtension("tutorial")
    let data = try Data(contentsOf: sourcePath)
    return String(data: data, encoding: .utf8)!
}

enum CustomError: Error {
    case custom
}

typealias Result = [String: String]

final class ResultBuilder {
    
    private var currentResult = ""
    private var paragraphCount = 0
    private var guideCount = 0
    
    
    func addTrailingSeparator() {
        currentResult += ""
    }
    
    func removeLastEntry() {
        currentResult = currentResult
            .split(separator: ".")
            .dropLast()
            .joined(separator: "..")
    }
    
    func add(key: String) {
        addTrailingSeparatorIfNeeded()
        switch key {
        case "Guide":
            currentResult += "Guide\(guideCount)"
            guideCount += 1
        case "ContentAndMedia":
            currentResult += "LearningCenterContent"
        default:
            fatalError("Unhandled instruction \(key) with no args")
        }
    }
    
    func addKeyedInstruction(key: String, value: String) -> Result? {
        addTrailingSeparatorIfNeeded()
        switch key {
        case "GuideBook":
            currentResult = "GuideBook" // Since this is the root, we can reset result
            guard let title = extract("title", from: value) else { return nil }
            return [ currentResult + "..title": title ]
        case "Step":
            guard let title = extract("title", from: value)
            else { return nil }
            currentResult += "Step" + title
            print("TITLE:\(title)")
            return [ currentResult + "..title": title ]
        case "WelcomeMessage":
            guard let title = extract("title", from: value)
            else { return nil }
            currentResult += "WelcomeMessage" + title
            return [ currentResult + "..title": title ]
        case "GuideButton":
            guard let title = extract("title", from: value),
                  let description = extract("description", from: value)
            else { return nil }
            let buttonKey = currentResult + key + title
            return [
                buttonKey + "..title": title,
                buttonKey + "..description": description
            ]
        case "Task":
            guard let id = extract("id", from: value),
                  let title = extract("title", from: value)
            else { return nil }
            currentResult += "Task" + id
            return [ currentResult + "..title": title ]
            
        case "Page":
            guard let title = extract("title", from: value)
            else { return nil }
            currentResult += "Page" + title
            return [ currentResult + "..title": title ]
        default:
            fatalError("Unhandled instruction \(key) with args \(value)")
        }
    }
    
    func generateParagraph(content: String) -> Result? {
        guard content.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
        else { return nil }
        let paragraphId = currentResult.addingTrailingSeparatorIfNeeded() + "Paragraph" + String(paragraphCount)
        paragraphCount += 1
        return [paragraphId : content.trimmingCharacters(in: .whitespaces) ]
    }
    
    private func addTrailingSeparatorIfNeeded() {
        if currentResult.suffix(2) == ".." { return }
        currentResult += ".."
    }
    
    private func extract(_ key: String, from args: String) -> String? {
        args
            .split(separator: ",")
            .map { return String($0) }
            .filter { $0.contains(key) }
            .first?
            .components(separatedBy: ": ")
            .map { return String($0).replacingOccurrences(of: "\"", with: "") }
            .last
    }
}

struct Parser {
    let tokens: [Token]
    
    func parse() -> [Result] {
        var results: [Result] = []
        let builder = ResultBuilder()
        
        for token in tokens {
            switch token {
            case .openBlock:
                builder.addTrailingSeparator()
            case .closeBlock:
                builder.removeLastEntry()
            case let .paragraph(content):
                guard let newParagraph = builder.generateParagraph(content: content)
                else { continue }
                results.append(newParagraph)
            case let .instruction(name, args) where args == nil:
                builder.add(key: name)
            case let .instruction(name, args):
                guard let args = args,
                      let newEntry = builder.addKeyedInstruction(key: name, value: args)
                else { continue }
                results.append(newEntry)
            }
        }
        return results
    }
}

enum Token {
    case openBlock, closeBlock
    case paragraph(String)
    case instruction(name: String, args: String?)
}

struct Lexer {
    let str: String
    private var sanitizedLine: String { str.replacingOccurrences(of: " ", with: "") }
    
    func tokens() throws -> [Token] {
        if sanitizedLine.first == "@" {
            return [parseInstruction(), .openBlock]
        }
        
        if sanitizedLine.first == "{" { return [.openBlock] }
        if sanitizedLine.first == "}" { return [.closeBlock] }
        return [.paragraph(str)]
    }
    
    private func parseInstruction() -> Token {
        let sanitizeArgs: (String) -> String? = {
            $0
                .split(separator: "(")
                .last?
                .split(separator: ")")
                .first?
                .toString
        }
        guard let name = sanitizedLine
                            .dropFirst()
                            .split(separator: "(")
                            .first?
                            .replacingOccurrences(of: "{", with: "")
        else { fatalError("Trying to parse empty instruction! \(str)") }
        var args = sanitizeArgs(sanitizedLine)
        if let existingArgs = args,
           existingArgs.dropFirst().dropLast() == name {
            args = nil
        }
        
        if args != nil {
            args = sanitizeArgs(str)
        }
        print("----", name, args)
        return .instruction(name: name, args: args)
    }
}

work()

extension Substring.SubSequence {
    var toString: String { String(self) }
}

extension String {
    func addingTrailingSeparatorIfNeeded() -> String {
        if suffix(2) == ".." { return self }
        return self + ".."
    }
}
