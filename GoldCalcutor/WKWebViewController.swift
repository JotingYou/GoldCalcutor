//
//  WKWebViewController.swift
//  GoldCalcutor
//
//  Created by Zhangguo Huang on 2017/10/12.
//  Copyright © 2017年 Joting. All rights reserved.
//

import UIKit
import WebKit
class WKWebViewController: UIViewController,WKScriptMessageHandler,WKNavigationDelegate{
    var type = 0
    
    var wkWebView:WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.splitViewController?.preferredDisplayMode = .primaryHidden
        self.splitViewController?.presentsWithGesture = true
        //网页路径
        var path = Bundle.main.path(forResource: "gold", ofType: ".html",
                                    inDirectory: "HTML5")
        if type == 1 {
            path = Bundle.main.path(forResource: "salary", ofType: ".html",
                                        inDirectory: "HTML5")
            self.title = "工资计算器"
        }
        let url = URL(fileURLWithPath:path!)
        let request = URLRequest(url:url)
        
        //创建供js调用的接口
        let theConfiguration = WKWebViewConfiguration()
        theConfiguration.userContentController.add(self, name: "interGold")
        theConfiguration.userContentController.add(self, name: "interSalary")
        //将浏览器视图全屏(在内容区域全屏,不占用顶端时间条)
        wkWebView = WKWebView(frame:self.view.frame, configuration: theConfiguration)
        //禁用页面在最顶端时下拉拖动效果
        wkWebView!.scrollView.bounces = false
        //右滑手势
        wkWebView!.allowsBackForwardNavigationGestures = true;
        //加载页面
        wkWebView!.load(request)
        self.addSubviewWithEqualConstraints(view: wkWebView!)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "菜单", style: .plain, target: self, action:#selector(itemAction) )
        // Do any additional setup after loading the view.
    }
    @objc func itemAction(sender:Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
 //       print(message.body)
        //将接收的数据转为字典
        let sentData = message.body as! Dictionary<String,String>
        if (sentData["method"] == "submit") {
            
            //生成返回数据

             let returnMessage:Dictionary<String,String> = CalculatorModel.calculate(message: sentData, type: type)
            print(returnMessage)
            //将数据转为JSON
            let jsonData = try! JSONSerialization.data(withJSONObject: returnMessage, options: [])
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
            print(jsonString)
            //创建弹出窗口信息
            var alertMessage:String
            if type == 0{
                alertMessage = "本金: " + returnMessage["principal"]! + "元\n" + "收益: " + returnMessage["income"]! + "元\t" + "收益率: " + returnMessage["incomeRate"]! + "%\n" + "年化收益: " +  returnMessage["yearIncome"]! + "元\t" + "年化收益率: " + returnMessage["yearRate"]! + "%";
            }else{
                alertMessage = "税前工资: " + returnMessage["preTax"]! + "元\n" + "五险一金: " + returnMessage["insurance"]! + "元\n" + "个人所得税: " + returnMessage["personalTax"]! + "元\t" + "税率: " +  returnMessage["aveRate"]! + "%\n" + "实发工资: " + returnMessage["income"]! + "元";
            }
            //弹出提醒框
            let alertViewController = UIAlertController(title:"计算结果",message:alertMessage,preferredStyle:.alert);
            let cancelAlert = UIAlertAction(title:"知了",style:.cancel,handler:nil);
            alertViewController.addAction(cancelAlert);
            DispatchQueue.main.async {
                self.present(alertViewController, animated: true, completion: nil)
            }

            //调用JS
            self.wkWebView!.evaluateJavaScript("showResult('\(jsonString)')", completionHandler: nil)
        }
    }
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        //当网页崩溃时重新加载
        DispatchQueue.main.async {
            self.wkWebView?.reload();
        }
    }
    func addSubviewWithEqualConstraints(view:UIView){
        self.view.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraint1 = NSLayoutConstraint.init(item: view, attribute: .top, relatedBy: .equal, toItem: view.superview, attribute: .top, multiplier: 1, constant: 0)
        let constraint2 = NSLayoutConstraint.init(item: view, attribute: .bottom, relatedBy: .equal, toItem: view.superview, attribute: .bottom, multiplier: 1, constant: 0)
        let constraint3 = NSLayoutConstraint.init(item: view, attribute: .leading, relatedBy: .equal, toItem: view.superview, attribute: .leading, multiplier: 1, constant: 0)
        let constraint4 = NSLayoutConstraint.init(item: view, attribute: .trailing, relatedBy: .equal, toItem: view.superview, attribute: .trailing, multiplier: 1, constant: 0)
        self.view.addConstraints([constraint1,constraint2,constraint3,constraint4])
        
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
