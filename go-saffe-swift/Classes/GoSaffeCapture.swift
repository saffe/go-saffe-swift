import Foundation
import WebKit

class GoSaffeCapture {
    let captureKey: String
    let userIdentifier: String
    let type: String
    let endToEndId: String
    var webView: WKWebView?

    init(captureKey: String, userIdentifier: String, type: String, endToEndId: String) {
        self.captureKey = captureKey
        self.userIdentifier = userIdentifier
        self.type = type
        self.endToEndId = endToEndId
        self.webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        self.webView?.navigationDelegate = self
    }

    func load() {
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

extension GoSaffeCapture: WKNavigationDelegate {
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
}
