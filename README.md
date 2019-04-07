# SwiftBoy

SwiftBoy is an in-progress Game Boy emulator written in Swift for MacOS. It is not currently capable of running games, but the framework has been written and progress is being made on finishing missing functionality.

### How To Run
To run this project, simply clone the repository, or download the zip, open `SwiftBoy.xcodeproj` in Xcode and press run. A demo ROM is included, but it can be replaced with another ROM by modifying the `romFile` parameter in the `gameBoy?.loadRom` call in `ViewController.swift`

### Current Features
  - Open ROM file
  - Properly parse ROM to opcodes
  - Step/run through opcodes
  - Display binary data on screen (Game Boy / Game Boy Pocket)
  - Built-in Debugger
    - View opcodes
    - See current PC
    - Step/Stop/Run
    - Set Breakpoints
    - View register contents in hex/decimal

### Not Yet Implemented
  - Memory banking
  - User I/O
    - Key presses
    - Sound
    - Serial
  - Boot ROM (currently simulated, not emulated)
  - Game Boy Color support
  - Advanced breakpoints (based on value, etc.)
  - Some opcode behavior may be incorrect

### Why another emulator?
Granted, there are plenty of Game Boy emulators available, but I wanted an interesting project that I could use to learn Swift and MacOS development. Additionally, making it fully open-source may help others who are interested in working on Game Boy development or emulation. 

### Screen Shots
![Main SwiftBoy View](https://raw.githubusercontent.com/perkinsb1024/SwiftBoy/master/Screenshots/MainView.png)
_The main window in SwiftBoy_

![SwiftBoy Disassembly View](https://raw.githubusercontent.com/perkinsb1024/SwiftBoy/master/Screenshots/DisassemblyView.png)
_The disassembly view, where addresses, opcodes and emulation flow-control options can be found_


![SwiftBoy Register View](https://raw.githubusercontent.com/perkinsb1024/SwiftBoy/master/Screenshots/RegisterView.png)
_The register view, where the contents of system registers can be see in hex or decimal_