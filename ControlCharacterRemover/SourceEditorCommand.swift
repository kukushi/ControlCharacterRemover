//
//  SourceEditorCommand.swift
//  ControlCharacterRemover
//
//  Created by Xing He on 1/7/17.
//  Copyright © 2017 kukushi. All rights reserved.
//

import Foundation
import XcodeKit

extension Character {
    var asciiValue: UInt32? {
        return String(self).unicodeScalars.filter{$0.isASCII}.first?.value
    }
}


class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        removeControlCharacters(in: invocation.buffer)
        
        completionHandler(nil)
    }
    
    func removeControlCharacters(in buffer: XCSourceTextBuffer) {
        // Control characters list in https://en.wikipedia.org/wiki/Control_character
        let controlASCIICharacters = [0, 7, 8, 9, 10, 11, 12, 13, 26, 27, 127] as [UInt8]
        let controlCharacters = String(bytes: controlASCIICharacters, encoding: String.Encoding.ascii)!.characters
        
        var index = 0
        for line in buffer.lines {
            let content = line as! String
            let originCharacters = content.characters.filter {_ in 
                return true
            }
            
            let filteredCharaters = content.characters.filter {
                return !controlCharacters.contains($0)
            }
            
            if originCharacters != filteredCharaters {
                buffer.lines[index] = String(filteredCharaters)
            }
            
            index += 1;
        }
    }
    
}
