//
//  ViewController.m
//  KYMenuDemo
//
//  Created by kingly on 16/10/2.
//  Copyright © 2016年 https://github.com/kingly09/KYMenu kingly inc. All rights reserved.
//

#import "ViewController.h"
#import "KYMenu.h"


@interface ViewController (){

    NSArray *menuArray;

    OptionalConfiguration  optionals;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    menuArray = @[[KYMenuItem menuItem:@"发起多人聊天" image:[UIImage imageNamed:@"right_menu_multichat"] target:self action:@selector(onMenuItemAction:)],
                  [KYMenuItem menuItem:@"加好友" image:[UIImage imageNamed:@"right_menu_addFri"] target:self action:@selector(onMenuItemAction:)],
                  [KYMenuItem menuItem:@"扫一扫" image:[UIImage imageNamed:@"right_menu_QR"] target:self action:@selector(onMenuItemAction:)],
                  [KYMenuItem menuItem:@"面对面快传" image:[UIImage imageNamed:@"right_menu_facetoface"] target:self action:@selector(onMenuItemAction:)],
                  [KYMenuItem menuItem:@"付款" image:[UIImage imageNamed:@"right_menu_payMoney"] target:self action:@selector(onMenuItemAction:)]];


    Color textColor;
    textColor.R = 0;
    textColor.G = 0;
    textColor.B = 0;

    Color menuBackgroundColor;
    menuBackgroundColor.R = 1;
    menuBackgroundColor.G = 1;
    menuBackgroundColor.B = 1;


    optionals.arrowSize = 9;                    //指示箭头大小
    optionals.marginXSpacing = 7;               //MenuItem左右边距
    optionals.marginYSpacing = 9;               //MenuItem上下边距
    optionals.intervalSpacing = 25;             //MenuItemImage与MenuItemTitle的间距
    optionals.menuCornerRadius = 6.5 ;          //菜单圆角半径
    optionals.maskToBackground = YES ;          //是否添加覆盖在原View上的半透明遮罩
    optionals.shadowOfMenu     = NO  ;          //是否添加菜单阴影
    optionals.hasSeperatorLine = YES ;          //是否设置分割线
    optionals.seperatorLineHasInsets = NO ;     //是否在分割线两侧留下Insets
    optionals.textColor = textColor;            //menuItem字体颜色
    optionals.menuBackgroundColor = menuBackgroundColor; //菜单的底色
    

}

- (IBAction)onLeftBtn:(UIButton *)sender {

    CGRect myframe = sender.frame;
    myframe.origin.y += 22;
    myframe.size.height = 44;

    [KYMenu showMenuInView:self.view
                  fromRect:myframe
                 menuItems:menuArray withOptions:optionals];

}

- (IBAction)onAddContactBtn:(UIButton *)sender {

    CGRect myframe = sender.frame;
    myframe.origin.y = 44;

    [KYMenu showMenuInView:self.view
                  fromRect:myframe
                 menuItems:menuArray withOptions:optionals];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onMenuItemAction:(id)sender{

}

- (IBAction)onTestBtn:(UIButton *)sender {

  
    [KYMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuArray withOptions:optionals];
}

@end
