//
//  MockUtil.swift
//  Coronavirus AppTests
//
//  Created by Josip Juhasz on 19.07.2022..
//

import Foundation

struct MockUtils {
    
    static func decodeResource<T: Codable>(fileName: String) -> T? {
        do {
            guard let resourcePath = Bundle.main.url(forResource: fileName, withExtension: "json") else {
                return nil
            }
            let data = try Data(contentsOf: resourcePath)
            let parsedData = try JSONDecoder().decode(T.self, from: data)

            return parsedData
        }

        catch {
            return nil
        }
    }
}
