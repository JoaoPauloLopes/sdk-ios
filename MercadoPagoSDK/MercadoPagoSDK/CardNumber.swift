//
//  CardNumber.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

public class CardNumber : Serializable {
    public var length : Int = 0
    public var validation : String!
    
    public class func fromJSON(json : NSDictionary) -> CardNumber {
        let cardNumber : CardNumber = CardNumber()
        cardNumber.validation = JSON(json["validation"]!).asString
		if json["length"] != nil && !(json["length"]! is NSNull) {
			cardNumber.length = JSON(json["length"]!).asInt!
		}
        return cardNumber
    }
    
}