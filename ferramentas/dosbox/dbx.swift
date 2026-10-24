import Cocoa
import CoreGraphics

// uso: dbx key <pid> <keycode> | dbx type <pid> <texto> | dbx win <pid>
// Eventos vao SO para o PID dado (CGEventPostToPid). Se o app nao for o frontmost, tenta ativar e,
// se continuar nao sendo, aborta sem enviar nada.
let a = CommandLine.arguments
guard a.count >= 3, let pid = pid_t(a[2]) else { print("uso"); exit(1) }

let codes: [Character: CGKeyCode] = [
 "a":0,"s":1,"d":2,"f":3,"h":4,"g":5,"z":6,"x":7,"c":8,"v":9,"b":11,"q":12,"w":13,"e":14,"r":15,"y":16,"t":17,
 "1":18,"2":19,"3":20,"4":21,"6":22,"5":23,"9":25,"7":26,"8":28,"0":29,"o":31,"u":32,"i":34,"p":35,"l":37,
 "j":38,"k":40,"n":45,"m":46," ":49]

func frontmostOK() -> Bool {
    if NSWorkspace.shared.frontmostApplication?.processIdentifier == pid { return true }
    NSRunningApplication(processIdentifier: pid)?.activate(options: [.activateAllWindows])
    for _ in 0..<20 {
        Thread.sleep(forTimeInterval: 0.1)
        if NSWorkspace.shared.frontmostApplication?.processIdentifier == pid { return true }
    }
    return false
}
func press(_ k: CGKeyCode) {
    guard ProcessInfo.processInfo.environment["DBX_SEMFOCO"] != nil || frontmostOK() else { FileHandle.standardError.write("ABORTADO: app nao esta em primeiro plano\n".data(using: .utf8)!); exit(2) }
    for down in [true, false] {
        let e = CGEvent(keyboardEventSource: nil, virtualKey: k, keyDown: down)!
        e.postToPid(pid)
        Thread.sleep(forTimeInterval: 0.03)
    }
}
switch a[1] {
case "key": press(CGKeyCode(a[3])!)
case "type":
    for c in a[3].lowercased() {
        guard let k = codes[c] else { FileHandle.standardError.write("tecla desconhecida: \(c)\n".data(using: .utf8)!); exit(3) }
        press(k); Thread.sleep(forTimeInterval: 0.15)
    }
case "win":
    let l = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID) as! [[String: Any]]
    for w in l where (w[kCGWindowOwnerPID as String] as? Int32) == pid && (w[kCGWindowLayer as String] as? Int) == 0 {
        print(w[kCGWindowNumber as String]!); exit(0)
    }
    exit(4)
default: exit(1)
}
