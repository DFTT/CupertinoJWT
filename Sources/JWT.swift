//
//  JWT.swift
//  CupertinoJWT
//
//  Created by Ethanhuang on 2018/8/23.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public struct JWT: Codable {
    public struct Header: Codable {
        /// alg
        public let algorithm: String = "ES256"
        public let tokenType: String = "JWT"

        /// kid
        public let keyID: String

        enum CodingKeys: String, CodingKey {
            case algorithm = "alg"
            case tokenType = "typ"
            case keyID = "kid"
        }

        public init(keyID: String) {
            self.keyID = keyID
        }
    }

    public struct Payload: Codable {
        /// iss
        public let teamID: String

        /// iat (s)
        public let issueDate: Int = Int(Date().timeIntervalSince1970.rounded())

        /// exp (s)
        public let expireDate: Int

        /// aud
        public let audience: String = "appstoreconnect-v1"

        /// bid
        public let bundleID: String

        enum CodingKeys: String, CodingKey {
            case teamID = "iss"
            case issueDate = "iat"
            case expireDate = "exp"
            case audience = "aud"
            case bundleID = "bid"
        }

        public init(teamID: String, bundleID: String) {
            self.teamID = teamID
            self.expireDate = issueDate + 3600 // 最多60分钟
            self.bundleID = bundleID
        }
    }

    private let header: Header
    private let payload: Payload

    public init(headr: Header, payload: Payload) {
        self.header = headr
        self.payload = payload
    }

    /// Combine header and payload as digest for signing.
    public func digest() throws -> String {
        let headerString = try JSONEncoder().encode(header.self).base64EncodedURLString()
        let payloadString = try JSONEncoder().encode(payload.self).base64EncodedURLString()
        return "\(headerString).\(payloadString)"
    }

    /// Sign digest with P8(PEM) string. Use the result in your request authorization header.
    public func sign(with p8: P8) throws -> String {
        let digest = try self.digest()

        let signature = try p8.toASN1()
            .toECKeyData()
            .toPrivateKey()
            .es256Sign(digest: digest)

        let token = "\(digest).\(signature)"
        return token
    }
}
