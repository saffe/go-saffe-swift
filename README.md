# go-saffe-swift

## Requirements

- iOS 12.0+
- Xcode 11+
- Swift 5.0+

## Installation

To integrate `go-saffe-swift` into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
platform :ios, '12.0'

target 'YourAppTarget' do
  use_frameworks!

  pod 'go-saffe-swift'
end

## Example


```swift
import UIKit
import go_saffe_swift

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController viewDidLoad called")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ViewController viewDidAppear called")
        
        let goSaffeCapture = GoSaffeCapture(
            captureKey: "your-capture-key",
            user: "example@email.com",
            type: "verification or onboarding",
            endToEndId: "exampleEndToEndId",
            onClose: {
                print("Capture closed")
            },
            onFinish: {
                print("Capture finished")
            }
        )
        
        // Present GoSaffeCapture
        self.present(goSaffeCapture, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
```

```swift
import SwiftUI
import go_saffe_swift

struct ContentView: View {
    @State private var showGoSaffeCapture = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button(action: {
                showGoSaffeCapture = true
            }) {
                Text("Show GoSaffeCapture")
            }
            .sheet(isPresented: $showGoSaffeCapture) {
                GoSaffeCaptureView()
            }
        }
        .padding()
    }
}

struct GoSaffeCaptureView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> GoSaffeCapture {
        let goSaffeCapture = GoSaffeCapture(
            captureKey: "exampleCaptureKey",
            userIdentifier: "exampleUserIdentifier",
            type: "exampleType",
            endToEndId: "exampleEndToEndId",
            onClose: {
                print("Capture closed")
            },
            onFinish: {
                print("Capture finished")
            }
        )
        return goSaffeCapture
    }

    func updateUIViewController(_ uiViewController: GoSaffeCapture, context: Context) {
        // Leave this empty since there's no need to update the view controller
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

## Author

Pedro Cruz, pedro@saffe.ai
Caio França, caiofranca5@hotmail.com


## License

go-saffe-swift is available under the MIT license. See the LICENSE file for more info.
