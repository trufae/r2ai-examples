//
//  PasswordCheckApp.swift
//  PasswordCheck
//
//  Created by pancake on 9/7/24.
//

import SwiftUI

@main
struct PasswordCheckApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

func checkPassword(_ s: String) -> Bool {
    return "password123" == s;
}
