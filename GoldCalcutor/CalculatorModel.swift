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
    var time:Int;
    
    func calculateRate() -> Float {
        return ((finalSinglePrice * amount * (1+increaseRate) - buyRate * originSinglePrice * amount - saleRate * finalSinglePrice * amount * (1+increaseRate))/(originSinglePrice * amount) - 1)*100;
    }
    func calculateInterest() -> Float {
        return finalSinglePrice * amount * (1+increaseRate) - buyRate * originSinglePrice * amount - saleRate * finalSinglePrice * amount * (1+increaseRate) - originSinglePrice * amount;
    }
    func calculatePrincipal() -> Float {
        return originSinglePrice * amount;
    }
    func calculateYearRate() -> Float {
        return (self.calculateYearInterset() / (originSinglePrice * amount) * 100);
    }
    func calculateYearInterset() -> Float {
        let yearInterest = Float(365/time) * (finalSinglePrice * amount * (1+increaseRate) - originSinglePrice * amount) - buyRate * originSinglePrice * amount - (Float(365/time) * (finalSinglePrice * amount * (1+increaseRate) - originSinglePrice * amount) + originSinglePrice * amount) * saleRate;//年化收益 = 年化收益总额-购买费率-卖出费率
        return yearInterest;
    }; init(originSinglePrice:Float,amount:Float,finalSinglePrice:Float,increaseRate:Float,buyRate:Float,saleRate:Float,time:Int) {
        self.originSinglePrice = originSinglePrice;
        self.finalSinglePrice = finalSinglePrice;
        self.amount = amount;
        self.increaseRate = increaseRate * Float( time / 365 ) / 100;
        self.buyRate = buyRate / 100;
        self.saleRate = saleRate / 100;
        self.time = time;
    }
}
