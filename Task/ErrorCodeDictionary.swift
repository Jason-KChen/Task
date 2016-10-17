//
//  ErrorCodeDictionary.swift
//  Task
//
//  Created by Kun Chen on 10/16/16.
//  Copyright © 2016 Kun Chen. All rights reserved.
//

import Foundation

class ErrorCodeDictionary {
    
    private static let dictionaryForErrorCodes: Dictionary<Int, String> = [1:"Missing a Task Name😖\n",
                                                                           2:"What about the type?🤔\n",
                                                                           3:"How often should I remind you?🙃\n",
                                                                           4:"Due Date is invalid😤\n"]
    
    //a static function that gets the error message by error code
    static func getErrorMessageByErrorCode(errorCode: Int) -> String {
        
        if let errorMessage = dictionaryForErrorCodes[errorCode] {
            return errorMessage
        } else {
            return ""
        }

    }
    
}
