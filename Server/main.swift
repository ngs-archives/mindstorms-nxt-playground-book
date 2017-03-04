import Prorsum
import Foundation

let re = try! NSRegularExpression(pattern: "^//#file:([^\n]+)")

let server = try! HTTPServer { (request, writer) in
    do {
        var res = ""
        switch request.body {
        case .buffer(let data):
            let src = String(data: data as Data, encoding: .utf8)!
            var filename = "nxcbuild"
            if let range = src.range(of: "^//#file:([^\n]+)", options: .regularExpression) {
                filename = src[range].substring(from: src.index(src.startIndex, offsetBy: 8))
            }
            let file = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(filename).nxc")
            res = file.path
            try! data.write(to: file, options: .atomic)
            let task = Process()
            task.launchPath = "/usr/local/bin/nbc"
            task.arguments = ["-r", file.path]
            task.launch()
        default:
            break
        }
        let response = Response(
            headers: ["Server": "Prorsum Micro HTTP Server"],
            body: .buffer(res.data)
        )
        try writer.serialize(response)
        writer.close()
    } catch {
        fatalError("\(error)")
    }
}

try! server.bind(host: "0.0.0.0", port: 3000)
print("Server listening at 0.0.0.0:3000")
try! server.listen()

RunLoop.main.run() //start run loop
