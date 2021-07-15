//
//  WebBridgeBase.m
//  @HIT
//
//  Created by CX02 on 2017/11/1.
//  Copyright © 2017年 FuWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebBridgeBase.h"

@implementation WebBridgeBase {
    __weak id _webViewDelegate;
    long _uniqueId;
}

static bool logging = false;
static int logMaxLength = 500;

+ (void)enableLogging { logging = true; }
+ (void)setLogMaxLength:(int)length { logMaxLength = length;}

- (id)init {
    if (self = [super init]) {
        self.messageHandlers = [NSMutableDictionary dictionary];
        self.startupMessageQueue = [NSMutableArray array];
        self.responseCallbacks = [NSMutableDictionary dictionary];
        _uniqueId = 0;
    }
    return self;
}

- (void)dealloc {
    self.startupMessageQueue = nil;
    self.responseCallbacks = nil;
    self.messageHandlers = nil;
}

- (void)reset {
    self.startupMessageQueue = [NSMutableArray array];
    self.responseCallbacks = [NSMutableDictionary dictionary];
    _uniqueId = 0;
}

- (void)sendData:(id)data responseCallback:(WVJBResponseCallback)responseCallback handlerName:(NSString*)handlerName {
    NSMutableDictionary* message = [NSMutableDictionary dictionary];
    
    if (data) {
        message[@"data"] = data;
    }
    
    if (responseCallback) {
        NSString* callbackId = [NSString stringWithFormat:@"objc_cb_%ld", ++_uniqueId];
        self.responseCallbacks[callbackId] = [responseCallback copy];
        message[@"callbackId"] = callbackId;
    }
    
    if (handlerName) {
        message[@"handlerName"] = handlerName;
    }
    [self _queueMessage:message];
}

- (void)flushMessageQueue:(NSString *)messageQueueString{
    if (messageQueueString == nil || messageQueueString.length == 0) {
        NSLog(@"WebViewJavascriptBridge: WARNING: ObjC got nil while fetching the message queue JSON from webview. This can happen if the WebViewJavascriptBridge JS is not currently present in the webview, e.g if the webview just loaded a new page.");
        return;
    }
    
    id messages = [self _deserializeMessageJSON:messageQueueString];
    for (WVJBMessage* message in messages) {
        if (![message isKindOfClass:[WVJBMessage class]]) {
            NSLog(@"WebViewJavascriptBridge: WARNING: Invalid %@ received: %@", [message class], message);
            continue;
        }
        [self _log:@"RCVD" json:message];
        
        NSString* responseId = message[@"responseId"];
        if (responseId) {
            WVJBResponseCallback responseCallback = _responseCallbacks[responseId];
            responseCallback(message[@"responseData"]);
            [self.responseCallbacks removeObjectForKey:responseId];
        } else {
            WVJBResponseCallback responseCallback = NULL;
            NSString* callbackId = message[@"callbackId"];
            if (callbackId) {
                responseCallback = ^(id responseData) {
                    if (responseData == nil) {
                        responseData = [NSNull null];
                    }
                    
                    WVJBMessage* msg = @{ @"responseId":callbackId, @"responseData":responseData };
                    [self _queueMessage:msg];
                };
            } else {
                responseCallback = ^(id ignoreResponseData) {
                    // Do nothing
                };
            }
            
            WVJBHandler handler = self.messageHandlers[message[@"handlerName"]];
            
            if (!handler) {
                NSLog(@"WVJBNoHandlerException, No handler for message from JS: %@", message);
                continue;
            }
            
            handler(message[@"data"], responseCallback);
        }
    }
}

- (void)injectJavascriptFile {
    NSString *js = @"";
    [self _evaluateJavascript:js];
    if (self.startupMessageQueue) {
        NSArray* queue = self.startupMessageQueue;
        self.startupMessageQueue = nil;
        for (id queuedMessage in queue) {
            [self _dispatchMessage:queuedMessage];
        }
    }
}

- (BOOL)isWebViewJavascriptBridgeURL:(NSURL*)url {
    if (![self isSchemeMatch:url]) {
        return NO;
    }
    return [self isBridgeLoadedURL:url] || [self isQueueMessageURL:url];
}

- (BOOL)isSchemeMatch:(NSURL*)url {
    NSString* scheme = url.scheme.lowercaseString;
    return [scheme isEqualToString:kNewProtocolScheme] || [scheme isEqualToString:kOldProtocolScheme];
}

- (BOOL)isQueueMessageURL:(NSURL*)url {
    NSString* host = url.host.lowercaseString;
    return [self isSchemeMatch:url] && [host isEqualToString:kQueueHasMessage];
}

- (BOOL)isBridgeLoadedURL:(NSURL*)url {
    NSString* host = url.host.lowercaseString;
    return [self isSchemeMatch:url] && [host isEqualToString:kBridgeLoaded];
}

