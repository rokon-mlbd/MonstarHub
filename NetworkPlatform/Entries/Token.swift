//
//  Token.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Domain
import Foundation
import ObjectMapper

enum TokenType {
    case basic(token: String)
    case personal(token: String)
    case oAuth(token: String)
    case unauthorized

    var description: String {
        switch self {
        case .basic: return "basic"
        case .personal: return "personal"
        case .oAuth: return "OAuth"
        case .unauthorized: return "unauthorized"
        }
    }
}

struct Token: Mappable {

    var isValid = false

    // Basic
    var basicToken: String?

    // Personal Access Token
    var personalToken: String?

    // OAuth2
    var accessToken: String?
    var tokenType: String?
    var scope: String?

    init?(map: Map) {}
    init() {}

    init(basicToken: String) {
        self.basicToken = basicToken
    }

    init(personalToken: String) {
        self.personalToken = personalToken
    }

    mutating func mapping(map: Map) {
        isValid <- map["valid"]
        basicToken <- map["basic_token"]
        personalToken <- map["personal_token"]
        accessToken <- map["access_token"]
        tokenType <- map["token_type"]
        scope <- map["scope"]
    }

    func type() -> TokenType {
        if let token = basicToken {
            return .basic(token: token)
        }
        if let token = personalToken {
            return .personal(token: token)
        }
        if let token = accessToken {
            return .oAuth(token: token)
        }
        return .unauthorized
    }
}

extension Token: DomainConvertibleType {
    var asDomain: Domain.Token {
        return Domain.Token(isValid: isValid,
                            basicToken: basicToken,
                            personalToken: personalToken,
                            accessToken: accessToken,
                            tokenType: tokenType,
                            scope: scope)
    }
}
