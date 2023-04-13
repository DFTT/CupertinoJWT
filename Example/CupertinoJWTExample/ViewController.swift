//
//  ViewController.swift
//  CupertinoJWTExample
//
//  Created by Ethanhuang on 2018/12/17.
//  Copyright © 2018 Elaborapp Co., Ltd. All rights reserved.
//

import CupertinoJWT
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let keyID = "OIX79H472E" // Get from https://developer.apple.com/account/ios/authkey/
        let teamID = "TZD0DM3IU4" // Get from https://developer.apple.com/account/#/membership/
        let bundleID = "com.xx.xxx" // 包名

        createToken(keyID: keyID, teamID: teamID, bundleID: bundleID)
    }

    func createToken(keyID: String, teamID: String, bundleID: String) {
        // Get content of the .p8 file
        let p8 = """
        -----BEGIN PRIVATE KEY-----
        MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgGH2MylyZjjRdauTk
        xxXW6p8VSHqIeVRRKSJPg1xn6+KgCgYIKoZIzj0DAQehRANCAAS/mNzQ7aBbIBr3
        DiHiJGIDEzi6+q3mmyhH6ZWQWFdFei2qgdyM1V6qtRPVq+yHBNSBebbR4noE/IYO
        hMdWYrKn
        -----END PRIVATE KEY-----
        """

        // Assign developer information and token expiration setting
        let jwt = JWT(headr: JWT.Header(keyID: keyID),
                      payload: JWT.Payload(teamID: teamID, bundleID: bundleID))
        do {
            let token = try jwt.sign(with: p8)
            // Use the token in the authorization header in your requests connecting to Apple’s API server.
            // e.g. urlRequest.addValue(_ value: "bearer \(token)", forHTTPHeaderField field: "authorization")
            print("Generated JWT: \(token)")
        } catch {
            // Handle error
        }
    }
}
