//
//  MethodMap.m
//  Alamofire
//
//  Created by CX02 on 2017/12/2.
//

#import <Foundation/Foundation.h>
#import "MethodMap.h"
#import "HBBaseWebView.h"
static NSMutableDictionary *methodLevel;
@implementation MethodMap{
    
}
- (NSMutableDictionary*)setLevel{
    methodLevel = [[NSMutableDictionary alloc]init];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"@STATIC.toast"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Network.request"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"Network.removeAllCookie"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Storage.setStorage"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Storage.getStorage"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Device.getDisplayMetrics"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Device.getAppInfo"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Device.getDeviceBuildInfo"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Interface.navigateTo"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Interface.toast"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Page.onResume"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Page.onPause"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Page.onStop"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Page.closeThis"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Event.register"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Event.post"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"User.qqLogin"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"User.weixinLogin"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"User.loginSuccess"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"User.reLogin"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"User.getDID"];
    return methodLevel;
}
+ (int)getMethodLevel:(NSString*)methodName{
    if (methodLevel == nil || methodLevel.allKeys.count == 0) {
        NSMutableDictionary *levelMap =  [[self alloc] setLevel];
        if (![levelMap.allKeys containsObject:methodName]||levelMap[methodName] == nil) {
            NSLog(@"%@", methodName);
            return 0;
        }else{
            NSLog(@"%@", methodName);
            NSNumber *num = levelMap[methodName];
            return [num intValue];
        }
    }else{
        if (![methodLevel.allKeys containsObject:methodName]||methodLevel[methodName] == nil) {
            return 0;
        }else{
            NSNumber *num = methodLevel[methodName];
            return [num intValue];
        }
    }
}
//private

@end
