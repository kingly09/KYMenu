//
//  KYMenu.h
//  KYMenuDemo
//
//  Created by kingly on 16/10/2.
//  Copyright © 2016年 https://github.com/kingly09/KYMenu kingly inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface KYMenuItem : NSObject

@property (readwrite, nonatomic, strong) UIImage *image;
@property (readwrite, nonatomic, strong) NSString *title;
@property (readwrite, nonatomic, weak) id target;
@property (readwrite, nonatomic) SEL action;
@property (readwrite, nonatomic, strong) UIColor *foreColor;
@property (readwrite, nonatomic) NSTextAlignment alignment;

+ (instancetype) menuItem:(NSString *) title
                    image:(UIImage *) image
                   target:(id)target
                   action:(SEL) action;

@end

typedef struct{
    CGFloat R;
    CGFloat G;
    CGFloat B;

}Color;

typedef struct {
    CGFloat arrowSize;
    CGFloat marginXSpacing;
    CGFloat marginYSpacing;
    CGFloat intervalSpacing;
    CGFloat menuCornerRadius;
    Boolean maskToBackground;
    Boolean shadowOfMenu;
    Boolean hasSeperatorLine;
    Boolean seperatorLineHasInsets;
    Color textColor;
    Color menuBackgroundColor;

}OptionalConfiguration;

typedef enum {

    KYMenuViewArrowDirectionNone,
    KYMenuViewArrowDirectionUp,
    KYMenuViewArrowDirectionDown,
    KYMenuViewArrowDirectionLeft,
    KYMenuViewArrowDirectionRight,

} KYMenuViewArrowDirection;




@interface KYMenuView : UIView

@property (atomic, assign) OptionalConfiguration kYMenuViewOptions;

@end

@interface KYMenu : NSObject

+ (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
              menuItems:(NSArray *)menuItems
            withOptions:(OptionalConfiguration) options;

+ (void) dismissMenu;
//menuItem背景的颜色
+ (UIColor *) tintColor;
+ (void) setTintColor: (UIColor *) tintColor;
//menuItem字体
+ (UIFont *) titleFont;
+ (void) setTitleFont: (UIFont *) titleFont;
//menuItem字体颜色
+ (UIColor *) titleTextColor;
+ (void) setTitleTextColor: (UIColor *) titleTextColor;


@end