import Foundation

public class NXT {
    private var stack: [String] = []
    private var subs: [String] = []
    private var subCount = 0
    public let tireChannel = Out.bc
    public var name: String?
    private var source: String {
        get { return stack.joined(separator: "\n") }
    }

    typealias SubBlock = (NXT) -> ()

    public enum Out: String {
        case a = "OUT_A"
        case b = "OUT_B"
        case c = "OUT_C"
        case ab = "OUT_AB"
        case bc = "OUT_BC"
        case ac = "OUT_AC"
        case abc = "OUT_ABC"
    }

    public init(name: String?) {
        self.name = name
    }

    public init() {
    }

    public func forward(length: Int, turn: Int = 0) -> NXT {
        stack.append(String(format: "OnFwdSync(%@, %d, %d);", tireChannel.rawValue, length, turn))
        return self
    }

    public func reverse(length: Int, turn: Int = 0) -> NXT {
        stack.append(String(format: "OnRevSync(%@, %d, %d);", tireChannel.rawValue, length, turn))
        return self
    }

    public func rotate(motor: Out, power: Int, angle: Double) -> NXT {
        stack.append(String(format: "RotateMotor(%@, %d, %f);", motor.rawValue, power, angle))
        return self
    }

    public func wait(msec: Int) -> NXT {
        stack.append(String(format: "Wait(%d);", msec))
        return self
    }

    public func sub(args: [String] = [], block: SubBlock) -> Sub  {
        subCount += 1
        let local = NXT()
        block(local)
        let sub = Sub(parent: self, name: "mySub\(subCount)", source: local.source, args: args)
        subs.append(sub.source)
        return sub
    }

    public func flush() -> String {
        let filenameComment: String
        if let name = name {
            filenameComment = "//#file:\(name)\n\n"
        } else {
            filenameComment = ""
        }
        let str = "\(filenameComment)\(subs.joined(separator: "\n"))\n\ntask main() {\n\(source)\n}\n"
        stack = []
        return str
    }

    public class Sub {
        let source: String
        let name: String
        private let parent: NXT
        init(parent: NXT, name: String, source: String, args: [String]) {
            self.parent = parent
            self.name = name
            self.source = "void \(name)(\(args.joined(separator: ", "))) {\n\(source)\n}\n"
        }

        public func call(_ args: String...) -> Sub {
            parent.stack.append("\(name)(\(args.joined(separator: ", ")));")
            return self
        }
    }
}
