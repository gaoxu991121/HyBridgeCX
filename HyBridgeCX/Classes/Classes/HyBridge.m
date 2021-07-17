//
//  WKWebViewBridge.m
//  @HIT
//
//  Created by CX02 on 2017/11/1.
//  Copyright © 2017年 FuWen. All rights reserved.
//
#import "JsStaticModule.h"
#import "MethodMap.h"
#import "HBArray.h"
#import "HBMap.h"
#import "JsModule.h"
#import "HBMethodFactory.h"
#import "HBUtils.h"
#import "Parameter.h"
#import "JSMethod.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "HyBridge.h"
#import "HBArgumentParser.h"
#import "HyBridgeConfig.h"
#if defined supportsWKWebView
typedef bool myBool;

static NSString* TAG = @"HyBridge";
@implementation HyBridge {
    __weak WKWebView* _webView;
    HyBridgeConfig *mConfig;
    NSMutableArray *mMountedModules;
    NSMutableDictionary *mExposeMethods;
    NSString *mClassName;
    NSString *mPreMount;
    NSMutableArray *mModuleLayers;
    NSString *mNewProtocol;
    NSString *mNewLoadReadyMethod;
    __weak id<WKNavigationDelegate> _webViewDelegate;
    __weak id<WKUIDelegate> _webViewUIDelegate;
    __weak JsMethod * _return;
    long _uniqueId;
    WebBridgeBase *_base;
    
}
+ (NSString*)getTag{
    return TAG;
}
/* API
 *****/
