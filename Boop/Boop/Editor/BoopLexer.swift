//
//  BoopLexer.swift
//  Boop
//
//  Created by Ivan on 1/26/19.
//  Copyright © 2019 OKatBest. All rights reserved.
//

import Cocoa
import SavannaKit

class BoopLexer: RegexLexer {
    
    func generators(source: String) -> [TokenGenerator] {
        
        let number = #"\b(?:0x[a-f0-9]+|(?:\d(?:_\d+)*\d*(?:\.\d*)?|\.\d\+)(?:e[+\-]?\d+)?)\b"#
        
        
        var generators = [TokenGenerator?]()
        
        generators.append(regexToken(.number, number))
        
        // Comments
        
        generators.append(regexToken(.comment, #"(?=(\/\/.*))"#))
        
        generators.append(regexToken(.comment, #"(?=(\/\*[\s\S]*?(?:\*\/|$)))"#, options: [.dotMatchesLineSeparators], greedy: true))
        
        generators.append(regexToken(.comment, #"<!--[\s\S]*?-->"#, options: [.dotMatchesLineSeparators, .caseInsensitive], greedy: true))
        
      
        
        
        return generators.compactMap( { $0 })
    }
    
    func regexToken(_ type: BoopToken.TokenType, _ pattern:String, options: NSRegularExpression.Options = .caseInsensitive, greedy: Bool = false) -> TokenGenerator? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return nil
        }
        let generator = RegexTokenGenerator(regularExpression: regex, tokenTransformer: { (range) -> Token in
            return BoopToken(type: type, range: range, greedy: greedy)
        })
        return TokenGenerator.regex(generator)
    }
    
}
