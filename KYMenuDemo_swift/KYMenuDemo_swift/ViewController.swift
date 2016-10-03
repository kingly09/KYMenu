//
//  ViewController.swift
//  KYMenuDemo_swift
//
//  Created by kingly on 16/10/3.
//  Copyright © 2016年 https://github.com/kingly09/KYMenu kingly inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onClickButton(sender: AnyObject) {
        //设置内容数据
        let menuArray = [
                        KYMenuItem.init("创建讨论组", image: UIImage(named: "right_menu_multichat"), target: self, action: #selector(ViewController.toRespondMenu(_:))),
                         KYMenuItem.init("加好友", image: UIImage(named: "right_menu_addFri"), target: self, action: #selector(ViewController.toRespondMenu(_:))),
                         KYMenuItem.init("扫一扫", image: UIImage(named: "right_menu_QR"), target: self, action: #selector(ViewController.toRespondMenu(_:))),
                         KYMenuItem.init("面对面快传", image: UIImage(named: "right_menu_facetoface"), target: self, action: #selector(ViewController.toRespondMenu(_:))),
                         KYMenuItem.init("收钱", image: UIImage(named: "right_menu_payMoney"), target: self, action: #selector(ViewController.toRespondMenu(_:)))]
        //拓展配置
        let options = OptionalConfiguration(
            arrowSize: 9,               //指示箭头大小
            marginXSpacing: 7,          //MenuItem左右边距
            marginYSpacing: 9,          //MenuItem上下边距
            intervalSpacing: 25,        //MenuItemImage与MenuItemTitle的间距
            menuCornerRadius: 6.5,      //菜单圆角半径
            maskToBackground: true,     //是否添加覆盖在原View上的半透明遮罩
            shadowOfMenu: false,        //是否添加菜单阴影
            hasSeperatorLine: true,     //是否设置分割线
            seperatorLineHasInsets: false,                //是否在分割线两侧留下Insets
            textColor: Color(R: 0, G: 0, B: 0),           //menuItem字体颜色
            menuBackgroundColor: Color(R: 1, G: 1, B: 1)  //菜单的底色
        )
        //设置文本字体
        KYMenu.setTitleFont(UIFont(name: "HelveticaNeue", size: 14))
        //menuItem字体颜色
        KYMenu.setTitleTextColor(UIColor.grayColor());
        //菜单展示
        KYMenu.showMenuInView(self.view, fromRect: sender.frame, menuItems: menuArray, withOptions: options)
    }

    func toRespondMenu(sender : AnyObject) {

    }
}

