//
//  JsModule.h
//  Pods
//
//  Created by CX02 on 2017/11/21.
//
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#ifndef JsModule_h
#define JsModule_h


#endif /* JsModule_h */
@interface JsModule : NSObject
@property (nonatomic,strong) UIViewController* baseViewController;
@property (strong,nonatomic) WKWebView* mWebview;
- (UIViewController*)getViewController;
- (void)setWebView:(WKWebView*)mWeb;
- (void)setViewController;
- (WKWebView*)getWebView;
- (NSString*)modelName;
@end
