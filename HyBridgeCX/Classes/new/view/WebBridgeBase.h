//
//  WebBridgeBase.h
//  @HIT
//
//  Created by CX02 on 2017/11/1.
//  Copyright © 2017年 FuWen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kOldProtocolScheme @"wvjbscheme"
#define kNewProtocolScheme @"https"
#define kQueueHasMessage   @"__wvjb_queue_message__"
#define kBridgeLoaded      @"__bridge_loaded__"

typedef void (^WVJBResponseCallback)(id responseData);
typedef void (^WVJBHandler)(id data, WVJBResponseCallback responseCallback);
typedef NSDictionary WVJBMessage;

@protocol WebBridgeBaseDelegate <NSObject>
- (NSString*) _evaluateJavascript:(NSString*)javascriptCommand;
@end

@interface WebBridgeBase : NSObject


@property (weak, nonatomic) id <WebBridgeBaseDelegate> delegate;
@property (strong, nonatomic) NSMutableArray* startupMessageQueue;
@property (strong, nonatomic) NSMutableDictionary* responseCallbacks;
@property (strong, nonatomic) NSMutableDictionary* messageHandlers;
@property (strong, nonatomic) WVJBHandler messageHandler;

+ (void)enableLogging;
+ (void)setLogMaxLength:(int)length;
- (void)reset;
- (void)sendData:(id)data responseCallback:(WVJBResponseCallback)responseCallback handlerName:(NSString*)handlerName;
- (void)flushMessageQueue:(NSString *)messageQueueString;
- (void)injectJavascriptFile;
- (BOOL)isWebViewJavascriptBridgeURL:(NSURL*)url;
- (BOOL)isQueueMessageURL:(NSURL*)urll;
- (BOOL)isBridgeLoadedURL:(NSURL*)urll;
- (void)logUnkownMessage:(NSURL*)url;
- (NSString *)webViewJavascriptCheckCommand;
- (NSString *)webViewJavascriptFetchQueyCommand;
- (void)disableJavscriptAlertBoxSafetyTimeout;

@end
//
//unsigned int count;
//id myObj = [[NSClassFromString(@"projectNamePsJson") alloc] init];
//Class test = [myObj class];
//Method *methodList = class_copyMethodList(test, &count);
//Method *methodJson = &methodList[0];
//NSDictionary *argument = [myObj performSelector:method_getName(*methodJson) withObject:prompt];
//NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//bool bo = true;
//[dict setObject:[NSNumber numberWithBool:true] forKey:@"success"];
//[dict setObject:@"test" forKey:@"msg"];
//Callback *toJson = [[Callback alloc] init];
//NSString *JsonString = [toJson _serializeMessage:dict pretty:true];
//[self test:completionHandler];
