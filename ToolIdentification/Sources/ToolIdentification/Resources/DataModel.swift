//
//  DataModel.swift
//  OklahomaToolIdentification
//
//  Created by Nickelfox on 01/03/24.
//

import Foundation

private struct UserDefaultConfigKey {
    static let areReportsEmpty = "areReportsEmpty"
}

class DataModel {
    static let shared = DataModel()
    private let userDefaults = UserDefaults.standard

    private init() {}
    
    @UserDefault(UserDefaultConfigKey.areReportsEmpty, true)
    public var areReportsEmpty: Bool
}

@propertyWrapper
public struct UserDefault<T> {
    
    let key: String
    let defaultValue: T
    
    init(_ key: String, _ defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        } set {
            UserDefaults.standard.set(newValue, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
}

extension UserDefault where T: ExpressibleByNilLiteral {
    init(_ key: String) {
        self.init(key, nil)
    }
}
