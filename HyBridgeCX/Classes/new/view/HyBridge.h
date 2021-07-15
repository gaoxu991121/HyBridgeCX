//
//  WKWebViewBridge.h

//  @HIT
//
//  Created by CX02 on 2017/11/1.
//  Copyright © 2017年 FuWen. All rights reserved.
//
//  HyBridge.h
//
//  Created by @LokiMeyburg on 10/15/14.
//  Copyright (c) 2014 @LokiMeyburg. All rights reserved.
//

#if (__MAC_OS_X_VERSION_MAX_ALLOWED > __MAC_10_9 || __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_1)
#define supportsWKWebView
#endif

#if defined supportsWKWebView

#import <Foundation/Foundation.h>
#import "WebBridgeBase.h"
#import <WebKit/WebKit.h>

//argumentType
static int TYPE__UNDEFINE;
static int TYPE__BOOL;
static int TYPE__STRING;
static int TYPE__NUMBER;
static int TYPE__FUNCTION;
static int TYPE__OBJECT;
static int TYPE__ARRAY;
static int TYPE__INT;
static int TYPE__FLOAT;
static int TYPE__DOUBLE;
static int TYPE__LONG;

@interface HyBridge : NSObject<WKNavigationDelegate, WebBridgeBaseDelegate,WKUIDelegate>
@property (strong, nonatomic) NSString* ExeJsCommand;
@property (strong, nonatomic) NSMutableDictionary *MethodArray;
@property (strong,nonatomic) NSMutableDictionary *mExposed;
+ (instancetype)bridgeForWebView:(WKWebView*)webView;
+ (instancetype)mountModule;
+ (instancetype)mountModule:(NSMutableArray*)modules;
+ (instancetype)mountModule:(NSString*)protocol readyMethod:(NSString*)readyMethod modules:(NSMutableArray *)modules;
+ (NSString*)getTag;
- (void)injectJs:(WKWebView*)webview;
- (BOOL)callJsPrompt:(WKWebView*)WebView msg:(NSString*)msg mresult:(void (^)(NSString * __nullable result))mresult;
- (void)evaluateJs:(NSString*)js;
- (void)reset;
+ (void)enableLogging;
+ (void)setArgumentType;
- (void)setWebViewDelegate:(id)webViewDelegate;
- (void)setWebViewUIDelegate:(id)webViewUIDelegate;
- (void)disableJavscriptAlertBoxSafetyTimeout;

@end
#endif
