//
//  TableClient.swift
//  On the Map
//
//  Created by Jaskirat Singh on 10/02/18.
//  Copyright © 2018 jassie. All rights reserved.
//

import Foundation
import UIKit

struct consturl
{
        static let studenturl = "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt"
}

struct constkey
{
    static let pinAdd = "pin added"
    static let baseStudentLocationURL = "https://parse.udacity.com/parse/classes/StudentLocation"
    static let X_Parse_API = "X-Parse-REST-API-Key"
    static let parseAppID = "X-Parse-Application-Id"
}

struct constValue
{
    static let X_Parse_API = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    static let parseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
}

struct parameterKeys
{
    static let Where = "where"
    static let uniqueKey = "uniqueKey"
}
