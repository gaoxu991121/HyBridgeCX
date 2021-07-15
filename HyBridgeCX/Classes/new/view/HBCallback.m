//
//  HBCallback.m
//  Pods
//
//  Created by CX02 on 2017/11/24.
//
//

#import <Foundation/Foundation.h>
#import "HBCallback.h"
#import "JSMethod.h"
#import "HBUtils.h"
@implementation HBCallback{
    NSString* mName;
    JsMethod* mMethod;
}

//public
+ (instancetype)HBCallbackImpl:(NSString *)name method:(JsMethod *)method{
    HBCallback* Callback = [[HBCallback alloc] init];
    [Callback mSet:name method:method];
    return Callback;
}
- (void)mSet:(NSString *)name method:(JsMethod *)method{
    mName = name;
    mMethod = method;
}
- (void)apply:(NSMutableArray *)args{
    if (mMethod == nil || mMethod.getModule == nil || mMethod.getModule.mWebview == nil || mName == nil || [mName isEqualToString:@""]) {
        return;
    }
    NSString* callback = [mMethod getCallBack];
    NSString* builder = @"builder:";
    builder = [[[[[[[[[[[[[[builder stringByAppendingString:@"if (" ]                    stringByAppendingString: callback ]
        stringByAppendingString: @" && " ]
        stringByAppendingString: callback ]
        stringByAppendingString: @"['" ]
        stringByAppendingString: mName ]
        stringByAppendingString: @"']) {" ]
        stringByAppendingString:@"var callback = " ]
        stringByAppendingString: callback]
        stringByAppendingString: @"['" ]
        stringByAppendingString: mName ]
        stringByAppendingString: @"'];" ]
        stringByAppendingString:@"if (typeof callback === 'function') {" ]
        stringByAppendingString:@"callback("];
    if (args != nil && args.count > 0 ) {
        for (NSUInteger i = 0;i < args.count;i++) {
            builder = [builder stringByAppendingString:[HBUtils toJsObject:args[i]] == nil ? @"" : [HBUtils toJsObject:args[i]]];
            if (args.count - 1 != i) {
                builder = [builder stringByAppendingString:@","];
            }
        }
    }
    builder = [[[[builder stringByAppendingString:@")} else {" ]
        stringByAppendingString:@"console.error(callback + ' is not a function')" ]
        stringByAppendingString:@"}" ]
        stringByAppendingString:@"}"];
    [[[mMethod getModule] mWebview] evaluateJavaScript:builder completionHandler:nil];
    NSLog(@"%@", builder);
}
@end
