//
//  KYMenu.m
//  KYMenuDemo
//
//  Created by kingly on 16/10/2.
//  Copyright © 2016年 https://github.com/kingly09/KYMenu kingly inc. All rights reserved.
//

#import "KYMenu.h"
#import <QuartzCore/QuartzCore.h>


#pragma mark - KYMenuOverlay

@interface KYMenuOverlay : UIView
@end

@implementation KYMenuOverlay

- (id)initWithFrame:(CGRect)frame maskSetting:(Boolean)mask
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        if (mask) {
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.17];
        } else {
            self.backgroundColor = [UIColor clearColor];
        }
        
        UITapGestureRecognizer *gestureRecognizer;
        gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(singleTap:)];
        
        [self addGestureRecognizer:gestureRecognizer];
    }
    return self;
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer
{
    for (UIView *v in self.subviews) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([v isKindOfClass:[KYMenuView class]] && [v respondsToSelector:@selector(dismissMenu:)]) {
            [v performSelector:@selector(dismissMenu:) withObject:@(YES)];
        }
#pragma clang diagnostic pop
    }
}

@end

#pragma mark - KYMenuItem

@implementation KYMenuItem

+ (instancetype) menuItem:(NSString *) title
                    image:(UIImage *) image
                   target:(id)target
                   action:(SEL) action
{
    return [[KYMenuItem alloc] init:title
                              image:image
                             target:target
                             action:action];
}

- (id) init:(NSString *) title
      image:(UIImage *) image
     target:(id)target
     action:(SEL) action
{
    NSParameterAssert(title.length || image);
    
    self = [super init];
    if (self) {
        
        _title = title;
        _image = image;
        _target = target;
        _action = action;
    }
    return self;
}

- (BOOL) enabled
{
    return _target != nil && _action != NULL;
}

- (void) performAction
{
    __strong id target = self.target;
    
    if (target && [target respondsToSelector:_action]) {
        
        [target performSelectorOnMainThread:_action withObject:self waitUntilDone:YES];
    }
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"<%@ #%p %@>", [self class], self, _title];
}

@end

#pragma mark - KYMenuView

@implementation KYMenuView {
    
    KYMenuViewArrowDirection    _arrowDirection;
    CGFloat                     _arrowPosition;
    UIView                      *_contentView;
    NSArray                     *_menuItems;
}

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if(self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.opaque = YES;
        self.alpha = 0;
        
    }
    
    return self;
}


