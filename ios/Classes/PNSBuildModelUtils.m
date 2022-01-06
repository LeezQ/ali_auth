#import "PNSBuildModelUtils.h"
#import "NSDictionary+Utils.h"
#define TX_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define TX_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define IS_HORIZONTAL (TX_SCREEN_WIDTH > TX_SCREEN_WIDTH)

#define TX_Alert_NAV_BAR_HEIGHT      55.0
#define TX_Alert_HORIZONTAL_NAV_BAR_HEIGHT      41.0

//竖屏弹窗
#define TX_Alert_Default_Left_Padding         42
#define TX_Alert_Default_Top_Padding          115

/**横屏弹窗*/
#define TX_Alert_Horizontal_Default_Left_Padding      80.0
@implementation PNSBuildModelUtils

+ (TXCustomModel *)buildNewAlertModel: (NSDictionary *) viewConfig selector:(SEL)selector target: (id) target{
    TXCustomModel *model = [[TXCustomModel alloc] init];

    model.alertBarIsHidden = [viewConfig boolValueForKey: @"alertBarIsHidden" defaultValue: NO];
    model.alertTitleBarColor = [self getColor: [viewConfig stringValueForKey: @"alertTitleBarColor" defaultValue: @"0x3971fe"]];
    model.alertTitle = [
        [NSAttributedString alloc]
        initWithString: [viewConfig stringValueForKey: @"navText" defaultValue: @"一键登录"]
        attributes: @{
        NSForegroundColorAttributeName: UIColor.whiteColor,
        NSFontAttributeName : [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"navTextSize" defaultValue: 20.0]]
    }
    ];;
    model.alertCloseItemIsHidden = [viewConfig boolValueForKey: @"alertCloseItemIsHidden" defaultValue: NO];

    UIImage * alertCloseImage = [self changeUriPathToImage: viewConfig[@"alertCloseImage"]];

    model.alertCloseImage = alertCloseImage?:[UIImage imageNamed:@"icon_close_light"];

    model.alertBlurViewColor = [self getColor: [viewConfig stringValueForKey: @"alertBlurViewColor" defaultValue: @"#000000"]];
    model.alertBlurViewAlpha = [viewConfig floatValueForKey: @"alertBlurViewAlpha" defaultValue: 0.5];
    NSString *radiuString = [viewConfig stringValueForKey: @"alertCornerRadiusArray" defaultValue: @"10,10,10,10"];
    NSArray *alertCornerRadiusArray = [radiuString componentsSeparatedByString: @","];
    model.alertCornerRadiusArray = [self _map: alertCornerRadiusArray]; //@[@10, @10, @10, @10];

    /// 协议页面导航设置
    model.privacyNavColor =  [self getColor: [viewConfig stringValueForKey: @"webNavColor" defaultValue: @"#ffffff"]];
    UIImage * privacyNavBackImage = [self changeUriPathToImage: viewConfig[@"webNavReturnImgPath"]];
    if(privacyNavBackImage != nil){
        model.privacyNavBackImage = privacyNavBackImage;
    }
    model.privacyNavTitleFont = [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"webNavTextSize" defaultValue: 18]];
    model.privacyNavTitleColor = [self getColor: [viewConfig stringValueForKey: @"webNavTextColor" defaultValue: @"#000000"]];

    /// logo 设置
    model.logoIsHidden = [viewConfig boolValueForKey: @"logoHidden" defaultValue: YES];

    NSURL *imageURL = [NSURL URLWithString:[viewConfig stringValueForKey:@"eventImg" defaultValue:@"https://zjcem-xy.oss-cn-beijing.aliyuncs.com/appimages/mobile-reg-banner.png"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    imageView.clipsToBounds = YES;

    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        superCustomView.userInteractionEnabled = YES;
        [superCustomView addSubview:imageView];
    };
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        CGFloat padding = 10;
        CGFloat x = padding;
        CGFloat y = 0;
        CGFloat width = contentViewFrame.size.width - 2 * padding;
        CGFloat height = 90;
        imageView.frame = CGRectMake(x, y, width, height);
    };

    /// slogan 设置
    model.sloganIsHidden = [viewConfig boolValueForKey: @"sloganHidden" defaultValue: NO];
    model.sloganText = [
        [NSAttributedString alloc]
        initWithString: [viewConfig stringValueForKey: @"sloganText" defaultValue: @"一键登录欢迎语"]
        attributes: @{
        NSForegroundColorAttributeName: [self colorWithHexString: [viewConfig stringValueForKey: @"sloganTextColor" defaultValue: @"#555"] alpha: 1],
        NSFontAttributeName: [
            UIFont systemFontOfSize: [viewConfig floatValueForKey: @"sloganTextSize" defaultValue: 19]
        ]
    }
    ];


    /// number 设置
    model.numberColor = [self getColor: [viewConfig stringValueForKey: @"numberColor" defaultValue: @"#555"]];
    model.numberFont = [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"numberSize" defaultValue: 17]];


    /// 登录按钮
    model.loginBtnText = [
        [NSAttributedString alloc]
        initWithString: [viewConfig stringValueForKey: @"logBtnText" defaultValue: @"一键登录"]
        attributes: @{
        NSForegroundColorAttributeName: [self getColor: [viewConfig stringValueForKey: @"logBtnTextColor" defaultValue: @"#ff00ff"]],
        NSFontAttributeName: [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"logBtnTextSize" defaultValue: 23]]
    }
    ];

    NSArray *logBtnCustomBackgroundImagePath = [[viewConfig stringValueForKey: @"logBtnBackgroundPath" defaultValue: @","] componentsSeparatedByString:@","];

    if (logBtnCustomBackgroundImagePath.count == 3) {
        // login_btn_normal
        UIImage * login_btn_normal = [self changeUriPathToImage: logBtnCustomBackgroundImagePath[0]];

        // login_btn_unable
        UIImage * login_btn_unable = [self changeUriPathToImage: logBtnCustomBackgroundImagePath[1]];

        // login_btn_press
        UIImage * login_btn_press = [self changeUriPathToImage: logBtnCustomBackgroundImagePath[2]];

        // default
        UIImage *defaultClick = [UIImage imageNamed:@"button_click"];
        UIImage *buttonUnclick = [UIImage imageNamed:@"button_unclick"];

        if ((login_btn_normal != nil && login_btn_unable != nil && login_btn_press != nil) || (defaultClick != nil && buttonUnclick != nil)) {
            // 登录按钮设置
            model.loginBtnBgImgs = @[
                login_btn_normal?:defaultClick,
                login_btn_unable?:buttonUnclick,
                login_btn_press?:defaultClick
            ];
        }
    }

    model.privacyOne = [[viewConfig stringValueForKey: @"appPrivacyOne" defaultValue: nil] componentsSeparatedByString:@","];
    model.privacyTwo = [[viewConfig stringValueForKey: @"appPrivacyTwo" defaultValue: nil] componentsSeparatedByString:@","];
    NSArray *privacyColors = [[viewConfig stringValueForKey: @"appPrivacyColor" defaultValue: nil] componentsSeparatedByString:@","];
    if(privacyColors != nil && privacyColors.count > 1){
        model.privacyColors = @[
            [self colorWithHexString: privacyColors[0] alpha: 1],
            [self colorWithHexString: privacyColors[1] alpha: 1]
        ];
    }

    model.privacyAlignment = NSTextAlignmentCenter;
    model.privacyFont = [UIFont fontWithName:@"PingFangSC-Regular" size: [viewConfig floatValueForKey: @"privacyTextSize" defaultValue: 14.0]];
    model.privacyPreText = [viewConfig stringValueForKey: @"privacyBefore" defaultValue: @"我已阅读并同意"];
    model.privacyOperatorPreText = [viewConfig stringValueForKey: @"vendorPrivacyPrefix" defaultValue: @"《"];
    model.privacyOperatorSufText = [viewConfig stringValueForKey: @"vendorPrivacySuffix" defaultValue: @"》"];

    // 勾选统一按钮
    BOOL checkStatus = [viewConfig boolValueForKey: @"checkBoxHidden" defaultValue: NO];
    model.checkBoxIsHidden = checkStatus;
    if (!checkStatus) {
        UIImage* unchecked = [self changeUriPathToImage: [viewConfig stringValueForKey: @"uncheckedImgPath" defaultValue: nil]];
        UIImage* checked = [self changeUriPathToImage: [viewConfig stringValueForKey: @"checkedImgPath" defaultValue: nil]];
        if (unchecked != nil && checked != nil) {
            model.checkBoxImages = @[
                unchecked,
                checked
            ];
        }
    }

    model.checkBoxWH = [viewConfig floatValueForKey: @"checkBoxWH" defaultValue: 17.0];

    // 切换到其他标题
    model.changeBtnIsHidden = [viewConfig boolValueForKey: @"changeBtnIsHidden" defaultValue: NO];
    model.changeBtnTitle = [
        [NSAttributedString alloc] initWithString: [viewConfig stringValueForKey: @"changeBtnTitle" defaultValue: @"切换到其他方式"]
        attributes: @{
        NSForegroundColorAttributeName: [self getColor: [viewConfig stringValueForKey: @"changeBtnTitleColor" defaultValue: @"#ccc"]],
        NSFontAttributeName : [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"changeBtnTitleSize" defaultValue: 18]]
    }
    ];


    //实现该block，并且返回的frame的x或y大于0，则认为是弹窗谈起授权页
    model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize contentSize, CGRect frame) {
        CGFloat alertX = 0;
        CGFloat alertY = (screenSize.height - 420) ;
        CGFloat alertWidth = screenSize.width;
        CGFloat alertHeight = 420;
        return CGRectMake(alertX, alertY, alertWidth, alertHeight);
    };

    //授权页默认控件布局调整
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 10;
        return frame;
    };
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 110;
        return frame;
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 140;
        return frame;
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 180;
        return frame;
    };
    model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(10, 240, superViewSize.width - 20, 30);
    };

    return model;
}

