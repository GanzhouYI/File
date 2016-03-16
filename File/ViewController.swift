//
//  ViewController.swift
//  File
//
//  Created by 123 on 16/3/16.
//  Copyright © 2016年 123. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //返回document的全地址
    func dirDoc()->String{
        //三种方式 NSHomeDirectroy()表示沙箱Home目录地址
        //let path = NSHomeDirectory() + "/Documents"
        //let path = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents")
        
        //返回数组
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let path = paths[0]
        return path
        
    }
    
    //返回Library目录的全地址
    func dirLib()->String{
        //返回数组
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let path = paths[0]
        return path
    }
    
    //返回Caches目录的全地址
    func dirCaches()->String{
        //返回数组
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let path = paths[0]
        return path
    }
    
    
    //返回tmp目录的全地址
    func dirTmp()->String{
        return NSTemporaryDirectory()
    }
    
    //创建文件夹,在Document目录下创建,
    /*
     *dir:String 传一个参数名字给文件夹命名
     */
    func createDir(dir:String){
        let documentsPath = self.dirDoc()
        let testDirectory = documentsPath + "/" + dir
        
        //文件管理器对象
        let fileManager = NSFileManager.defaultManager()
        do{
            //attributes文件夹属性 只读,日期,拥有者 等等
            //withIntermediateDirectories创建目录时有没有中间目录，比如创建1/2/3，你创3就要先创1/2
            //createDir("test/1/2")  如果withIntermediateDirectories为false则创建失败,一个文件夹都没有
            try fileManager.createDirectoryAtPath(testDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        catch {
            
            print("文件夹创建失败")
        }
    }
    
    func createFile(filePath:String,fileName:String)
    {
        //文件管理器对象
        let fileManager = NSFileManager.defaultManager()
        let testPath = filePath.stringByAppendingString("/"+fileName)
        //let testPath = filePath+"/"+fileName同上
        
        ///contents里面的数据是什么
        let isExist = fileManager.fileExistsAtPath(testPath)
        if isExist{
            print("已存在")
        }else
        {
            print("不存在")
        }
        
        let success = fileManager.createFileAtPath(testPath, contents: nil, attributes: nil)
        if success{
            print("文件创建成功")
        }else{
            print("文件创建失败")
        }
        
    }
    
    
    //文件属性
    //filePath:String 文件夹名字
    //fileName:String 文件名
    func fileAttributes(filePath:String,fileName:String)
    {
        let fileManager = NSFileManager.defaultManager()
        var fileAttrs = [String:AnyObject]()
        do{
            fileAttrs = try fileManager.attributesOfItemAtPath(filePath + "/" + fileName)
            for key in fileAttrs.keys{
                print("key:\(key),value:\(fileAttrs[key]!)")
            }
        }catch{
            
        }
    }
    
    //删除文件
    func deleteFile(filePath:String,fileName:String)->Bool{
        let fileManager = NSFileManager.defaultManager()
        let testPath = filePath + "/" + fileName
        if fileManager.fileExistsAtPath(testPath)
        {
            do{
                try fileManager.removeItemAtPath(testPath)
                return true
            }
            catch{
                print("文件删除失败")
                return false
            }
        }else
        {
            print("文件不存在")
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //如果文件夹中有要创建的文件夹则不创建，也不报错！！！！！！！
        let home = NSHomeDirectory()
        print(home)
//
//        createDir("test/1/2")
//        createFile(self.dirDoc(), fileName: "hello.txt")
//        fileAttributes(self.dirDoc(), fileName: "hello.txt")
//        deleteFile(self.dirDoc(), fileName: "hello.txt")
        
        let product = Product()
        product.productId = 1
        product.name = "iPhone6s"
        product.price = 6000
        
        //1.文本文件的读写
        let fileName = "product.txt"
        let fileManager = NSFileManager.defaultManager()
        
        if fileManager.fileExistsAtPath(self.dirDoc()+"/"+fileName)
        {
            print("文件存在")
            do{
            let content = try String(contentsOfFile: self.dirDoc()+"/"+fileName)
            print(content)
            }catch{
                print("文件读取失败")
            }
        }
        else{
            print("文件不存在")
            let content = String(format: "%i,%@,%f", product.productId,product.name,product.price)
            do{
                //writeToFile文件覆盖重写
           try content.writeToFile(self.dirDoc()+"/"+fileName, atomically: true, encoding: NSUTF8StringEncoding)
            }catch _{}   //  _什么都不做
        }
        //2.plist文件的读写
        //Foundation框架下的NSNumber，NSString,NSArray，NSDictionary才可以写进plist文件中
            print("plist")
            //[]里面的类型不一样时，数组的类型是AnyObject类型
            let info = [product.name,product.price]
            let idStr = String(format: "%d", product.productId)//将整形转换成字符串
            let myDic:NSMutableDictionary = [idStr:info]
            
            let plistPath = self.dirDoc() + "/product.plist"
            if !fileManager.fileExistsAtPath(plistPath)
            {// 如果文件不存在
                myDic.writeToFile(plistPath, atomically: true)
            }else
            {// 读取plist文件
                let result = NSMutableDictionary(contentsOfFile: plistPath)
                print(result)
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

