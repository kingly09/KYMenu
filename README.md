# KYMenu
KYmenu is the iOS application in the use of highly customized UI vertical
   pop-up menu.

Support swift 3.


# Installation
```
pod 'KYMenu', '~> 0.0.4'
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


    optionals.arrowSize = 9;                    // arrow size
    optionals.marginXSpacing = 7;               // MenuItem left and right margins
    optionals.marginYSpacing = 9;               // MenuItem upper and lower margins
    optionals.intervalSpacing = 25;             // MenuItemImage and MenuItemTitle
    optionals.menuCornerRadius = 6.5 ;          // menu radius
    optionals.maskToBackground = YES ;          // Whether to add translucent mask on the cover in the original View
    optionals.shadowOfMenu     = NO  ;          // add menu is the shadow
    optionals.hasSeperatorLine = YES ;          // set split line
    optionals.seperatorLineHasInsets = NO ;     // Whether to leave the line on both sides of the Insets
    optionals.textColor = textColor;            // menuItem font color
    optionals.menuBackgroundColor = menuBackgroundColor; // The menu background

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
            arrowSize: 9,               // arrow size
            marginXSpacing: 7,          // MenuItem left and right margins
            marginYSpacing: 9,          // MenuItem upper and lower margins
            intervalSpacing: 25,        // MenuItemImage and MenuItemTitle
            menuCornerRadius: 6.5,      // menu radius
            maskToBackground: true,     // Whether to add translucent mask on the cover in the original View
            shadowOfMenu: false,        // add menu is the shadow
            hasSeperatorLine: true,     // set split line
            seperatorLineHasInsets: false,                // Whether to leave the line on both sides of the Insets
            textColor: Color(R: 0, G: 0, B: 0),           // menuItem font color
            menuBackgroundColor: Color(R: 1, G: 1, B: 1)  // The menu background

        )
```

3.display menu content

```
KYMenu.show(in: self.view, from: sender.frame, menuItems: menuArray, withOptions: options)
```

# More parameter settings

### Set text font

```
KYMenu.setTitleFont(UIFont(name: "HelveticaNeue", size: 14))
```

### Set menuItem font color

```
KYMenu.setTitleTextColor(UIColor.gray);
```
