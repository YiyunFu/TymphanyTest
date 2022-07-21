//
//  String+Extension.swift
//  TymphanyTest
//
//  Created by 傅意芸 on 2022/7/21.
//

import Foundation

extension String {
    func splitByCount(_ count: Int) -> [String] {
        var returnArray = [String]()
        var string = ""
        let array = Array(self)
        for i in 0..<array.count {
            string += String(array[i])
            
            if (i+1)%count == 0 {
                returnArray.append(string)
                string = ""
            }
        }
        return returnArray
    }
    
    // Hexadecimal to decimal
    func hexToDecimal() -> String {
        guard let int = Int(self, radix: 16) else { return "" }
        let d4 = int
        return String(d4)
    }
    
    // Hexadecimal to binary
    func hexToBinary() -> String {
        guard let int = Int(self, radix: 16) else { return "" }
        let b4 = String(int, radix: 2)
        return b4
    }
}
