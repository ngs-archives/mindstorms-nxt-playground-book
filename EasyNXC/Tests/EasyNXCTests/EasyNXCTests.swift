import XCTest
import Foundation
@testable import EasyNXC

class EasyNXCTests: XCTestCase {
    func testInit() {
        let robot = NXT()
        XCTAssertEqual("task main() {\n\n}\n", robot.flush())
    }

    func testInitWithName() {
        let robot = NXT(name: "Hello Nxt")
        XCTAssertEqual("//#file:Hello Nxt\n\ntask main() {\n\n}\n", robot.flush())
    }
    func testForward() {
        let robot = NXT()
        let res = robot.forward(length: 10, turn: 20).flush()
        XCTAssertEqual("task main() {\nOnFwdSync(OUT_BC, 10, 20);\n}\n", res)
        XCTAssertEqual("task main() {\n\n}\n", robot.flush())
    }
    func testReverse() {
        let robot = NXT()
        let res = robot.reverse(length: 10, turn: 20).flush()
        XCTAssertEqual("task main() {\nOnRevSync(OUT_BC, 10, 20);\n}\n", res)
        XCTAssertEqual("task main() {\n\n}\n", robot.flush())
    }
    func testRotate() {
        let robot = NXT()
        let res = robot.rotate(motor: .ab, power: 30, angle: 92.123456789).flush()
        XCTAssertEqual("task main() {\nRotateMotor(OUT_AB, 30, 92.123457);\n}\n", res)
        XCTAssertEqual("task main() {\n\n}\n", robot.flush())
    }

    func testSub() {
        let robot = NXT()
        _ = robot.rotate(motor: .ab, power: 30, angle: 92.123456789)
        let sub = robot.sub { nxt in
            _ = nxt.reverse(length: 10, turn: 20)
        }
        _ = robot.reverse(length: 40, turn: 30)
        _ = sub.call("1", "2", "3")
        let res = robot.flush()
        XCTAssertEqual("task main() {\nvoid mySub1() {\nOnRevSync(OUT_BC, 10, 20);\n}\n\nRotateMotor(OUT_AB, 30, 92.123457);\nOnRevSync(OUT_BC, 40, 30);\nmySub1(1, 2, 3)\n}\n", res)
        XCTAssertEqual("task main() {\n\n}\n", robot.flush())
    }
}