- (void) setupFrameInView:(UIView *)view
                 fromRect:(CGRect)fromRect
{
    const CGSize contentSize = _contentView.frame.size;
    
    const CGFloat outerWidth = view.bounds.size.width;
    const CGFloat outerHeight = view.bounds.size.height;
    
    const CGFloat rectX0 = fromRect.origin.x;
    const CGFloat rectX1 = fromRect.origin.x + fromRect.size.width;
    const CGFloat rectXM = fromRect.origin.x + fromRect.size.width * 0.5f;
    const CGFloat rectY0 = fromRect.origin.y;
    const CGFloat rectY1 = fromRect.origin.y + fromRect.size.height;
    const CGFloat rectYM = fromRect.origin.y + fromRect.size.height * 0.5f;;
    
    const CGFloat widthPlusArrow = contentSize.width + self.kYMenuViewOptions.arrowSize;
    const CGFloat heightPlusArrow = contentSize.height + self.kYMenuViewOptions.arrowSize;
    const CGFloat widthHalf = contentSize.width * 0.5f;
    const CGFloat heightHalf = contentSize.height * 0.5f;
    
    const CGFloat kMargin = 5.f;
    
    //此处设置阴影
    if (self.kYMenuViewOptions.shadowOfMenu) {
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowOffset = CGSizeMake(2, 2);
        self.layer.shadowRadius = 2;
        
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
    }
    
    // 设置外边框阴影
    if (self.kYMenuViewOptions.shadowOfMenuOutside) {
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 4;
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
    }
    
    
    if (heightPlusArrow < (outerHeight - rectY1)) {
        
        _arrowDirection = KYMenuViewArrowDirectionUp;
        CGPoint point = (CGPoint){
            rectXM - widthHalf,
            rectY1
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        _arrowPosition = rectXM - point.x;
        //_arrowPosition = MAX(16, MIN(_arrowPosition, contentSize.width - 16));
        _contentView.frame = (CGRect){0, self.kYMenuViewOptions.arrowSize, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width,
            contentSize.height + self.kYMenuViewOptions.arrowSize
        };
        
    } else if (heightPlusArrow < rectY0) {
        
        _arrowDirection = KYMenuViewArrowDirectionDown;
        CGPoint point = (CGPoint){
            rectXM - widthHalf,
            rectY0 - heightPlusArrow
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        _arrowPosition = rectXM - point.x;
        _contentView.frame = (CGRect){CGPointZero, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width,
            contentSize.height + self.kYMenuViewOptions.arrowSize
        };
        
    } else if (widthPlusArrow < (outerWidth - rectX1)) {
        
        _arrowDirection = KYMenuViewArrowDirectionLeft;
        CGPoint point = (CGPoint){
            rectX1,
            rectYM - heightHalf
        };
        
        if (point.y < kMargin)
            point.y = kMargin;
        
        if ((point.y + contentSize.height + kMargin) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;
        
        _arrowPosition = rectYM - point.y;
        _contentView.frame = (CGRect){self.kYMenuViewOptions.arrowSize, 0, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width + self.kYMenuViewOptions.arrowSize,
            contentSize.height
        };
        
    } else if (widthPlusArrow < rectX0) {
        
        _arrowDirection = KYMenuViewArrowDirectionRight;
        CGPoint point = (CGPoint){
            rectX0 - widthPlusArrow,
            rectYM - heightHalf
        };
        
        if (point.y < kMargin)
            point.y = kMargin;
        
        if ((point.y + contentSize.height + 5) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;
        
        _arrowPosition = rectYM - point.y;
        _contentView.frame = (CGRect){CGPointZero, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width  + self.kYMenuViewOptions.arrowSize,
            contentSize.height
        };
        
    } else {
        
        _arrowDirection = KYMenuViewArrowDirectionNone;
        
        self.frame = (CGRect) {
            
            (outerWidth - contentSize.width)   * 0.5f,
            (outerHeight - contentSize.height) * 0.5f,
            contentSize,
        };
    }
}

- (void)showMenuInView:(UIView *)view
              fromRect:(CGRect)rect
             menuItems:(NSArray *)menuItems
           withOptions:(OptionalConfiguration) options
{
    
    self.kYMenuViewOptions = options;
    
    _menuItems = menuItems;
    
    _contentView = [self mkContentView];
    [self addSubview:_contentView];
    
    [self setupFrameInView:view fromRect:rect];
    
    CGRect overlayRect =  view.bounds;
    if (self.kYMenuViewOptions.notContainsSubview) {
        overlayRect = CGRectMake(view.bounds.origin.x, view.bounds.origin.y,  view.bounds.size.width, view.bounds.size.height - rect.size.height);
    }
    
    KYMenuOverlay *overlay = [[KYMenuOverlay alloc] initWithFrame:overlayRect maskSetting:self.kYMenuViewOptions.maskToBackground];
    
    [overlay addSubview:self];
    [view addSubview:overlay];
    
    _contentView.hidden = YES;
    const CGRect toFrame = self.frame;
    self.frame = (CGRect){self.arrowPoint, 1, 1};
    
    
    //Menu弹出动画
    [UIView animateWithDuration:0.2
                     animations:^(void) {
                         
                         self.alpha = 1.0f;
                         self.frame = toFrame;
                         
                     } completion:^(BOOL completed) {
                         _contentView.hidden = NO;
                     }];
    
}

- (void)dismissMenu:(BOOL) noAnimated
{
    if (self.superview) {
        
        if (!noAnimated) {
            
            const CGRect toFrame = (CGRect){self.arrowPoint, 1, 1};
            _contentView.hidden = YES;
            
            //Menu收回动画
            [UIView animateWithDuration:0.2
                             animations:^(void) {
                                 
                                 self.alpha = 0;
                                 self.frame = toFrame;
                                 
                             } completion:^(BOOL finished) {
                                 
                                 if ([self.superview isKindOfClass:[KYMenuOverlay class]])
                                     [self.superview removeFromSuperview];
                                 [self removeFromSuperview];
                             }];
            
        } else {
            
            if ([self.superview isKindOfClass:[KYMenuOverlay class]])
                [self.superview removeFromSuperview];
            [self removeFromSuperview];
        }
    }
}

- (void)performAction:(id)sender
{
    [self dismissMenu:YES];
    
    UIButton *button = (UIButton *)sender;
    KYMenuItem *menuItem = _menuItems[button.tag];
    [menuItem performAction];
}

- (UIView *) mkContentView
{
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    if (!_menuItems.count)
        return nil;
    
    const CGFloat kMinMenuItemHeight = 32.f;
    const CGFloat kMinMenuItemWidth = 32.f;
    //配置：左右边距
    const CGFloat kMarginX = self.kYMenuViewOptions.marginXSpacing;
    //配置：上下边距
    const CGFloat kMarginY = self.kYMenuViewOptions.marginYSpacing;
    
    UIFont *titleFont = [KYMenu titleFont];
    if (!titleFont) titleFont = [UIFont systemFontOfSize:16];
    
    CGFloat maxImageWidth = 0;
    CGFloat maxItemHeight = 0;
    CGFloat maxItemWidth = 0;
    
    for (KYMenuItem *menuItem in _menuItems) {
        
        const CGSize imageSize = menuItem.image.size;
        if (imageSize.width > maxImageWidth)
            maxImageWidth = imageSize.width;
    }
    
    if (maxImageWidth) {
        maxImageWidth += kMarginX;
    }
    
    for (KYMenuItem *menuItem in _menuItems) {
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        const CGSize titleSize = [menuItem.title sizeWithAttributes:@{NSFontAttributeName: titleFont}];
#else
        const CGSize titleSize = [menuItem.title sizeWithFont:titleFont];
#endif
        const CGSize imageSize = menuItem.image.size;
        
        //这个地方为header和Footer预留了高度
        const CGFloat itemHeight = MAX(titleSize.height, imageSize.height) + kMarginY * 2;
        
        //这个地方设置item宽度
        const CGFloat itemWidth = ((!menuItem.enabled && !menuItem.image) ? titleSize.width : maxImageWidth + titleSize.width) + kMarginX * 2 + self.kYMenuViewOptions.intervalSpacing;
        
        if (itemHeight > maxItemHeight)
            maxItemHeight = itemHeight;
        
        if (itemWidth > maxItemWidth)
            maxItemWidth = itemWidth;
    }
    
    maxItemWidth  = MAX(maxItemWidth, kMinMenuItemWidth);
    maxItemHeight = MAX(maxItemHeight, kMinMenuItemHeight);
    
    //这个地方设置字图间距
    //const CGFloat titleX = kMarginX * 2 + maxImageWidth;
    const CGFloat titleX = maxImageWidth + self.kYMenuViewOptions.intervalSpacing;
    
    const CGFloat titleWidth = maxItemWidth - titleX - kMarginX *2;
    
    UIImage *selectedImage = [KYMenuView selectedImage:(CGSize){maxItemWidth, maxItemHeight + 2}];
    //配置：分隔线是与内容等宽还是与菜单等宽
    int insets = 0;
    
    if (self.kYMenuViewOptions.seperatorLineHasInsets) {
        insets = 4;
    }
    
    UIImage *gradientLine = [KYMenuView gradientLine: (CGSize){maxItemWidth- kMarginX * insets, 0.4}];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.autoresizingMask = UIViewAutoresizingNone;
    
    contentView.backgroundColor = [UIColor clearColor];
    
    contentView.opaque = NO;
    
    CGFloat itemY = kMarginY * 2;
    
    NSUInteger itemNum = 0;
    
    for (KYMenuItem *menuItem in _menuItems) {
        
        const CGRect itemFrame = (CGRect){0, itemY-kMarginY * 2 + self.kYMenuViewOptions.menuCornerRadius, maxItemWidth, maxItemHeight};
        
        UIView *itemView = [[UIView alloc] initWithFrame:itemFrame];
        itemView.autoresizingMask = UIViewAutoresizingNone;
        
        itemView.opaque = NO;
        
        [contentView addSubview:itemView];
        
        if (menuItem.enabled) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = itemNum;
            button.frame = itemView.bounds;
            button.enabled = menuItem.enabled;
            
            button.backgroundColor = [UIColor clearColor];
            
            button.opaque = NO;
            button.autoresizingMask = UIViewAutoresizingNone;
            
            [button addTarget:self
                       action:@selector(performAction:)
             forControlEvents:UIControlEventTouchUpInside];
            
            [button setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
            
            [itemView addSubview:button];
        }
        
        if (menuItem.title.length) {
            
            CGRect titleFrame;
            
            if (!menuItem.enabled && !menuItem.image) {
                
                titleFrame = (CGRect){
                    kMarginX * 2,
                    kMarginY,
                    maxItemWidth - kMarginX * 4,
                    maxItemHeight - kMarginY * 2
                };
                
            } else {
                
                titleFrame = (CGRect){
                    titleX,
                    kMarginY,
                    titleWidth,
                    maxItemHeight - kMarginY * 2
                };
            }
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
            titleLabel.text = menuItem.title;
            titleLabel.font = titleFont;
            titleLabel.textAlignment = menuItem.alignment;
            
            //配置：menuItem字体颜色
            titleLabel.textColor = [UIColor colorWithRed:self.kYMenuViewOptions.textColor.R green:self.kYMenuViewOptions.textColor.G blue:self.kYMenuViewOptions.textColor.B alpha:1];
            
            if (menuItem.foreColor) {
                titleLabel.textColor = menuItem.foreColor ? menuItem.foreColor : [UIColor blackColor];
            }
            
            UIColor *titleTextColor = [KYMenu titleTextColor];
            if (titleTextColor) {
                titleLabel.textColor = titleTextColor;
            }
            
            titleLabel.backgroundColor = [UIColor clearColor];
            
            titleLabel.autoresizingMask = UIViewAutoresizingNone;
            
            [itemView addSubview:titleLabel];
        }
        
        if (menuItem.image) {
            
            const CGRect imageFrame = {kMarginX * 2, kMarginY, maxImageWidth, maxItemHeight - kMarginY * 2};
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
            imageView.image = menuItem.image;
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeCenter;
            imageView.autoresizingMask = UIViewAutoresizingNone;
            [itemView addSubview:imageView];
        }
        
        if (itemNum < _menuItems.count - 1) {
            
            UIImageView *gradientView = [[UIImageView alloc] initWithImage:gradientLine];
            
            //配置：分隔线是与内容等宽还是与菜单等宽
            if (self.kYMenuViewOptions.seperatorLineHasInsets) {
                gradientView.frame = (CGRect){kMarginX * 2, maxItemHeight + 1, gradientLine.size};
            } else {
                gradientView.frame = (CGRect){0, maxItemHeight + 1 , gradientLine.size};
            }
            
            gradientView.contentMode = UIViewContentModeLeft;
            
            //配置：有无分隔线
            if (self.kYMenuViewOptions.hasSeperatorLine) {
                [itemView addSubview:gradientView];
                itemY += 2;
            }
            
            itemY += maxItemHeight;
        }
        
        ++itemNum;
    }
    
    itemY += self.kYMenuViewOptions.menuCornerRadius;
    
    contentView.frame = (CGRect){0, 0, maxItemWidth, itemY + kMarginY * 2 + 5.5 + self.kYMenuViewOptions.menuCornerRadius};
    
    return contentView;
}

- (CGPoint) arrowPoint
{
    CGPoint point;
    
    if (_arrowDirection == KYMenuViewArrowDirectionUp) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMinY(self.frame) };
        
    } else if (_arrowDirection == KYMenuViewArrowDirectionDown) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMaxY(self.frame) };
        
    } else if (_arrowDirection == KYMenuViewArrowDirectionLeft) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + _arrowPosition  };
        
    } else if (_arrowDirection == KYMenuViewArrowDirectionRight) {
        
        point = (CGPoint){ CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame) + _arrowPosition  };
        
    } else {
        
        point = self.center;
    }
    
    return point;
}

