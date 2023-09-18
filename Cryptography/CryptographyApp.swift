//
//  CryptographyApp.swift
//  Cryptography
//
//  Created by Zaid Sheikh on 18/09/2023.
//

import SwiftUI

@main
struct CryptographyApp: App {
    @ObservedObject var viewModel = CryptoViewModel()
    var body: some Scene {
        WindowGroup {
            CryptoView(viewModel: viewModel)
        }
    }
}
