//
//  CryptoKitViewModel.swift
//  spy-app
//
//  Created by Siriluk Rachaniyom on 2/5/2565 BE.
//

import Foundation
import CryptoKit

public class CryptoKitClass {
    let privateKey : Curve25519.KeyAgreement.PrivateKey
    let publicKey :  Curve25519.KeyAgreement.PublicKey
    let symetricInit : SymmetricKey
    
    init() {
        privateKey = Curve25519.KeyAgreement.PrivateKey()
        publicKey = privateKey.publicKey
        let shareKey = try? privateKey.sharedSecretFromKeyAgreement(with: publicKey)
        symetricInit = (shareKey?.hkdfDerivedSymmetricKey(using: SHA256.self, salt: "My Key Agreement Salt".data(using: .utf8)!, sharedInfo: Data(), outputByteCount: 32))!
    }
    
    
   func convertStringToPrivateKey(_ key: String?) -> Curve25519.KeyAgreement.PrivateKey {
        let percentEndc = key?.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        guard let remove = try? percentEndc?.removingPercentEncoding! else { return Curve25519.KeyAgreement.PrivateKey() }
        guard let raw = try? Data(base64Encoded: remove) else { return Curve25519.KeyAgreement.PrivateKey() }
        guard let keyAns  = try? Curve25519.KeyAgreement.PrivateKey(rawRepresentation: raw) else { return Curve25519.KeyAgreement.PrivateKey() }
        return try! keyAns
    }
    
    func convertStringToPublicKey(_ key: String?) -> Curve25519.KeyAgreement.PublicKey
    {
        let percentEndc = key?.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        guard let remove = try? percentEndc?.removingPercentEncoding! else { return Curve25519.KeyAgreement.PrivateKey().publicKey }
        guard let raw = try? Data(base64Encoded: remove) else { return Curve25519.KeyAgreement.PrivateKey().publicKey }
        guard let keyAns  = try? Curve25519.KeyAgreement.PublicKey(rawRepresentation: raw) else { return Curve25519.KeyAgreement.PrivateKey().publicKey }
        return try! keyAns
    }
    
    func shareSymetric (_ a:Curve25519.KeyAgreement.PrivateKey, and b:Curve25519.KeyAgreement.PublicKey) -> SymmetricKey {
        let share = try? a.sharedSecretFromKeyAgreement(with: b)
        guard let sysmetric = share?.hkdfDerivedSymmetricKey(using: SHA256.self, salt: "My Key Agreement Salt".data(using: .utf8)!, sharedInfo: Data(), outputByteCount: 32) else {
            return self.symetricInit }
        return sysmetric
    }
    
    func endCryp (_ messg:String, and symmetricKey: SymmetricKey) -> String {
        let encryp = try? ChaChaPoly.seal((messg.data(using: .utf8)!), using: symmetricKey).combined
        return encryp?.base64EncodedString() ?? " "    }
    
    func deCrypt (_ cipher:String, and symmetricKey: SymmetricKey) -> String {
        print(cipher)
        guard let data = Data(base64Encoded: cipher) else {
            return "Could not decode"
        }
        guard let sealBox = try? ChaChaPoly.SealedBox(combined: data) else { return "Could not decode" }
        
        let text = try? ChaChaPoly.open(sealBox, using: symmetricKey)
    
        return String(data: text!, encoding: .utf8) ?? "Could not decode"
    }
}

