# Mindstorms NXT Playground Book for iOS

https://devpost.com/software/mindstorms-nxt-playground-book

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
