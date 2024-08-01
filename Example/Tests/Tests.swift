import XCTest
@testable import go_saffe_swift

class Tests: XCTestCase {
    
    var goSaffeCapture: GoSaffeCapture!
    var onCloseCalled = false
    var onFinishCalled = false

    override func setUp() {
        super.setUp()
        onCloseCalled = false
        onFinishCalled = false
        
        goSaffeCapture = GoSaffeCapture(
            captureKey: "testCaptureKey",
            userIdentifier: "testUserIdentifier",
            type: "testType",
            endToEndId: "testEndToEndId",
            onClose: { [weak self] in
                self?.onCloseCalled = true
            },
            onFinish: { [weak self] in
                self?.onFinishCalled = true
            }
        )
    }
    
    override func tearDown() {
        goSaffeCapture = nil
        super.tearDown()
    }
    
    func testExample() {
        // Este é um exemplo de um caso de teste funcional.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // Este é um exemplo de um caso de teste de desempenho.
        self.measure {
            // Coloque o código que você deseja medir o tempo aqui.
        }
    }
    
    func testWebViewLoading() {
        // Teste para verificar se o webView está sendo carregado corretamente
        goSaffeCapture.loadLiveness()
        
        // Verifique se o webView não é nulo
        XCTAssertNotNil(goSaffeCapture.webView)
        
        // Verifique se a URL correta foi carregada
        if let request = goSaffeCapture.webView?.url?.absoluteString {
            XCTAssertEqual(request, "https://go.saffe.ai/v0/capture")
        } else {
            XCTFail("URL is nil")
        }
    }
}
