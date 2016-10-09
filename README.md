# KYMenu
KYmenu is the iOS application in the use of highly customized UI vertical
   pop-up menu.
# Installation
```
pod 'KYMenu', '~> 0.0.2'
```
# How to use
#### How to use **Object-C** to achieve the following:
1.basic parameter settings

```
menuArray = @[[KYMenuItem menuItem:@"发起多人聊天" image:[UIImage imageNamed:@"right_menu_multichat"] target:self action:@selector(onMenuItemAction:)],
                  [KYMenuItem menuItem:@"加好友" image:[UIImage imageNamed:@"right_menu_addFri"] target:self action:@selector(onMenuItemAction:)],
                  [KYMenuItem menuItem:@"扫一扫" image:[UIImage imageNamed:@"right_menu_QR"] target:self action:@selector(onMenuItemAction:)],
                  [KYMenuItem menuItem:@"面对面快传" image:[UIImage imageNamed:@"right_menu_facetoface"] target:self action:@selector(onMenuItemAction:)],
                  [KYMenuItem menuItem:@"付款" image:[UIImage imageNamed:@"right_menu_payMoney"] target:self action:@selector(onMenuItemAction:)]];
                  
```

2.extended parameter settings
                  
```
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
                      
```

3.display menu content

```
[KYMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuArray withOptions:optionals];
```

#### How to use **swift** to achieve the following:

1.basic parameter settings

```
let menuArray = [
                        KYMenuItem.init("创建讨论组", image: UIImage(named: "right_menu_multichat"), target: self, action: #selector(ViewController.toRespondMenu(_:))),
                         KYMenuItem.init("加好友", image: UIImage(named: "right_menu_addFri"), target: self, action: #selector(ViewController.toRespondMenu(_:))),
                         KYMenuItem.init("扫一扫", image: UIImage(named: "right_menu_QR"), target: self, action: #selector(ViewController.toRespondMenu(_:))),
                         KYMenuItem.init("面对面快传", image: UIImage(named: "right_menu_facetoface"), target: self, action: #selector(ViewController.toRespondMenu(_:))),
                         KYMenuItem.init("收钱", image: UIImage(named: "right_menu_payMoney"), target: self, action: #selector(ViewController.toRespondMenu(_:)))]
```

2.extended parameter settings

```
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
```

3.display menu content

```
KYMenu.showMenuInView(self.view, fromRect: sender.frame, menuItems: menuArray, withOptions: options)
```

# More parameter settings

### Set text font

```
 KYMenu.setTitleFont(UIFont(name: "HelveticaNeue", size: 14))
```

### Set menuItem font color

```
 KYMenu.setTitleTextColor(UIColor.grayColor());
```