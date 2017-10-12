//
//  WKWebViewController.swift
//  GoldCalcutor
//
//  Created by Zhangguo Huang on 2017/10/12.
//  Copyright © 2017年 Joting. All rights reserved.
//

import UIKit
import WebKit
class WKWebViewController: UIViewController,WKScriptMessageHandler,WKNavigationDelegate {
    var wkWebView:WKWebView?;

    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.path(forResource: "index", ofType: ".html",
                                    inDirectory: "HTML5")
        let url = URL(fileURLWithPath:path!)
        let request = URLRequest(url:url)
        
        //创建供js调用的接口
        let theConfiguration = WKWebViewConfiguration()
        theConfiguration.userContentController.add(self, name: "interOp")
        
        //将浏览器视图全屏(在内容区域全屏,不占用顶端时间条)
        let frame = CGRect(x:0, y:20, width:UIScreen.main.bounds.width,
                           height:UIScreen.main.bounds.height)
        wkWebView = WKWebView(frame:frame, configuration: theConfiguration)
        //禁用页面在最顶端时下拉拖动效果
        wkWebView!.scrollView.bounces = false
        //右滑手势
        wkWebView!.allowsBackForwardNavigationGestures = true;
        //加载页面
        wkWebView!.load(request)
        self.view.addSubview(wkWebView!)
        
        // Do any additional setup after loading the view.
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        let sentData = message.body as! Dictionary<String,String>
        if (sentData["method"] == "submit") {
            let calculator = CalculatorModel(originSinglePrice: (sentData["originSinglePrice"]! as NSString).floatValue, amount: (sentData["amount"]! as NSString).floatValue, finalSinglePrice: (sentData["finalSinglePrice"]! as NSString).floatValue, increaseRate: (sentData["increaseRate"]! as NSString).floatValue,buyRate:(sentData["buyRate"]! as NSString).floatValue,saleRate:(sentData["saleRate"]! as NSString).floatValue,time:(sentData["time"]! as NSString).integerValue);
            let returnMessage:Dictionary<String,String> = ["income":String(calculator.calculateInterest()),"incomeRate":String(calculator.calculateRate()),"principal":String(calculator.calculatePrincipal()),"yearIncome":String(calculator.calculateYearInterset()),"yearRate":String(calculator.calculateYearRate())];
            print(returnMessage)
            let jsonData = try! JSONSerialization.data(withJSONObject: returnMessage, options: [])
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
            let alertMessage = "本金: " + returnMessage["principal"]! + "元\n" + "收益: " + returnMessage["income"]! + "元\t" + "收益率: " + returnMessage["incomeRate"]! + "%\n" + "年化收益: " +  returnMessage["yearIncome"]! + "元\t" + "年化收益率: " + returnMessage["yearRate"]! + "%";
            
            self.wkWebView!.evaluateJavaScript("calcuteResult('\(jsonString)')", completionHandler: { (Any, Error) in
                let alertViewController = UIAlertController(title:"计算结果",message:alertMessage,preferredStyle:.alert);
                let cancelAlert = UIAlertAction(title:"知了",style:.cancel,handler:nil);
                alertViewController.addAction(cancelAlert);
                self.present(alertViewController, animated: true, completion: nil)
            })
        }
    }
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        wkWebView?.reload();
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