+ (UIImage *) selectedImage: (CGSize) size
{
    
    const CGFloat locations[] = {0,1};
    //配置：选中时阴影的颜色  -- 隐藏属性
    const CGFloat components[] = {
        0.890,0.890,0.890,1,
        0.890,0.890,0.890,1
    };
    
    return [self gradientImageWithSize:size locations:locations components:components count:2];
}

+ (UIImage *) gradientLine: (CGSize) size
{
    const CGFloat locations[5] = {0,0.2,0.5,0.8,1};
    
    const CGFloat R = 0.890f, G = 0.890f, B = 0.890f; //分隔线的颜色 -- 隐藏属性
    
    const CGFloat components[20] = {
        R,G,B,1,
        R,G,B,1,
        R,G,B,1,
        R,G,B,1,
        R,G,B,1
    };
    
    return [self gradientImageWithSize:size locations:locations components:components count:5];
}




+ (UIImage *) gradientImageWithSize:(CGSize) size
                          locations:(const CGFloat []) locations
                         components:(const CGFloat []) components
                              count:(NSUInteger)count
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef colorGradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawLinearGradient(context, colorGradient, (CGPoint){0, 0}, (CGPoint){size.width, 0}, 0);
    CGGradientRelease(colorGradient);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void) drawRect:(CGRect)rect
{
    [self drawBackground:self.bounds
               inContext:UIGraphicsGetCurrentContext()];
}

