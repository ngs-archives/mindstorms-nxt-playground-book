//#-hidden-code
import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//#-end-hidden-code
//#-editable-code Tap to enter code
let nxt = NXT(name: "Hello NXT")

nxt.rotate(motor: .a, power: 100, angle: 145.0)

let sub = nxt.sub { nxt in
    nxt.forward(length: 100, turn: 0)
    nxt.wait(msec: 500)
    nxt.reverse(length: 100, turn: 0)
    nxt.wait(msec: 500)
}

5.times {
    sub.call()
}
//#-end-editable-code
//#-hidden-code
let url = URL(string: "http://ngs-mbpro15.local:3000/")!
var req = URLRequest(url: url)
req.httpBody = nxt.flush().data(using: .utf8)
req.httpMethod = "POST"
URLSession.shared.dataTask(with: req) { (data, res, err) in
    PlaygroundPage.current.finishExecution()
    }.resume()
//#-end-hidden-code