+ (NSArray *)_map:(NSArray *)hanlde {
    NSMutableArray *arr = NSMutableArray.array;
    for (int i = 0 ; i < hanlde.count; i++) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *new = [f numberFromString: hanlde[i]];
        [arr addObject:new];
    }
    return arr.copy;
}

#pragma mark  assets -> 自定义图片view
+ (UIImageView *)customView: (NSString *)path
                   selector:(SEL)selector
                     target: (id) target
                      index: (int) index
{
    UIImage * image = [self changeUriPathToImage: path];

    /// 自定义布局 图片不支持圆角，如需圆角请使用圆角图片
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = image;
    imageView.tag = index;
    //设置控件背景颜色
    imageView.backgroundColor = [UIColor orangeColor];
    imageView.clipsToBounds = YES;
    //    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.contentMode = UIViewContentModeScaleToFill;
    //    imageView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];

    [imageView addGestureRecognizer:tapGesture];
    imageView.userInteractionEnabled = YES;

    return imageView;
}

#pragma mark  assets -> 转换成真实路径
+ (NSString *) changeUriToPath:(NSString *) key{
    NSString* keyPath = [[self flutterVC] lookupKeyForAsset: key];
    NSString* path = [[NSBundle mainBundle] pathForResource: keyPath ofType:nil];
    return path;
}

