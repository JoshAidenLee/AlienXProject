import UIKit
import WebKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

class ViewController: UIViewController, WKScriptMessageHandler {
    var webView: WKWebView!
    let executor = Executor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    func setupWebView() {
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        contentController.add(self, name: "executeScript")
        contentController.add(self, name: "injectScript")
        config.userContentController = contentController
        
        webView = WKWebView(frame: view.bounds, configuration: config)
        view.addSubview(webView)
        
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
                body { background: #1a1a2e; color: #fff; font-family: -apple-system; margin: 0; padding: 20px; }
                .container { max-width: 600px; margin: 0 auto; }
                h1 { color: #00ff88; text-align: center; }
                .btn { background: #00ff88; color: #000; border: none; padding: 15px 30px; border-radius: 10px; font-size: 18px; cursor: pointer; margin: 10px; width: 100%; }
                .btn:hover { background: #00cc66; }
                .input { width: 100%; height: 200px; background: #0f0f23; color: #fff; border: 1px solid #00ff88; border-radius: 10px; padding: 10px; font-size: 14px; }
                .output { background: #0f0f23; color: #00ff88; padding: 10px; border-radius: 10px; margin-top: 10px; min-height: 50px; font-family: monospace; }
                .status { text-align: center; padding: 5px; color: #888; }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>👽 Alien X Mobile</h1>
                <div class="status">Status: <span id="status">Ready</span></div>
                <textarea class="input" id="script" placeholder="Enter your Lua script here...">print("Hello from Alien X!")</textarea>
                <button class="btn" onclick="executeScript()">▶ Execute Script</button>
                <button class="btn" onclick="injectScript()">💉 Inject Script</button>
                <div class="output" id="output">Output will appear here...</div>
            </div>
            <script>
                function executeScript() {
                    const script = document.getElementById('script').value;
                    window.webkit.messageHandlers.executeScript.postMessage(script);
                }
                function injectScript() {
                    const script = document.getElementById('script').value;
                    window.webkit.messageHandlers.injectScript.postMessage(script);
                }
                function updateOutput(text) {
                    document.getElementById('output').innerText = text;
                }
            </script>
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "executeScript" {
            if let script = message.body as? String {
                let result = executor.executeLua(script)
                let js = "updateOutput('\(result)')"
                webView.evaluateJavaScript(js)
            }
        } else if message.name == "injectScript" {
            if let script = message.body as? String {
                executor.injectIntoRoblox(script)
            }
        }
    }
}