+ (void)enableLogging { [WebBridgeBase enableLogging]; }
+ (void)setArgumentType{
    TYPE__UNDEFINE = 0;
    TYPE__BOOL = 1;
    TYPE__STRING = 2;
    TYPE__NUMBER = 3;
    TYPE__FUNCTION = 4;
    TYPE__OBJECT = 5;
    TYPE__ARRAY = 6;
    TYPE__INT = 7;
    TYPE__FLOAT = 8;
    TYPE__DOUBLE = 9;
    TYPE__LONG = 10;
}
//私有
- (NSString *)_serializeMessage:(id)message pretty:(BOOL)pretty{
    if (pretty) {
        NSLog(@"it is true!!!");
    }
    
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:(NSJSONWritingOptions)(pretty ? NSJSONWritingPrettyPrinted : 0) error:nil] encoding:NSUTF8StringEncoding];
}
- (void)HyBridgeImpl:(NSString*_Nullable)protocol readyMethod:(NSString*_Nullable)readyMethod modules:(NSMutableArray*_Nullable)modules{
    mConfig = [HyBridgeConfig getSetting];
    NSLog(@"%d", [[HyBridgeConfig getSetting] getVersion]);
    NSLog(@"%d", [mConfig getVersion]);
    NSLog(@"%lu", (unsigned long)[mConfig getDefaultModule].count);
    int value = arc4random() % 1000;
    NSInteger Random = value;
    mClassName = (@"%@",[NSString stringWithFormat:@"HB_%ld",(long)Random]);
    NSLog(@"%@", mClassName);
    mMountedModules = [[NSMutableArray alloc] init];
    mExposeMethods = [[NSMutableDictionary alloc] init];
    mModuleLayers = [[NSMutableArray alloc] init];
    mNewProtocol = protocol;
    mNewLoadReadyMethod = readyMethod;
    if (mNewProtocol == nil || [mNewProtocol  isEqual: @""]) {
        mNewProtocol = mConfig.getProtocol;
    }
    if (mNewLoadReadyMethod == nil || [mNewLoadReadyMethod isEqualToString:@""]) {
        mNewLoadReadyMethod = mConfig.getReadyMethod;
    }
    [self mountModules:modules];
}
- (NSString*)getInjectJsString{
    NSString* builder = [[NSString alloc]init];
    builder = @"var ";
    builder = [builder stringByAppendingString:mClassName];
    builder =[builder stringByAppendingString:@" = function() {\n"];
    builder = [builder stringByAppendingString:[HBMethodFactory getUtilMethods:mNewLoadReadyMethod]];
//    注入js方法
    for (JsModule *module in mMountedModules) {
//        NSLog(@"%@", [module modelName]);
        NSMutableDictionary* methods = mExposeMethods[[module class]];
        if (methods == nil) {
            continue;
        }
        if ([[module class] isSubclassOfClass:[JsStaticModule class]]) {
            for (NSString* method in [methods allKeys]) {
#pragma mark -  没有做同名函数
                JsMethod *mjsMethod = methods[method];
                builder = [builder stringByAppendingString:[mjsMethod getInjectJs]];
            }
        }else{
#pragma mark -  模块分离
            NSMutableArray *moduleGroup = [HBUtils moduleSplit:[module modelName]];
            if (moduleGroup == nil) {
                continue;
            }else{
/*//                for (NSUInteger mCount = 0 ; mCount<moduleGroup.count; ++mCount) {
//                    if (![mModuleLayers containsObject:moduleGroup[mCount]]) {
//                        [[[[builder stringByAppendingString:@"    " ]
//                         stringByAppendingString:mClassName]
//                         stringByAppendingString:@".prototype."]
//                         stringByAppendingString:moduleGroup[]
//                    }
//                }*/
                builder = [[[[[builder stringByAppendingString:@"    " ]
                             stringByAppendingString: mClassName ]
                             stringByAppendingString:@".prototype." ]
                             stringByAppendingString:[module modelName]]
                             stringByAppendingString:@" = {\n"];
                [mModuleLayers addObject:[module modelName]];
            }
            for (NSString *method in [methods allKeys]) {
                JsMethod *mjsMethod = methods[method];
                builder = [builder stringByAppendingString:[mjsMethod getInjectJs]];
            }
            builder = [builder stringByAppendingString:@"    };\n"];
        }
    }
    builder = [[[[[[builder stringByAppendingString:@"};\n"]
                            stringByAppendingString:@"window."]
                            stringByAppendingString:mNewProtocol]
                            stringByAppendingString:@" = new "]
                            stringByAppendingString:mClassName]
                            stringByAppendingString:@"();\n"];
    builder = [[[[builder stringByAppendingString:mNewProtocol]
                 stringByAppendingString:@".on"]
                 stringByAppendingString:mNewProtocol]
                 stringByAppendingString:@"Ready();"];
    return builder;
}
- (void)mountModules:(NSMutableArray*_Nullable)modules{
//    NSLog(@"%lu", [mConfig getDefaultModule].count);
    for (JsModule *moduleCl in [mConfig getDefaultModule]) {
#pragma mark -  因为每一个view的模块的controller不一样所以每次都要实例一个//因为数组里面是对象所以只能传实例
        JsModule *moduleCls = [[moduleCl class] alloc];
        if (moduleCls != nil && [moduleCls modelName] != nil && ![[moduleCls modelName]  isEqual: @""]) {
            [mMountedModules addObject:moduleCls];
        }
    }
    if (modules != nil || modules.count != 0) {
        for (JsModule *module in modules) {
            if (module != nil && [module modelName] != nil && ![[module modelName]  isEqual: @""]) {
                [mMountedModules addObject:module];
            }
        }
    }
}
- (void)setJsPromptResult:(void (^)(NSString * _Nullable))promptResult success:(BOOL)success msg:(NSObject*)msg{
//    NSLog(@"test this method");
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
    [ret setObject:[NSNumber numberWithBool:success] forKey:@"success"];
    if ([msg isKindOfClass:[NSNumber class]]) {
        NSNumber *message = msg;
        [ret setObject:message forKey:@"msg"];
    }
    else{
        [ret setObject:msg forKey:@"msg"];
    }
    NSString*str = [self _serializeMessage:ret pretty:NO];
    NSLog(@"%@", [@"Prompt Result: " stringByAppendingString:str]);
    promptResult(str);
}
//public
+ (instancetype)bridgeForWebView:(WKWebView*)webView {
    HyBridge* bridge = [[self alloc] init];
    [bridge _setupInstance:webView];
    return bridge;
}
+ (instancetype)mountModule:(NSString *)protocol readyMethod:(NSString *)readyMethod modules:(NSMutableArray *)modules{
    HyBridge *mBridge = [[HyBridge alloc] init];
    [mBridge HyBridgeImpl:protocol readyMethod:readyMethod modules:modules];
    return mBridge;
}
+ (instancetype)mountModule:(NSMutableArray*)modules{
    HyBridge *mBridge = [[HyBridge alloc] init];
    [mBridge HyBridgeImpl:nil readyMethod:nil modules:modules];
    return mBridge;
}
+ (instancetype)mountModule{
    HyBridge *mBridge = [[HyBridge alloc] init];
    [mBridge HyBridgeImpl:nil readyMethod:nil modules:nil];
    return mBridge;
    
}
- (void)injectJs:(WKWebView *)webview{
    _webView = webview;
    // 注入所有方法，获取所有方法时需要知道weview的等级，所以得在这个地方做
    if (mMountedModules  != nil && mMountedModules.count != 0) {
        for (JsModule *module in mMountedModules) {
            NSMutableDictionary* methodHashMap = [HBUtils getAllMethod:_webView module:module injectedCls:[module class] protocol:mNewProtocol];
            
            [mExposeMethods setObject:methodHashMap forKey:[module class]];
        }
    }
    if (mPreMount == nil) {
        mPreMount = [self getInjectJsString];
    }
    for (JsModule *module in  mMountedModules) {
        if (mExposeMethods[[module class]] == nil || ![[mExposeMethods allKeys] containsObject:[module class]] ) {
            continue;
        }
        if (module.baseViewController != nil) {
            break;
        }
        [module setWebView:_webView];
        [module setViewController];
    }
    if (_webView == nil) {
        NSLog(@"Please call injectJs first");
        return;
    }else{
        [_webView evaluateJavaScript:mPreMount completionHandler:^(id _Nullable test, NSError * _Nullable error) {
            NSLog(@"注入完毕");
        }];
    }
//    NSLog(@"%@", mPreMount);
    NSLog(@"injectJs finished");
}
-(void)evaluateJs:(NSString *)js{
    if (_webView == nil) {
//        NSLog(@"Please call injectJs first");
        return;
    }
    NSLog(@"evaluate js : \n");
    NSLog(@"%@", js);
    [_webView evaluateJavaScript:js completionHandler:^(id _Nullable test, NSError * _Nullable error) {
        NSLog(@"注入完毕");
    }];
}
- (void) reset{
    _webView = nil;
#pragma mark -  注销
}
- (void)setWebViewDelegate:(id<WKNavigationDelegate>)webViewDelegate {
//    _webViewDelegate = webViewDelegate;
    //   _webView.navigationDelegate = webViewDelegate;
}