- (void)logUnkownMessage:(NSURL*)url {
    NSLog(@"WebViewJavascriptBridge: WARNING: Received unknown WebViewJavascriptBridge command %@", [url absoluteString]);
}

- (NSString *)webViewJavascriptCheckCommand {
    return @"typeof WebViewJavascriptBridge == \'object\';";
}

- (NSString *)webViewJavascriptFetchQueyCommand {
    return @"WebViewJavascriptBridge._fetchQueue();";
}

- (void)disableJavscriptAlertBoxSafetyTimeout {
    [self sendData:nil responseCallback:nil handlerName:@"_disableJavascriptAlertBoxSafetyTimeout"];
}

// Private
// -------------------------------------------

- (void) _evaluateJavascript:(NSString *)javascriptCommand {
    [self.delegate _evaluateJavascript:javascriptCommand];
}

- (void)_queueMessage:(WVJBMessage*)message {
    if (self.startupMessageQueue) {
        [self.startupMessageQueue addObject:message];
    } else {
        [self _dispatchMessage:message];
    }
}

- (void)_dispatchMessage:(WVJBMessage*)message {
    NSString *messageJSON = [self _serializeMessage:message pretty:NO];
    [self _log:@"SEND" json:messageJSON];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
    
    NSString* javascriptCommand = [NSString stringWithFormat:@"WebViewJavascriptBridge._handleMessageFromObjC('%@');", messageJSON];
    if ([[NSThread currentThread] isMainThread]) {
        [self _evaluateJavascript:javascriptCommand];
        
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self _evaluateJavascript:javascriptCommand];
        });
    }
}

- (NSString *)_serializeMessage:(id)message pretty:(BOOL)pretty{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:(NSJSONWritingOptions)(pretty ? NSJSONWritingPrettyPrinted : 0) error:nil] encoding:NSUTF8StringEncoding];
}

