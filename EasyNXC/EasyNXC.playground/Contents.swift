//: Playground - noun: a place where people can play

import Cocoa
import PlaygroundSupport
import EasyNXC

let url = URL(string: "http://ngs-mbpro15.local:3000/")!
var req = URLRequest(url: url)

let nxt = NXT(name: "Hello NXT")

nxt.rotate(motor: .a, power: 100, angle: 145.0)
nxt.forward(left: 20, right: 26)

req.httpBody = nxt.flush().data(using: .utf8)
req.httpMethod = "POST"

PlaygroundPage.current.needsIndefiniteExecution = true

URLSession.shared.dataTask(with: req) { (data, res, err) in
    if let data = data, let str = String(data: data, encoding: .utf8) {
        print(str)
    } else {
    }
    PlaygroundPage.current.finishExecution()
}.resume()

extension Int {
    func times(f: () -> ()) {
        if self > 0 {
            for _ in 0..<self {
                f()
            }
        }
    }
}