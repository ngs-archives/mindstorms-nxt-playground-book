//: Playground - noun: a place where people can play

import Foundation
import Prorsum

var str = "Hello, playground"

let wg = WaitGroup()

wg.add(1)
go {
    sleep(1)
    print("wg: 1")
    wg.done()
}

wg.add(1)
go {
    sleep(1)
    print("wg: 2")
    wg.done()
}

wg.wait() // block unitle twice wg.done() is called.

print("wg done")

let req = Request()

switch req.body {
case .buffer(let data):
    try! data.write(to: URL(fileURLWithPath: "/Users/ngs/foo.txt"), options: .atomic)
default:
    break
}

let task = Process()
task.launchPath = "/usr/local/bin/nbc"
task.arguments = []
task.launch()