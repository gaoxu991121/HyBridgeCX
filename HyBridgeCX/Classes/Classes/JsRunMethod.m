//
//  JsRunMethod.m
//  Pods
//
//  Created by CX02 on 2017/11/26.
//
//

#import <Foundation/Foundation.h>
#import "JsRunMethod.h"
@implementation JsRunMethod{
    
}
- (NSString*)methodName{
    return @"";
}
- (BOOL)isPrivate{
    return true;
}
- (NSString*)executeJs{
    return @"";
}
- (NSString*)getMethod{
    NSString* builder = [[NSString alloc] init];
    if ([self isPrivate]) {
        builder = [[builder stringByAppendingString:@"    function "]
                            stringByAppendingString:[self methodName]];
    }else{
        builder = [[[builder stringByAppendingString:@"    this."]
                             stringByAppendingString:[self methodName]]
                             stringByAppendingString:@" = function"];
    }
    NSString* exec = [self executeJs];
    if (![exec hasSuffix:@";"]) {
        exec = [exec stringByAppendingString:@";\n"];
    }
    builder = [builder stringByAppendingString:exec];
    return builder;
}
@end