+ (UIImage *) changeUriPathToImage:(NSString *) key{
    NSString* path = [self changeUriToPath: key];
    UIImage * image = [UIImage imageWithContentsOfFile: path];
    return image;
}

+(FlutterViewController *)flutterVC{
    return (FlutterViewController *)[self findCurrentViewController];
}

+ (UIViewController *)getRootViewController {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    return window.rootViewController;
}

#pragma mark  ======在view上添加UIViewController========
+ (UIViewController *)findCurrentViewController{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}

+(UIColor *) getColor:(NSString *)hexColor{
    if (hexColor.length < 8) {
        return [self colorWithHexString: hexColor alpha: 1];
    }

    unsigned int alpha, red, green, blue;
    NSRange range;
    range.length =2;

    range.location =1;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&alpha];//透明度
    range.location =3;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location =5;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location =7;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:(float)(alpha/255.0f)];
}

/**
 16进制颜色转换为UIColor

 @param hexColor 16进制字符串（可以以0x开头，可以以#开头，也可以就是6位的16进制）
 @param opacity 透明度
 @return 16进制字符串对应的颜色
 */
+(UIColor *)colorWithHexString:(NSString *)hexColor alpha:(float)opacity{
    NSString * cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];

    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];

    if ([cString length] != 6) return [UIColor blackColor];

    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString * rString = [cString substringWithRange:range];

    range.location = 2;
    NSString * gString = [cString substringWithRange:range];

    range.location = 4;
    NSString * bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:opacity];
}

+ (UIColor *)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:alpha];
}


@end
