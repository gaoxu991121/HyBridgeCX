//
//  JsModule.m
//  Pods
//
//  Created by CX02 on 2017/11/21.
//
//
#import <Foundation/Foundation.h>
#import "JsModule.h"
#import "MyViewController.h"
typedef bool myBool;
static WKWebView *mWebview;
@implementation JsModule {
}
- (WKWebView*)getWebView{
    return self.mWebview;
}
- (UIViewController*)getViewController{
    return self.baseViewController;
}
- (void)setViewController{
    self.baseViewController = [self getCurrentViewController];
}
- (NSString*)modelName{
    return @"Module";
}
- (void)setWebView:(WKWebView *)mWeb{
    self.mWebview = mWeb;
}
- (UIViewController *)getCurrentViewController
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    for (UIView * uiview in [window subviews]) {
        result = [UITabBarController class];
        JsModule* mModel = [[JsModule alloc]init];
        UIView* WkView = self.mWebview;
        for (UIView* next = WkView; next; next = next.superview) {
            UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[MyViewController class]]) {
                UIViewController *presentView = nextResponder;
                result = presentView;
            }
        }
        return result;
    }
    return result;
}
@end
