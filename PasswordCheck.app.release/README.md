# Example

Loading the release binary:

```
$ r2 PasswordCheck
Do you want to run the 'PasswordCheck.r2' script? (y/N)  y
0x100001634 Enter Password
0x100001704 Password
0x100001b4c 123
0x100001b58 password
0x100001bc0 password123
0x100001c38 123
0x100001d40 Submit
0x100002004 Success
0x10000201c Error
0x100002114 OK
0x100002f10 forp

INFO: Analyze all flags starting with sym. and entry0 (aa)
INFO: Analyze imports (af@@@i)
INFO: Analyze entrypoint (af@ entry0)
INFO: Analyze symbols (af@@@s)
INFO: Recovering variables (afva@@@F)
INFO: Analyze all functions arguments/locals (afva@@@F)
 -- In visual mode press 'c' to toggle the cursor mode. Use tab to navigate
[0x100001b34]> 
```

## Decompiling

```swift
[0x100001b34]> decai -e api=claude
[0x100001b34]> decai -d
func checkPassword(_ input: String) -> Bool {
    let targetPassword = "password123"
    let profile = ResourceBundleClass()
    var isValid = false
    
    if input == targetPassword {
        isValid = true
    } else {
        isValid = false
    }
    
    return isValid
}

[0x100001b34]> decai -e lang=python
[0x100001b34]> decai -Q reduce boilerplate, keep it as simple as possible
def check_password(password_input):
    return password_input == "password123"
[0x100001b34]> 
```

## SwiftUI

Finding the main interface and decompiling it grepping for both keywords:

* Grep for symbols containing "ContentView..."
* VWO attribute handle the main window object

```console
[0x100002458]> isq~VWO~ContentView
0x100002884 0 PasswordCheck.ContentView...VWOr
```

Seek there and decompile it with decai or r2ai:

```swift
[0x100002458]> decai -d @ 0x100002884
struct ContentView: View {
    @State private var password = ""
    @State private var isAlertShown = false
    
    var body: some View {
        VStack {
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: checkPassword) {
                Text("Submit")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .alert(isPresented: $isAlertShown) {
            Alert(title: Text("Password Check"),
                  message: Text("Password entered"),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    private func checkPassword() {
        isAlertShown = true
    }
}
```

Decompiling other interesting methods:

```swift
[0x100002370]> decai -d
struct ContentView: View {
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack {
            if isPasswordVisible {
                TextField("Enter password", text: $password)
            } else {
                SecureField("Enter password", text: $password)
            }
            
            Button(action: {
                isPasswordVisible.toggle()
            }) {
                Text(isPasswordVisible ? "Hide" : "Show")
            }
            
            Button(action: {
                checkPassword()
            }) {
                Text("Submit")
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Password Check"),
                message: Text("Password entered: \(password)"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func checkPassword() {
        showAlert = true
    }
}
```

Renaming mangled functions:

```swift
[0x100001b34]> s 0x100001f60
[0x100001f60]> afn
sym.PasswordCheck.ContentView.body.SwiftUI.Tuple...D0VyAE0D0PAEE7paddingyQrAE4EdgeO3SetV_12CoreGraphics7CGFloatVSgtFQOyAE4TextV_Qo__AiEEAJyQrAN_ARtFQOyAiEE14textFieldStyleyQrqd__AE0oqR0Rd__lFQOyAE06SecureQ0VyATG_AE013RoundedBorderoqR0VQo__Qo_AiEE5alert11isPresented7contentQrAE7BindingVySbG_AE5AlertVyXEtFQOyAE6ButtonVyAiEE12cornerRadius_11antialiasedQrAQ_SbtFQOyAiEE15foregroundColoryQrAE5ColorVSgFQOyAiEE10background_20ignoresSafeAreaEdgesQrqd___ANtAE05ShapeR0Rd__lFQOyAU_A17_Qo__Qo__Qo_G_Qo_tGyXEfU_A10_yXEfU1_
[0x100001f60]> decai -n
afn validatePasswordInterface @ 0x100001f60
[0x100001f60]> 
```

Compare decompiled output with [source](../PasswordCheck.src/PasswordCheck/ContentView.swift)

```swift
[0x100001f60]> decai -e lang=swiftui
[0x100001f60]> decai -d
import SwiftUI

struct PasswordCheckView: View {
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var isCorrectPassword = false
    
    var body: some View {
        SecureField("Enter password", text: $password)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(isCorrectPassword ? "Success" : "Error"),
                    message: Text(isCorrectPassword ? "Password is correct!" : "Incorrect password."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .background(Color.white)
            .cornerRadius(10)
            .foregroundColor(.black)
    }
    
    func checkPassword() {
        isCorrectPassword = password == "password123"
        showAlert = true
    }
}
[0x100001f60]> 
```