- (NSArray*)_deserializeMessageJSON:(NSString *)messageJSON {
    return [NSJSONSerialization JSONObjectWithData:[messageJSON dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
}

- (void)_log:(NSString *)action json:(id)json {
    if (!logging) { return; }
    if (![json isKindOfClass:[NSString class]]) {
        json = [self _serializeMessage:json pretty:YES];
    }
    if ([json length] > logMaxLength) {
        NSLog(@"WVJB %@: %@ [...]", action, [json substringToIndex:logMaxLength]);
    } else {
        NSLog(@"WVJB %@: %@", action, json);
    }
}

@end
//- (NSObject*)changeArgument:(NSObject*)argument model:(NSString *)model{
//    NSMutableDictionary *argus = [[NSMutableDictionary alloc] init];
//    NSMutableArray *arr = [[NSMutableArray alloc]init];
//    NSLog(@"%@", argus.description);
//    if ([argument isKindOfClass:[NSDictionary class]]) {
//    NSString *MethodType = @"Function";
//    NSString *Dic = @"TYPE__OBJECT";
//    NSString *Array = @"TYPE__ARRAY";
//    NSMutableDictionary *args = argument;
//    for (NSInteger index = 0; index < args.allKeys.count; index++) {
//        NSString *key = args.allKeys[index];
//        if ([args[key] isKindOfClass:[NSString class]]&& [args[key] rangeOfString:MethodType].location != NSNotFound){
//            NSString *callBackID = [[args[args.allKeys[index]] stringByReplacingOccurrencesOfString:@"[Function]::" withString:@""] stringByReplacingOccurrencesOfString:key withString:@""];
//            Callback *callback = [[Callback alloc] init];
//            callback.CallbackID = callBackID;
//            [callback setWebview:_webView];
//            JsMethod *IsStaticMethod = _MethodArray[model][0];
//            if (IsStaticMethod.mIsStatic) {
//                NSString *MycallBack = IsStaticMethod.mProtocol;
//                MycallBack = [[[MycallBack stringByAppendingString:@"." ]stringByAppendingString:IsStaticMethod.mJsmethod] stringByAppendingString:@"Callback"];
//                [callback setCallback:MycallBack];
//            }else{
//                NSString *MycallBack = IsStaticMethod.mProtocol;
//                MycallBack = [[[[[MycallBack stringByAppendingString:@"." ] stringByAppendingString: IsStaticMethod.mJsModel] stringByAppendingString:@"."] stringByAppendingString:IsStaticMethod.mJsmethod] stringByAppendingString:@"Callback"];
//                [callback setCallback:MycallBack];
//            }
//            [argus setObject:callback forKey:key];
//            //                    将字典里的函数进行调整
//        }else{
//            if ([args[key] isKindOfClass:[NSDictionary class]] || [args[key] isKindOfClass:[NSArray class]]){
//                [argus setObject:[self changeArgument:args[key] model:model] forKey:key];
//            }else{
//                [argus setObject:args[key] forKey:key];
//            }
//        }
//    }
//    NSLog(@"%lu", (unsigned long)argus.count);
//    return argus;
//    }else if ([argument isKindOfClass:[NSArray class]])
//    {
//        NSString *MethodType = @"Function";
//        NSString *Dic = @"TYPE__OBJECT";
//        NSString *Array = @"TYPE__ARRAY";
//        NSMutableArray *args = argument;
//        for (NSInteger mindex = 0; mindex < args.count; mindex++) {
//            if ([args[mindex] isKindOfClass:[NSString class]]&& [args[mindex] rangeOfString:MethodType].location != NSNotFound){
//                NSString *callBackID = [[args[mindex] stringByReplacingOccurrencesOfString:@"[Function]::" withString:@""] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%ld", (long)mindex] withString:@""];
//                Callback *callback = [[Callback alloc] init];
//                callback.CallbackID = callBackID;
//                [callback setWebview:_webView];
//                JsMethod *IsStaticMethod = _MethodArray[model][0];
//                if (IsStaticMethod.mIsStatic) {
//                    NSString *MycallBack = IsStaticMethod.mProtocol;
//                    MycallBack = [[[MycallBack stringByAppendingString:@"." ]stringByAppendingString:IsStaticMethod.mJsmethod] stringByAppendingString:@"Callback"];
//                    [callback setCallback:MycallBack];
//                }else{
//                    NSString *MycallBack = IsStaticMethod.mProtocol;
//                    MycallBack = [[[[[MycallBack stringByAppendingString:@"." ] stringByAppendingString: IsStaticMethod.mJsModel] stringByAppendingString:@"."] stringByAppendingString:IsStaticMethod.mJsmethod] stringByAppendingString:@"Callback"];
//                    [callback setCallback:MycallBack];
//                }
//                [arr addObject:callback];
//                //                    将字典以及数组里的函数进行调整
//            }else{
//                if ([args[mindex] isKindOfClass:[NSDictionary class]] || [args[mindex] isKindOfClass:[NSArray class]]){
//                    [arr addObject:[self changeArgument:args[mindex] model:model]];
//                }else{
//                    [arr addObject:args[mindex]];
//                }
//            }
//        }
//        NSLog(@"%lu", (unsigned long)argus.count);
//        return argus;
//    }
//}

//- (BOOL)callModel:(NSDictionary *)argument {
//    NSMutableDictionary *argus = [[NSMutableDictionary alloc] init];
//    id myObj = [[NSClassFromString(argument[@"module"]) alloc] init];
//    Class test = [myObj class];
//    SEL selectorNormal = NSSelectorFromString((argument)[@"method"]);
//    NSLog(@"%@", argument[@"method"]);
//    BOOL canCall = [test instancesRespondToSelector:selectorNormal];
//    if (canCall) {
//        if ([argument[@"parserArgument"] isKindOfClass:[NSDictionary class]]){
//            NSString *MethodType = @"TYPE__FUNCTION";
//            NSString *Dic = @"TYPE__OBJECT";
//            NSString *Arr = @"TYPE__ARRAY";
//            NSMutableDictionary *args = argument[@"parserArgument"];
//            for (NSInteger index = 0; index < args.allKeys.count; index++) {
//                NSString *key = args.allKeys[index];
//                if ([args.allKeys[index] rangeOfString:MethodType].location != NSNotFound){
//                    NSString *callBackID = args[args.allKeys[index]];
//                    Callback *callback = [[Callback alloc] init];
//                    callback.CallbackID = callBackID;
//                    [callback setWebview:_webView];
//                    JsMethod *IsStaticMethod = _MethodArray[argument[@"module"]][0];
//                    if (IsStaticMethod.mIsStatic) {
//                        NSString *MycallBack = IsStaticMethod.mProtocol;
//                        MycallBack = [[[MycallBack stringByAppendingString:@"." ]stringByAppendingString:IsStaticMethod.mJsmethod] stringByAppendingString:@"Callback"];
//                        [callback setCallback:MycallBack];
//                    }else{
//                        NSString *MycallBack = IsStaticMethod.mProtocol;
//                        MycallBack = [[[[[MycallBack stringByAppendingString:@"." ] stringByAppendingString: IsStaticMethod.mJsModel] stringByAppendingString:@"."] stringByAppendingString:IsStaticMethod.mJsmethod] stringByAppendingString:@"Callback"];
//                        [callback setCallback:MycallBack];
//                    }
//                    [argus setObject:callback forKey:key];
//
//                }else if ([args.allKeys[index] rangeOfString:Dic].location != NSNotFound || [args.allKeys[index] rangeOfString:Arr].location != NSNotFound){
//                    [argus setObject:[self changeArgument:args[key] model:argument[@"module"]] forKey:key];
//                }else{
//                    [argus setObject:args[key] forKey:key];
//                }
//            }
//        }
//        [myObj pSelector:selectorNormal withObjects:argus];
//        return true;
//    }
//    return false;
//}


