//
//  CalculatorModel.swift
//  GoldCalcutor
//
//  Created by Zhangguo Huang on 2017/10/11.
//  Copyright © 2017年 Joting. All rights reserved.
//

import UIKit

class CalculatorModel: NSObject {
    //Gold
    var originSinglePrice:Float = 0
    var finalSinglePrice:Float = 0
    var amount:Float = 0
    var increaseRate:Float = 0
    var saleRate:Float = 0
    var buyRate:Float = 0
    var time:Int = 0
    //Salary
    var preTax:Float = 0
    
    var insurance:Float = 0
    
    
    var medicInsurance:Float = 0
    var eldInsurance:Float = 0
    var workInsurance:Float = 0
    var disabledInsurance:Float = 0
    var babyInsurance:Float = 0
    var houseFee:Float = 0
    var personalTax:Float = 0
    
    var income:Float = 0
    
//    let taxTable = [[0,0,0],[1455,0.03,0],[4155,0.1,105],[7755,0.2,555],[27255,0.25,1005],[41255,0.3,2755],[57505,0.35,5505],[Float.infinity,0.45,13505]]
    let taxTable = [[0,0,0],[1500,0.03,0],[4500,0.1,105],[9000,0.2,555],[35000,0.25,1005],[55000,0.3,2755],[80000,0.35,5505],[Float.infinity,0.45,13505]]

    
    
    
    
    
    
    //MARK: - Method
    static func calculate(message:Dictionary<String,String>,type:Int) -> Dictionary<String,String>{
        let calculator = CalculatorModel.init(message: message, type: type)

        return calculator.calculate(type: type)
    }

    //Private
    private func calculate(type:Int) -> Dictionary<String,String>{
        var returnMessage:Dictionary<String,String>
        if type == 0 {
            returnMessage = ["income":String(self.calculateInterest()),"incomeRate":String(self.calculateRate()),"principal":String(self.calculatePrincipal()),"yearIncome":String(self.calculateYearInterset()),"yearRate":String(self.calculateYearRate()),"tag":"gold"];
        }else{
            if preTax == 0{
                returnMessage = ["income":String(income),"preTax":String(self.calculatePreTax()),"aveRate":String(personalTax / preTax * 100),"personalTax":String(personalTax),"tag":"salary","insurance":String( insurance )]
            }else{
                income = self.calcutateIncome()
                returnMessage =  ["income":String( income ),"personalTax":String(personalTax),"preTax":String(preTax),"aveRate":String(personalTax / preTax * 100),"tag":"salary","insurance":String( insurance )]
            }
                
        }
        return returnMessage
    }
    
    //MARK:Salary
    private func calculatePreTax() -> Float{

        for array in taxTable {
            preTax = calculatePreTax(taxRate:array[1],const:array[2])
            if  preTax - insurance - 3500 < array[0] {
                personalTax = preTax - insurance - income
                break
            }
        }
        
        
        
        return preTax
    }
    
    private func calculatePreTax(taxRate:Float,const:Float) -> Float{
        return ((income + insurance) - (insurance + 3500) * taxRate - const) / (1-taxRate)
    }
    
    private func calcutateIncome() -> Float{
        return preTax - insurance - self.calcutateTax()
    }
    private func calcutateTax() -> Float{
        let tmp = preTax - insurance - 3500
        
        for array in taxTable {
            if tmp <= array[0] {
                personalTax = tmp * array[1] - array[2]
                break
            }
        }
        
        return personalTax
    }
    //MARK:Gold
    private func calculateRate() -> Float {
        return ((finalSinglePrice * amount * (1+increaseRate) - buyRate * originSinglePrice * amount - saleRate * finalSinglePrice * amount * (1+increaseRate))/(originSinglePrice * amount) - 1)*100;
    }
    private func calculateInterest() -> Float {
        return finalSinglePrice * amount * (1+increaseRate) - buyRate * originSinglePrice * amount - saleRate * finalSinglePrice * amount * (1+increaseRate) - originSinglePrice * amount;
    }
    private func calculatePrincipal() -> Float {
        return originSinglePrice * amount;
    }
    private func calculateYearRate() -> Float {
        return (self.calculateYearInterset() / (originSinglePrice * amount) * 100);
    }
    private func calculateYearInterset() -> Float {
        let yearInterest = Float(365/time) * (finalSinglePrice * amount * (1+increaseRate) - originSinglePrice * amount) - buyRate * originSinglePrice * amount - (Float(365/time) * (finalSinglePrice * amount * (1+increaseRate) - originSinglePrice * amount) + originSinglePrice * amount) * saleRate;//年化收益 = 年化收益总额-购买费率-卖出费率
        return yearInterest;
    };
//   convenience init(originSinglePrice:Float,amount:Float,finalSinglePrice:Float,increaseRate:Float,buyRate:Float,saleRate:Float,time:Int) {
//    self.init()
//    self.originSinglePrice = originSinglePrice;
//    self.finalSinglePrice = finalSinglePrice;
//    self.amount = amount;
//    self.increaseRate = increaseRate * Float( time / 365 ) / 100;
//    self.buyRate = buyRate / 100;
//    self.saleRate = saleRate / 100;
//    self.time = time;
//    }
    //MARK:init
    convenience init(message:Dictionary<String,String>,type:Int) {
        self.init()
        if type == 0 {
            originSinglePrice = (message["originSinglePrice"]! as NSString).floatValue
            finalSinglePrice = (message["finalSinglePrice"]! as NSString).floatValue
            amount = (message["amount"]! as NSString).floatValue
            time = (message["time"]! as NSString).integerValue
            increaseRate = (message["increaseRate"]! as NSString).floatValue * Float( time / 365 ) / 100
            buyRate = (message["buyRate"]! as NSString).floatValue / 100
            saleRate = (message["saleRate"]! as NSString).floatValue / 100
        }else{
            preTax = (message["preTax"]! as NSString).floatValue
            medicInsurance = (message["medicInsurance"]! as NSString).floatValue
            eldInsurance = (message["eldInsurance"]! as NSString).floatValue
            workInsurance = (message["workInsurance"]! as NSString).floatValue
            disabledInsurance = (message["disabledInsurance"]! as NSString).floatValue
            babyInsurance = (message["babyInsurance"]! as NSString).floatValue
            houseFee = (message["houseFee"]! as NSString).floatValue
            //personalTax = (message["personalFee"]! as NSString).floatValue
            income = (message["income"]! as NSString).floatValue
            
            insurance = medicInsurance + eldInsurance + workInsurance + disabledInsurance + babyInsurance + houseFee
        }

    }
}