- (void)setWebViewUIDelegate:(id<WKUIDelegate>)webViewUIDelegate {
//    _webViewUIDelegate = webViewUIDelegate;
//    _webView.UIDelegate = self;
}

- (void)disableJavscriptAlertBoxSafetyTimeout {
    [_base disableJavscriptAlertBoxSafetyTimeout];
}
//todo ---test
- (void)NSInvocationWithString:(NSString *)string withNum:(NSNumber *)number withArray:(NSArray *)array {
//    NSLog(@"%@, %@, %@", string, number, array[0]);
}
/* Internals
 ***********/
- (void)dealloc {
    _base = nil;
    _webView = nil;
    _webViewDelegate = nil;
    _webView.navigationDelegate = nil;
    _webViewUIDelegate = nil;
}
/* WKWebView Specific Internals
 ******************************/
- (void) _setupInstance:(WKWebView*)webView {
    _webView = webView;
//    _webView.navigationDelegate = self;
    _base = [[WebBridgeBase alloc] init];
    _base.delegate = self;
}
- (void)WKFlushMessageQueue {
    [_webView evaluateJavaScript:[_base webViewJavascriptFetchQueyCommand] completionHandler:^(NSString* result, NSError* error) {
        if (error != nil) {
            NSLog(@"WebViewJavascriptBridge: WARNING: Error when trying to fetch data from WKWebView: %@", error);
        }
        [_base flushMessageQueue:result];
    }];
}
- (NSString*) _evaluateJavascript:(NSString*)javascriptCommand {
    [_webView evaluateJavaScript:javascriptCommand completionHandler:nil];
    return NULL;
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    for (UIView* next = _webView; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            UIViewController *presentView = nextResponder;
            if (presentView.presentedViewController == nil)
            {
                [presentView presentViewController:alert animated:true completion:nil];
            }else{
                completionHandler();
            }
        }
    }
    NSLog(@"%@", message);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
    NSLog(@"%@", prompt);
    if ([self callJsPrompt:webView msg:prompt mresult:completionHandler]) {
        NSLog(@"this is JsPrompt");
    }else{
        NSLog(@"normal prompt");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.textColor = [UIColor redColor];
        }];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completionHandler([[alert.textFields lastObject] text]);
        }]];
        for (UIView* next = _webView; next; next = next.superview) {
            UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                UIViewController *presentView = nextResponder;
                [presentView presentViewController:alert animated:true completion:nil];
            }
        }
    }
}
- (BOOL)callJsPrompt:(WKWebView *)WebView msg:(NSString *)msg mresult:(void (^)(NSString * _Nullable))mresult{
    if ([msg  isEqual:  @""]) {
        return false;
    }
    if (![WebView conformsToProtocol:@protocol(PermissionLevel)]) {
        return false;
    }
    JsModule* findModule;
    HBArgumentPaser *parser = [HBArgumentPaser parse:msg];
    if (parser != nil || [parser GetModule] != nil ||[parser GetMethod] != nil) {
        findModule = [self GetModule:[parser GetModule]];
        if (findModule != nil) {
//            拿到所有的方法值
            NSMutableDictionary* methodMultiValueMap = mExposeMethods[[findModule class]];
            if (methodMultiValueMap != nil && methodMultiValueMap.allKeys.count != 0 && [methodMultiValueMap.allKeys containsObject:[parser GetMethod]]) {
                JsMethod *method = methodMultiValueMap[[parser GetMethod]];
#pragma mark -  同名的又问题：要判断是数组还是JsMethod//另外拿不到数据类型
//                for (JsMethod *method in methodMultiValueMap[[parser GetMethod]]) {
                NSMutableArray *Params = [parser GetParameters];
                NSUInteger len = Params.count;
                NSMutableArray* invokeArgs = [[NSMutableArray alloc] init];
                BOOL paramTypeMatched = true;
                for (NSUInteger i = 0; i<len; ++i) {
//                    int type = [method getParameterType][i];
                    int type = 0;
                    if (Params != nil && Params.count >= i+1) {
                        Parameter *param = Params[i];
                        NSObject *parseObject = [HBUtils parseToObject:type Param:param method:method];
                        if (parseObject == nil) {
                            paramTypeMatched = false;
                            break;
                        }
                        invokeArgs[i] = parseObject;
                    }
                    if (invokeArgs[i] == nil) {
// 参数类型匹配失败，换下一个复写方法
                        paramTypeMatched = false;
                        break;
                    }
                }
#pragma mark -  没有类参数匹配
                NSString *methodLevelKey = [[[[method getModule] modelName] stringByAppendingString:@"."] stringByAppendingString:[method getMethodName]];
#pragma mark -  在判断一下类型：防止prensent后dissMiss掉了但没有重新注入，（还有每次load注入防止一个webview load两次乱了）
                HBBaseWebView *baseView = WebView;
                if ([MethodMap getMethodLevel:methodLevelKey] > [baseView containerLevel]) {
                    [self setJsPromptResult:mresult success:false msg:@"Error: Permission Denied, Please Check!"];
                    return true;
                }
                @try {
                    if ([method isHasReturn]){
                        NSObject* ret = [method invoke:invokeArgs];
                        [self setJsPromptResult:mresult success:true msg:(ret == nil?@"":ret)];
                    }else{
                        [method invokeNoReturn:invokeArgs];
                        [self setJsPromptResult:mresult success:true msg:(@"没有返回值")];
                    }
                } @catch (NSException *exception) {
                    [self setJsPromptResult:mresult success:false msg:@"an error,发生错误了"];
                        NSLog(@"Call JsMethod wrong ");
                } @finally {
                    NSLog(@"执行了try");
                }
                return true;
//               }
            }
        }
        [self setJsPromptResult:mresult success:true msg:@"HBArgument Parse error"];
        return true;
    }
    return false;
}
-(id)GetModule:(NSString *)name{
    if ([name isEqualToString:@""] || name == nil) {
        NSLog(@"module name is empty");
    }
    for (JsModule *module in mExposeMethods.allKeys ) {
        SEL mSelector = NSSelectorFromString(@"modelName");
        if ([name isEqualToString:[[[[module class] alloc] init] modelName]]) {
            return module;
        }
    }
    return nil;
}

@end
#endif

