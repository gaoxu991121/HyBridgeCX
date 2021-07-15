//
//  MyModel.m
//  @HIT
//
//  Created by CX02 on 2017/11/1.
//  Copyright © 2017年 FuWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyModel.h"
#import "MyViewController.h"
typedef bool myBool;
@implementation myModel {
}
- (WKWebView*) getwebview{
    return self.mWebview;
}
- (NSString*)getModule{
    return @"";
}
- (NSMutableArray*)pSelector:(SEL)selector withObjects:(NSDictionary *)objects
{
    
    myBool *t = true;
    myBool *f = false;
    // 方法签名(方法的描述)
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    if (signature == nil) {
        //可以抛出异常也可以不操作。
    }
    // NSInvocation : 利用一个NSInvocation对象包装一次方法调用（方法调用者、方法名、方法参数、方法返回值）
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = selector;
    // 设置参数
    NSInteger paramsCount = signature.numberOfArguments - 2; // 除self、_cmd以外的参数个数
    paramsCount = MIN(paramsCount, objects.allKeys.count);
    for (NSInteger i = 0; i < paramsCount; i++) {
        NSString *str = @"TYPE__BOOL";
        NSString *str1 = @"TYPE__INT";
        NSString *str1_1 = @"TYPE__DOUBLE";
        NSString *str2 = @"TYPE__BOOL_true";
        //        调整int，bool
        //        先遍历字典然后确定数组的索引
        //        再遍历字典找到对应顺序的值（字典是无序的）
        for (NSInteger index = 0; index < paramsCount; index++) {
            if ([objects.allKeys[index] rangeOfString:[NSString stringWithFormat:@"%lu", i]].location != NSNotFound) {
                //              是否为bool
                if ([objects.allKeys[index] rangeOfString:str].location != NSNotFound) {
                    if ([objects.allKeys[index] rangeOfString:str2].location != NSNotFound) {
                        [invocation setArgument:&t atIndex:i + 2];
                    }else{
                        [invocation setArgument:&f atIndex:i + 2];
                    }
                }else{
                    //先转成string再转成intger
                    if ([objects.allKeys[index] rangeOfString:str1].location != NSNotFound || [objects.allKeys[index] rangeOfString:str1_1].location != NSNotFound) {
                        NSString *object = objects[objects.allKeys[index]];
                        NSInteger *IntArgument = [object integerValue];
                        [invocation setArgument:&IntArgument atIndex:i + 2];
                    }else{
                        id object = objects[objects.allKeys[index]];
                        if ([object isKindOfClass:[NSNull class]]) continue;
                        [invocation setArgument:&object atIndex:i + 2];
                    }
                }
            }
        }
    }
    // 调用方法
    [invocation invoke];
    // 获取返回值
    NSObject *returnValue = [[NSMutableArray alloc] init];
    
    if (signature.methodReturnLength) { // 有返回值类型，才去获得返回值
        [invocation getReturnValue:&returnValue];
    }
    return returnValue;
}
- (UIViewController *)getCurrentViewController
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    result = [UITabBarController class];
    for (UIView * uiview in [window subviews]) {
        result = [UITabBarController class];
        myModel* mModel = [[myModel alloc]init];
        UIView* WkView = [mModel getView:uiview];
        for (UIView* next = WkView; next; next = next.superview) {
            UIResponder *nextResponder = [next nextResponder];
            NSLog(nextResponder.description);
            if ([nextResponder isKindOfClass:[MyViewController class]]) {
                UIViewController *presentView = nextResponder;
                result = presentView;
            }
        }
        return result;
    }
    return result;
}

-(UIView*)getView:(UIView *)myView{
    UIView *WKView = nil;
    if ([[[myView subviews] objectAtIndex:0] isKindOfClass:[WKWebView class]]) {
        return [[myView subviews] objectAtIndex:0];
    }else{
        UIView *view = [[myView subviews] objectAtIndex:0];
        myModel* model = [[myModel alloc]init];
        return [model getView:view];
    }
}
- (NSObject*)mSelector:(SEL)selector withObjects:(NSMutableArray *)objects
{
    
    //    myBool *t = true;
    //    myBool *f = false;
    //    // 方法签名(方法的描述)
    //    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    //    if (signature == nil) {
    //        //可以抛出异常也可以不操作。
    //    }
    //    // NSInvocation : 利用一个NSInvocation对象包装一次方法调用（方法调用者、方法名、方法参数、方法返回值）
    //    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    //    invocation.target = self;
    //    invocation.selector = selector;
    //    // 设置参数
    //    NSInteger paramsCount = signature.numberOfArguments - 2; // 除self、_cmd以外的参数个数
    //    paramsCount = MIN(paramsCount, objects.count);
    //    for (NSInteger i = 0; i < paramsCount; i++) {
    ////        NSString *str = @"TYPE__BOOL";
    ////        NSString *str1 = @"TYPE__INT";
    ////        NSString *str1_1 = @"TYPE__DOUBLE";
    ////        NSString *str2 = @"TYPE__BOOL_true";
    ////                调整int，bool
    ////                先遍历字典然后确定数组的索引
    ////                再遍历字典找到对应顺序的值（字典是无序的）
    ////        for (NSInteger index = 0; index < paramsCount; index++) {
    ////            if ([objects.allKeys[index] rangeOfString:[NSString stringWithFormat:@"%lu", i]].location != NSNotFound) {
    ////                //              是否为bool
    ////                if ([objects.allKeys[index] rangeOfString:str].location != NSNotFound) {
    ////                    if ([objects.allKeys[index] rangeOfString:str2].location != NSNotFound) {
    ////                        [invocation setArgument:&t atIndex:i + 2];
    ////                    }else{
    ////                        [invocation setArgument:&f atIndex:i + 2];
    ////                    }
    ////                }else{
    ////                    //先转成string再转成intger
    ////                    if ([objects.allKeys[index] rangeOfString:str1].location != NSNotFound || [objects.allKeys[index] rangeOfString:str1_1].location != NSNotFound) {
    ////                        NSString *object = objects[objects.allKeys[index]];
    ////                        NSInteger *IntArgument = [object integerValue];
    ////                        [invocation setArgument:&IntArgument atIndex:i + 2];
    ////                    }else{
    ////                        id object = objects[objects.allKeys[index]];
    ////                        if ([object isKindOfClass:[NSNull class]]) continue;
    ////                        [invocation setArgument:&object atIndex:i + 2];
    ////                    }
    ////                }
    ////            }
    ////        }
    ////    }
    //    // 调用方法
    //    [invocation invoke];
    //    // 获取返回值
    //    NSObject *returnValue = [[NSMutableArray alloc] init];
    //    
    //    if (signature.methodReturnLength) { // 有返回值类型，才去获得返回值
    //        [invocation getReturnValue:&returnValue];
    //    }
    //   return returnValue;
    
    
    
    return @"";
}

@end

