//
//  Callback.m
//  @HIT
//
//  Created by CX02 on 2017/11/1.
//  Copyright © 2017年 FuWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Callback.h"
#import <WebKit/WebKit.h>
typedef NSString MyString;
@implementation Callback {
}
//+ (instancetype)callback:(NSString*)callbackID{
//    Callback *callback = [[Callback alloc] init];
//    callback.CallbackID = callbackID;
//    return callback;
//}
- (NSString *)_serializeMessage:(id)message pretty:(BOOL)pretty{
    if (pretty) {
        NSLog(@"it is true!!!");
    }
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:(NSJSONWritingOptions)(pretty ? NSJSONWritingPrettyPrinted : 0) error:nil] encoding:NSUTF8StringEncoding];
}
- (void)apply:(NSMutableArray*)arguments{
    NSLog(@"xiai😊⬇️🦐");
    if (_webview) {
        if (_callback) {
            NSString *javascript = @"javascript:";
            javascript = [[[[[[[[[[[[[[javascript stringByAppendingString:@"if (" ]                     stringByAppendingString: _callback ]
                stringByAppendingString: @" && " ]
                stringByAppendingString: _callback ]
                stringByAppendingString: @"['" ]
                stringByAppendingString: _CallbackID ]
                stringByAppendingString: @"']) {" ]
                stringByAppendingString:
                @"var callback = " ]
                stringByAppendingString: _callback]
                stringByAppendingString: @"['" ]
                stringByAppendingString: _CallbackID ]
                stringByAppendingString: @"'];" ]
                stringByAppendingString:
                @"if (typeof callback === 'function') {" ]
                stringByAppendingString:
                @"callback("];
            if (arguments.count != 0) {
                for (NSInteger index = 0; index < arguments.count; index++) {
                    if ([arguments[index] isKindOfClass: [NSString class]] || [arguments[index] isKindOfClass: [NSArray class]] || [arguments[index] isKindOfClass: [NSDictionary class]]) {
                        if ([arguments[index] isKindOfClass: [NSArray class]] || [arguments[index] isKindOfClass: [NSDictionary class]]) {
                            arguments[index] = [self _serializeMessage:arguments[index] pretty:NO];
                            javascript = [javascript stringByAppendingString:arguments[index]];
                        }else{
                        arguments[index] = [arguments[index] stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
                        arguments[index] = [arguments[index] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                        arguments[index] = [arguments[index] stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
                        arguments[index] = [arguments[index] stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
                        arguments[index] = [arguments[index] stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
                        arguments[index] = [arguments[index] stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
                        arguments[index] = [arguments[index] stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
                        arguments[index] = [arguments[index] stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
                        NSString *StringArgument  = @"'";
                        StringArgument = [[StringArgument stringByAppendingString:arguments[index]] stringByAppendingString:@"'"];
                        javascript = [javascript stringByAppendingString:StringArgument];
                        }
                    }if ([arguments[index] isKindOfClass: [NSNumber class]]) {
                        NSString *str = [NSString stringWithFormat:@"%@", arguments[index]];
                        javascript = [javascript stringByAppendingString:str];
                    };
                    if (index != (arguments.count - 1)) {
                        javascript = [javascript stringByAppendingString:@","];
                    }
                }
            }
            javascript = [[[[javascript stringByAppendingString:@")} else {" ]             stringByAppendingString:
                    @"console.error(callback + ' is not a function')" ] stringByAppendingString:
                    @"}" ] stringByAppendingString:
                    @"}"];
            [_webview evaluateJavaScript:javascript completionHandler:nil];
            NSLog(@"%@", javascript);
        }
    }
}
- (void)GetWebview:(WKWebView*)web{
    _webview = web;
}
- (void)GetBack:(NSString*)Callback{
    _callback = Callback;
}
@end
