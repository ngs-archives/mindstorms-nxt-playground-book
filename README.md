# Mindstorms NXT Playground Book for iOS

https://devpost.com/software/mindstorms-nxt-playground-book

[![](https://i.vimeocdn.com/video/621786931_520x292.jpg)](https://vimeo.com/206693443)

## Setup

```sh
brew tap ngs/formulae
brew cask install nxt-fantom-driver
brew install nexttool nbc

# Install firmware
wget http://bricxcc.sourceforge.net/lms_arm_nbcnxc.zip
unzip lms_arm_nbcnxc.zip
nexttool -firmware="lms_arm_nbcnxc/lms_arm_nbcnxc_132.rfw"

# Setup server project
swift package generate-xcodeproj
```


## How to use

```swift
let nxt = NXT(name: "Hello NXT") // initialize robot

nxt.rotate(motor: .a, power: 100, angle: 145.0) // change angle of motor

// define sub routine
let sub = nxt.sub { nxt in
    nxt.forward(length: 100, turn: 0)
    nxt.wait(msec: 500)
    nxt.reverse(length: 100, turn: 0)
    nxt.wait(msec: 500)
}

// call sub routine
sub.call()
```
