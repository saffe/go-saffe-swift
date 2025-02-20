# go-saffe-swift

## Requirements

- **iOS 12.0+**
- **Xcode 11+**
- **Swift 5.0+**

---

## Installation

### CocoaPods

To integrate `go-saffe-swift` into your Xcode project using CocoaPods, add the following line to your `Podfile`:

```ruby
platform :ios, '12.0'

target 'YourAppTarget' do
  use_frameworks!

  pod 'go-saffe-swift'
end
```

After editing the Podfile, run:

```bash
pod install
```

---

## Required Permissions

To make `go-saffe-swift` work correctly, you need to add permissions in your project's `Info.plist`. Include the following keys:

### Camera
```xml
<key>NSCameraUsageDescription</key>
<string>This app requires camera access to capture images.</string>
```

### Location
> **Note:** Location permission is optional. To enable location, activate it in the settings and add:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app requires access to your location while using the app.</string>
```

---

## Example Usage

### UIKit

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
            },
            onTimeout: {
                print("Capture timeout")
            }
        )
        
        // Present GoSaffeCapture as a modal screen
        self.present(goSaffeCapture, animated: true, completion: nil)
    }
}
```

---

### SwiftUI

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
            user: "exampleUserIdentifier",
            type: "exampleType",
            endToEndId: "exampleEndToEndId",
            onClose: {
                print("Capture closed")
            },
            onFinish: {
                print("Capture finished")
            },
            onTimeout: {
                print("Capture timeout")
            }
        )
        return goSaffeCapture
    }

    func updateUIViewController(_ uiViewController: GoSaffeCapture, context: Context) {
        // No need to update the view controller
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

---


## Author

- **Pedro Cruz** - [pedro@saffe.ai](mailto:pedro@saffe.ai)  
- **Caio França** - [caiofranca5@hotmail.com](mailto:caiofranca5@hotmail.com)

---

## License

`go-saffe-swift` is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.
