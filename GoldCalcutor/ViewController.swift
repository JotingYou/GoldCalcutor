//
//  ViewController.swift
//  GoldCalcutor
//
//  Created by Zhangguo Huang on 2017/10/11.
//  Copyright © 2017年 Joting. All rights reserved.
//

import UIKit
class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var principalLabel: UILabel!
    @IBOutlet weak var incomeRateLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var goldIncreaseRate: UITextField!
    @IBOutlet weak var finalPrice: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var originPrice: UITextField!
    
    @IBOutlet weak var saleRateText: UITextField!
    @IBOutlet weak var bugRateText: UITextField!
    
    lazy var textFields:Array<UITextField> = {
        print("lazy load");
        var tmp:Array<UITextField>;
        tmp = [self.originPrice,self.amount,self.finalPrice,self.goldIncreaseRate,self.bugRateText,self.saleRateText];
        return tmp
        
    }();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for textField in self.textFields {
            textField.delegate = self;
        }
        self.originPrice.becomeFirstResponder();
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func calculate(_: Any) {
        let calculator = CalculatorModel(originSinglePrice: (self.originPrice.text! as NSString).floatValue, amount: (self.amount.text! as NSString).floatValue, finalSinglePrice: (self.finalPrice.text! as NSString).floatValue, increaseRate: (self.goldIncreaseRate.text! as NSString).floatValue,buyRate:(self.bugRateText.text! as NSString).floatValue,saleRate:(self.saleRateText.text! as NSString).floatValue);
        self.incomeLabel.text = String(calculator.calculateInterest()) + " 元";
        self.incomeRateLabel.text = String(calculator.calculateRate()) + "%";
        self.principalLabel.text = String(calculator.calculatePrincipal()) + " 元";
        self.saleRateText.endEditing(true);
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 5 {
            self.saleRateText.endEditing(true);
            self.calculate(0);
        }else{
            self.textFields[textField.tag+1].becomeFirstResponder();
        }
        return true;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