- (void)drawBackground:(CGRect)frame
             inContext:(CGContextRef) context
{
    
    //配置：整个Menu的底色 重中之重
    
    CGFloat R0 = self.kYMenuViewOptions.menuBackgroundColor.R, G0 = self.kYMenuViewOptions.menuBackgroundColor.G, B0 = self.kYMenuViewOptions.menuBackgroundColor.B;
    
    CGFloat R1 = R0, G1 = G0, B1 = B0;
    
    UIColor *tintColor = [KYMenu tintColor];
    if (tintColor) {
        
        CGFloat a;
        [tintColor getRed:&R0 green:&G0 blue:&B0 alpha:&a];
    }
    
    CGFloat X0 = frame.origin.x;
    CGFloat X1 = frame.origin.x + frame.size.width;
    CGFloat Y0 = frame.origin.y;
    CGFloat Y1 = frame.origin.y + frame.size.height;
    
    // render arrow
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    
    // fix the issue with gap of arrow's base if on the edge
    const CGFloat kEmbedFix = 3.f;
    
    if (_arrowDirection == KYMenuViewArrowDirectionUp) {
        
        const CGFloat arrowXM = _arrowPosition;
        const CGFloat arrowX0 = arrowXM - self.kYMenuViewOptions.arrowSize;
        const CGFloat arrowX1 = arrowXM + self.kYMenuViewOptions.arrowSize;
        const CGFloat arrowY0 = Y0;
        const CGFloat arrowY1 = Y0 + self.kYMenuViewOptions.arrowSize + kEmbedFix;
        
        [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY0}];
        
        
        [[UIColor colorWithRed:R0 green:G0 blue:B0 alpha:1] set];
        
        Y0 += self.kYMenuViewOptions.arrowSize;
        
    } else if (_arrowDirection == KYMenuViewArrowDirectionDown) {
        
        const CGFloat arrowXM = _arrowPosition;
        const CGFloat arrowX0 = arrowXM - self.kYMenuViewOptions.arrowSize;
        const CGFloat arrowX1 = arrowXM + self.kYMenuViewOptions.arrowSize;
        const CGFloat arrowY0 = Y1 - self.kYMenuViewOptions.arrowSize - kEmbedFix;
        const CGFloat arrowY1 = Y1;
        
        [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY1}];
        
        [[UIColor colorWithRed:R1 green:G1 blue:B1 alpha:1] set];
        
        Y1 -= self.kYMenuViewOptions.arrowSize;
        
    } else if (_arrowDirection == KYMenuViewArrowDirectionLeft) {
        
        const CGFloat arrowYM = _arrowPosition;
        const CGFloat arrowX0 = X0;
        const CGFloat arrowX1 = X0 + self.kYMenuViewOptions.arrowSize + kEmbedFix;
        const CGFloat arrowY0 = arrowYM - self.kYMenuViewOptions.arrowSize;;
        const CGFloat arrowY1 = arrowYM + self.kYMenuViewOptions.arrowSize;
        
        [arrowPath moveToPoint:    (CGPoint){arrowX0, arrowYM}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowYM}];
        
        [[UIColor colorWithRed:R0 green:G0 blue:B0 alpha:1] set];
        
        X0 += self.kYMenuViewOptions.arrowSize;
        
    } else if (_arrowDirection == KYMenuViewArrowDirectionRight) {
        
        const CGFloat arrowYM = _arrowPosition;
        const CGFloat arrowX0 = X1;
        const CGFloat arrowX1 = X1 - self.kYMenuViewOptions.arrowSize - kEmbedFix;
        const CGFloat arrowY0 = arrowYM - self.kYMenuViewOptions.arrowSize;;
        const CGFloat arrowY1 = arrowYM + self.kYMenuViewOptions.arrowSize;
        
        [arrowPath moveToPoint:    (CGPoint){arrowX0, arrowYM}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowYM}];
        
        [[UIColor colorWithRed:R1 green:G1 blue:B1 alpha:1] set];
        
        X1 -= self.kYMenuViewOptions.arrowSize;
    }
    
    [arrowPath fill];
    
    // render body
    
    const CGRect bodyFrame = {X0, Y0, X1 - X0, Y1 - Y0};
    
    //配置：这里修改菜单圆角
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:bodyFrame
                                                          cornerRadius:self.kYMenuViewOptions.menuCornerRadius];
    
    const CGFloat locations[] = {0, 1};
    const CGFloat components[] = {
        R0, G0, B0, 1,
        R1, G1, B1, 1,
    };
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,
                                                                 components,
                                                                 locations,
                                                                 sizeof(locations)/sizeof(locations[0]));
    CGColorSpaceRelease(colorSpace);
    
    
    [borderPath addClip];
    
    CGPoint start, end;
    
    if (_arrowDirection == KYMenuViewArrowDirectionLeft ||
        _arrowDirection == KYMenuViewArrowDirectionRight) {
        
        start = (CGPoint){X0, Y0};
        end = (CGPoint){X1, Y0};
        
    } else {
        
        start = (CGPoint){X0, Y0};
        end = (CGPoint){X0, Y1};
    }
    
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    
    CGGradientRelease(gradient);
}

