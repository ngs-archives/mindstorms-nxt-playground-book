import Prorsum
import Foundation

let server = try! HTTPServer { (request, writer) in
    do {
        var str = "Hello, playground"
        let date = Int(Date().timeIntervalSince1970)
        let file = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(date).nxc")
        switch request.body {
        case .buffer(let data):
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
            body: .buffer(file.path.data)
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
