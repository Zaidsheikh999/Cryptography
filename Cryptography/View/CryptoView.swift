//
//  CryptoView.swift
//  Cryptography
//
//  Created by Zaid Sheikh on 18/09/2023.
//

import SwiftUI
import UIKit

struct CryptoView: View {
    
    @ObservedObject var viewModel = CryptoViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("Input")) {
                TextField("Text to encrypt", text: $viewModel.input)
            }
            
            Section(header: Text("Encryption Key")) {
                TextField("Key (16 chars)", text: $viewModel.key)
                    .textContentType(.password)
            }
            
            Section {
                Button("Encrypt") {
                    viewModel.encrypt()
                }
                
                Button("Decrypt") {
                    viewModel.decrypt()
                }
            }
            
            Section(header: Text("Encrypted Text")) {
                Text(viewModel.encryptedText)
                
                if !viewModel.encryptedText.isEmpty{
                    Button("Copy Encrypted Text") {
                        UIPasteboard.general.string = viewModel.encryptedText
                    }
                }
            }
            
            Section(header: Text("Decrypted Text")) {
                Text(viewModel.decryptedText)
                
                if !viewModel.decryptedText.isEmpty{
                    Button("Copy Decrypted Text") {
                        UIPasteboard.general.string = viewModel.decryptedText
                    }
                    
                }
            }
            
            if !viewModel.error.isEmpty {
                Section {
                    Text("Error: \(viewModel.error)")
                        .foregroundColor(.red)
                }
            }
        }
        
        Spacer()
        
        
        
        Button {
            viewModel.input = ""
            viewModel.encryptedText = ""
            viewModel.decryptedText = ""
            viewModel.key = ""
        } label: {
            Text("Clear All")
                .bold()
                .foregroundColor(.red)
                .background(Color(.white))
                .padding()
            
        }
        
        
    }
}

struct CryptoView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoView()
    }
}

