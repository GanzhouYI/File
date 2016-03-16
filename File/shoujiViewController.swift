//
//  shoujiViewController.swift
//  File
//
//  Created by 123 on 16/3/16.
//  Copyright © 2016年 123. All rights reserved.
//

import UIKit

class shoujiViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    
    @IBOutlet weak var email: UITextField!
    
    
    @IBOutlet weak var resultView: UITextView!
    
    var _fileManager = ViewController()
    
    
    //存储
    @IBAction func store(sender: UIButton) {
        //提取信息
        let csvLine = String(format: "%@,%@,%@\n", self.firstName.text!,self.lastName.text!,self.email.text!)
        let documentPath = _fileManager.dirDoc()
        let surveyFile = documentPath+"/survey.csv"
        
        let manager = NSFileManager.defaultManager()
        if !manager.fileExistsAtPath(surveyFile){
            //如果文件不在
            manager.createFileAtPath(surveyFile, contents: nil, attributes: nil)
        }
        //文件处理器
        let fileHandler = NSFileHandle(forUpdatingAtPath: surveyFile)//更新已有的文件
        fileHandler?.seekToEndOfFile()//将文件指针放到末尾再写
        fileHandler?.writeData(csvLine.dataUsingEncoding(NSUTF8StringEncoding)!)
        fileHandler?.closeFile()
        
        self.firstName.text = ""
        self.lastName.text = ""
        self.email.text = ""
    }
    
    
    //显示信息
    @IBAction func showResult(sender: UIButton) {
        let documentPath = _fileManager.dirDoc()
        let surveyFile = documentPath+"/survey.csv"
        let manager = NSFileManager.defaultManager()
        if manager.fileExistsAtPath(surveyFile){
            //如果文件存在
            //文件处理器
            let fileHandler = NSFileHandle(forReadingAtPath: surveyFile)//更新已有的文件
            let data = fileHandler?.availableData
            self.resultView.text = String(data:data!,encoding: NSUTF8StringEncoding)
            fileHandler?.closeFile()
        }
        
        
    }
    
    //撤销键盘,来源协议
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.firstName.resignFirstResponder()
        self.lastName.resignFirstResponder()
        self.email.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstName.delegate = self
        self.lastName.delegate = self
        self.email.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
