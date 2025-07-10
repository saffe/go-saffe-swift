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

## The `extraData` parameter

The `extraData` parameter is optional and allows for dynamic changes specific to the transaction, such as language and colors. It's a named parameter, so you only need to include it when you want to customize the component. If you don't want any customization, simply omit it.

Primary and secondary colors should be informed in hexadecimal code. Possible values for the key "lang" at the moment are "en" so that the capture interface is presented in english, "pt" for the language to be portuguese, and "es" for spanish.

### ExtraData Structure

```swift
// Implement the required protocols
struct MySettings: Settings {
    var primaryColor: String?
    var secondaryColor: String?
    var lang: String?
}

struct MyExtraData: ExtraData {
    var settings: Settings?
}
```

### Usage Example - UIKit

```swift
import UIKit
import go_saffe_swift

class ViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Configure extra data
        let settings = MySettings(
            primaryColor: "#00ABAB",
            secondaryColor: "#6A6A6A", 
            lang: "en"
        )
        
        let extraData = MyExtraData(settings: settings)
        
        let goSaffeCapture = GoSaffeCapture(
            captureKey: "your-capture-key",
            user: "example@email.com",
            type: "verification",
            endToEndId: "exampleEndToEndId",
            onClose: {
                print("Capture closed")
            },
            onFinish: {
                print("Capture finished")
            },
            onTimeout: {
                print("Capture timeout")
            },
            extraData: extraData
        )
        
        self.present(goSaffeCapture, animated: true, completion: nil)
    }
}
```

### Usage Example - SwiftUI

```swift
import SwiftUI
import go_saffe_swift

struct GoSaffeCaptureView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> GoSaffeCapture {
        // Configure extra data
        let settings = MySettings(
            primaryColor: "#00ABAB",
            secondaryColor: "#6A6A6A",
            lang: "en"
        )
        
        let extraData = MyExtraData(settings: settings)
        
        let goSaffeCapture = GoSaffeCapture(
            captureKey: "your-capture-key",
            user: "example@email.com",
            type: "verification",
            endToEndId: "exampleEndToEndId",
            onClose: {
                print("Capture closed")
            },
            onFinish: {
                print("Capture finished")
            },
            onTimeout: {
                print("Capture timeout")
            },
            extraData: extraData
        )
        
        return goSaffeCapture
    }

    func updateUIViewController(_ uiViewController: GoSaffeCapture, context: Context) {
        // No updates needed
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