@end


#pragma mark - KYMenu
static KYMenu *gMenu;
static UIColor *gTintColor;
static UIFont *gTitleFont;
static UIColor *gTitleTextColor;

@implementation KYMenu {
    
    KYMenuView *_menuView;
    BOOL        _observing;
}

+ (instancetype) sharedMenu
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        gMenu = [[KYMenu alloc] init];
    });
    return gMenu;
}

- (id) init
{
    NSAssert(!gMenu, @"singleton object");
    
    self = [super init];
    if (self) {
    }
    return self;
}

- (void) dealloc
{
    if (_observing) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
              menuItems:(NSArray *)menuItems
            withOptions:(OptionalConfiguration) options
{
    NSParameterAssert(view);
    NSParameterAssert(menuItems.count);
    
    if (_menuView) {
        
        [_menuView dismissMenu:NO];
        _menuView = nil;
    }
    
    if (!_observing) {
        
        _observing = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationWillChange:)
                                                     name:UIApplicationWillChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    
    
    _menuView = [[KYMenuView alloc] init];
    [_menuView showMenuInView:view fromRect:rect menuItems:menuItems withOptions:options];
}

- (void) dismissMenu
{
    if (_menuView) {
        
        [_menuView dismissMenu:NO];
        _menuView = nil;
    }
    
    if (_observing) {
        
        _observing = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}


+ (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
              menuItems:(NSArray *)menuItems
            withOptions:(OptionalConfiguration) options
{
    [[self sharedMenu] showMenuInView:view fromRect:rect menuItems:menuItems withOptions:options];
}

+ (void) dismissMenu
{
    [[self sharedMenu] dismissMenu];
}

+ (UIColor *) tintColor
{
    return gTintColor;
}

+ (void) setTintColor: (UIColor *) tintColor
{
    if (tintColor != gTintColor) {
        gTintColor = tintColor;
    }
}

+ (UIFont *) titleFont
{
    return gTitleFont;
}

+ (void) setTitleFont: (UIFont *) titleFont
{
    if (titleFont != gTitleFont) {
        gTitleFont = titleFont;
    }
}

+ (UIColor *) titleTextColor
{
    return gTitleTextColor;
}

+ (void) setTitleTextColor: (UIColor *) titleTextColor
{
    if (titleTextColor != gTitleTextColor) {
        gTitleTextColor = titleTextColor;
    }
}

#pragma mark - NSNotification
- (void) orientationWillChange: (NSNotification *) n
{
    [self dismissMenu];
}


@end

