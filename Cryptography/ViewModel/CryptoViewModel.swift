//
//  CryptoViewModel.swift
//  Cryptography
//
//  Created by Zaid Sheikh on 18/09/2023.
//

import Foundation
import CommonCrypto

class CryptoViewModel: ObservableObject {
    @Published var input: String = ""
    @Published var encryptedText: String = ""
    @Published var decryptedText: String = ""
    @Published var key: String = "1234567890123456"  // 16 chars for AES128
    @Published var error: String = ""
    
    func encrypt() {
        if let encrypted = aesEncrypt(string: input, keyString: key) {
            encryptedText = encrypted.base64EncodedString()
            error = ""
        } else {
            error = "Encryption failed"
        }
    }
    
    func decrypt() {
        if let data = Data(base64Encoded: encryptedText),
           let decrypted = aesDecrypt(data: data, keyString: key) {
            decryptedText = decrypted
            error = ""
        } else {
            error = "Decryption failed"
        }
    }
    
    private let iv = "1234567890123456"
    
    private func aesEncrypt(string: String, keyString: String) -> Data? {
        guard let data = string.data(using: .utf8),
              let keyData = keyString.data(using: .utf8),
              let cryptData = NSMutableData(length: Int(data.count) + kCCBlockSizeAES128) else {
            return nil
        }
        
        let keyLength = size_t(kCCKeySizeAES128)
        let operation = CCOperation(kCCEncrypt)
        let options = CCOptions(kCCOptionPKCS7Padding)
        var numBytesEncrypted: size_t = 0
        
        let cryptStatus = data.withUnsafeBytes { dataBytes -> CCCryptorStatus in
            return keyData.withUnsafeBytes { keyBytes in
                return CCCrypt(operation,
                               CCAlgorithm(kCCAlgorithmAES),
                               options,
                               keyBytes.baseAddress!, keyLength,
                               iv,
                               dataBytes.baseAddress!, data.count,
                               cryptData.mutableBytes, cryptData.length,
                               &numBytesEncrypted)
            }
        }
        
        if cryptStatus == CCCryptorStatus(kCCSuccess) {
            cryptData.length = numBytesEncrypted
            return cryptData as Data
        } else {
            return nil
        }
    }
    
    private func aesDecrypt(data: Data, keyString: String) -> String? {
        guard let keyData = keyString.data(using: .utf8),
              let cryptData = NSMutableData(length: Int(data.count) + kCCBlockSizeAES128) else {
            return nil
        }
        
        let keyLength = size_t(kCCKeySizeAES128)
        let operation = CCOperation(kCCDecrypt)
        let options = CCOptions(kCCOptionPKCS7Padding)
        var numBytesDecrypted: size_t = 0
        
        let cryptStatus = data.withUnsafeBytes { dataBytes -> CCCryptorStatus in
            return keyData.withUnsafeBytes { keyBytes in
                return CCCrypt(operation,
                               CCAlgorithm(kCCAlgorithmAES),
                               options,
                               keyBytes.baseAddress!, keyLength,
                               iv,
                               dataBytes.baseAddress!, data.count,
                               cryptData.mutableBytes, cryptData.length,
                               &numBytesDecrypted)
            }
        }
        
        if cryptStatus == CCCryptorStatus(kCCSuccess) {
            cryptData.length = numBytesDecrypted
            return String(data: cryptData as Data, encoding: .utf8)
        } else {
            return nil
        }
    }
}
