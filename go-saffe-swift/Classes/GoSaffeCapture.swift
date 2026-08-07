import UIKit
import WebKit
import IOSSecuritySuite

public protocol Settings {
    var primaryColor: String? { get }
    var secondaryColor: String? { get }
    var lang : String? { get }
}

public protocol ExtraData {
    var settings : Settings? { get }
}

struct CapturePayload {
    let captureKey: String
    let userIdentifier: String
    let type: String
    let endToEndId: String
    let deviceContext: [String: Bool]
    let extraData: ExtraData?

    func jsonObject() -> [String: Any] {
        var json: [String: Any] = [
            "capture_key": captureKey,
            "user_identifier": userIdentifier,
            "type": type,
            "end_to_end_id": endToEndId,
            "device_context": deviceContext
        ]

        if let settings = extraData?.settings.flatMap(Self.jsonObject(for:)) {
            json["settings"] = settings
        }

        return json
    }

    private static func jsonObject(for settings: Settings) -> [String: Any]? {
        var json: [String: Any] = [:]
        json["primary_color"] = settings.primaryColor
        json["secondary_color"] = settings.secondaryColor
        json["lang"] = settings.lang

        return json.isEmpty ? nil : json
    }
}

public class GoSaffeCapture: UIViewController {

    var webView: WKWebView?
    let captureKey: String
    let user: String
    let type: String
    let endToEndId: String
    var isMessageReceived = false
    let onClose: () -> Void
    let onFinish: () -> Void
    let onTimeout: () -> Void
    let extraData: ExtraData?
    
    public init(captureKey: String, user: String, type: String, endToEndId: String, onClose: @escaping () -> Void, onFinish: @escaping () -> Void, onTimeout: @escaping () -> Void, extraData: ExtraData? = nil) {
        self.captureKey = captureKey
        self.user = user
        self.type = type
        self.endToEndId = endToEndId
        self.onClose = onClose
        self.onFinish = onFinish
        self.onTimeout = onTimeout
        self.extraData = extraData
        super.init(nibName: nil, bundle: nil)
        self.webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        self.webView?.navigationDelegate = self
    }
    
    required init?(coder: NSCoder) {
        self.captureKey = ""
        self.user = ""
        self.type = ""
        self.endToEndId = ""
        self.onClose = {}
        self.onFinish = {}
        self.onTimeout = {}
        self.extraData = nil
        super.init(coder: coder)
    }
    
    deinit {
        
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        createWebView()
        loadWebView()
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

    func loadWebView() {
        let urlString = "https://go.saffe.ai/v0/capture"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let payload = CapturePayload(
            captureKey: captureKey,
            userIdentifier: user,
            type: type,
            endToEndId: endToEndId,
            deviceContext: getDeviceContext(),
            extraData: extraData)

        let jsonData = try? JSONSerialization.data(withJSONObject: payload.jsonObject())

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        webView?.load(request)
    }
    
    func getDeviceContext() -> [String: Bool] {
        var json: [String: Bool] = [:]
        json["isJailBroken"] = IOSSecuritySuite.amIJailbroken()
        json["isRealDevice"] = !IOSSecuritySuite.amIRunInEmulator()
        
        return json
    }

}

extension GoSaffeCapture: WKNavigationDelegate {

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let script = """
        (function() {
            window.addEventListener('message', function(event) {
                window.webkit.messageHandlers.receiveMessage.postMessage(event.data);
            });
        })();
        """
        webView.evaluateJavaScript(script, completionHandler: nil)
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    }

}

extension GoSaffeCapture: WKScriptMessageHandler {

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
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
                    onClose()
                } else if event == "finish" && !isMessageReceived {
                    isMessageReceived = true
                    webView = nil
                    webView?.navigationDelegate = nil
                    webView?.configuration.userContentController.removeScriptMessageHandler(forName: "receiveMessage")
                    webView?.stopLoading()
                    onFinish()
                } else if event == "timeout" && !isMessageReceived {
                    isMessageReceived = true
                    webView = nil
                    webView?.navigationDelegate = nil
                    webView?.configuration.userContentController.removeScriptMessageHandler(forName: "receiveMessage")
                    webView?.stopLoading()
                    onTimeout()
                }
            }
        }
    }

}
