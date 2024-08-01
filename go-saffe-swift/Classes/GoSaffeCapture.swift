import UIKit
import WebKit

class ViewController: UIViewController {

    var webView: WKWebView?
    let captureKey: String
    let userIdentifier: String
    let type: String
    let endToEndId: String
    var isMessageReceived = false
    
    init(captureKey: String, userIdentifier: String, type: String, endToEndId: String) {
        self.captureKey = captureKey
        self.userIdentifier = userIdentifier
        self.type = type
        self.endToEndId = endToEndId
        super.init(nibName: nil, bundle: nil)
        self.webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        self.webView?.navigationDelegate = self
    }
    
    required init?(coder: NSCoder) {
        self.captureKey = ""
        self.userIdentifier = ""
        self.type = ""
        self.endToEndId = ""
        super.init(coder: coder)
    }
    
    deinit {
        print("LivenessViewController deinitialized")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        createWebView()
        loadLiveness()
    }

    func createWebView() {
        let webConfiguration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        userContentController.add(self, name: "receiveMessage")
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        webConfiguration.userContentController = userContentController

        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView?.navigationDelegate = self
        view.addSubview(webView!)
        webView?.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            let margins = self.view.safeAreaLayoutGuide
            
            NSLayoutConstraint.activate([
                webView!.topAnchor.constraint(equalTo: margins.topAnchor),
                webView!.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
                webView!.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                webView!.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
            ])
        }
        
    }

    func loadLiveness() {
        let urlString = "https://go.saffe.ai/v0/capture"
        guard let url = URL(string: urlString) else {
            return
        }
        let json: [String: Any] = [
            "capture_key": captureKey,
            "user_identifier": userIdentifier,
            "type": type,
            "end_to_end_id": endToEndId
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        webView?.load(request)
    }

}

extension ViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let script = """
        (function() {
            window.addEventListener('message', function(event) {
                window.webkit.messageHandlers.receiveMessage.postMessage(event.data);
            });
        })();
        """
        webView.evaluateJavaScript(script, completionHandler: nil)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // Falha na navegação
    }

}

extension ViewController: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "receiveMessage" {
            if let args = message.body as? [String: Any],
               let source = args["source"] as? String, source == "go-saffe-capture",
               let payload = args["payload"] as? [String: Any],
               let event = payload["event"] as? String {

                if event == "close" && !isMessageReceived {
                    isMessageReceived = true
                    webView = nil
                    webView?.navigationDelegate = nil
                    webView?.configuration.userContentController.removeScriptMessageHandler(forName: "receiveMessage")
                    webView?.stopLoading()
                } else if event == "finish" && !isMessageReceived {
                    isMessageReceived = true
                    webView = nil
                    webView?.navigationDelegate = nil
                    webView?.configuration.userContentController.removeScriptMessageHandler(forName: "receiveMessage")
                    webView?.stopLoading()
                }
            }
        }
    }

}
