import Foundation

class Executor {
    @_silgen_name("execute_lua")
    private func executeLuaNative(_ script: UnsafePointer<CChar>) -> UnsafePointer<CChar>?
    
    @_silgen_name("inject_into_process")
    private func injectIntoProcessNative(_ script: UnsafePointer<CChar>) -> Bool
    
    func executeLua(_ script: String) -> String {
        let result = executeLuaNative(script)
        if let result = result {
            return String(cString: result)
        }
        return "Execution failed"
    }
    
    func injectIntoRoblox(_ script: String) {
        let success = injectIntoProcessNative(script)
        print(success ? "✅ Injected successfully" : "❌ Injection failed")
    }
}