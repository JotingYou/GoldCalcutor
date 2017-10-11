//
//  CalculatorModel.swift
//  GoldCalcutor
//
//  Created by Zhangguo Huang on 2017/10/11.
//  Copyright © 2017年 Joting. All rights reserved.
//

import UIKit

class CalculatorModel: NSObject {
    var originSinglePrice:Float;
    var finalSinglePrice:Float;
    var amount:Float;
    var increaseRate:Float;
    var saleRate:Float;
    var buyRate:Float;
    
    
    func calculateRate() -> Float {
        return ((finalSinglePrice * amount * (1+increaseRate/100.0) - buyRate/100 * originSinglePrice * amount - saleRate/100 * finalSinglePrice * amount * (1+increaseRate/100.0))/(originSinglePrice * amount) - 1)*100;
    }
    func calculateInterest() -> Float {
        return finalSinglePrice * amount * (1+increaseRate/100.0) - buyRate/100 * originSinglePrice * amount - saleRate/100 * finalSinglePrice * amount * (1+increaseRate/100.0) - originSinglePrice * amount;
    }
    func calculatePrincipal() -> Float {
        return originSinglePrice * amount;
    }
    init(originSinglePrice:Float,amount:Float,finalSinglePrice:Float,increaseRate:Float,buyRate:Float,saleRate:Float) {
        self.originSinglePrice = originSinglePrice;
        self.finalSinglePrice = finalSinglePrice;
        self.amount = amount;
        self.increaseRate = increaseRate;
        self.buyRate = buyRate;
        self.saleRate = saleRate;
    }
}
