//
//  Callbsck.h
//  @HIT
//
//  Created by CX02 on 2017/11/1.
//  Copyright © 2017年 FuWen. All rights reserved.
//
//

#import <WebKit/WebKit.h>
#ifndef Callback_h
#define Callback_h


#endif /* Callback_h */
@interface Callback : NSObject
@property (strong,nonatomic) NSString* CallbackID;
@property (strong, nonatomic) WKWebView *webview;
@property (strong,nonatomic) NSString* callback;
- (void)apply:(NSMutableArray*)arguments;
- (NSString *)_serializeMessage:(id)message pretty:(BOOL)pretty;
@end
