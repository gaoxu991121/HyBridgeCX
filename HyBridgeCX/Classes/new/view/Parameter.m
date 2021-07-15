//
//  Parameter.m
//  Pods
//
//  Created by CX02 on 2017/11/21.
//
//
#import <Foundation/Foundation.h>
#import "Parameter.h"
#import "HBArray.h"
#import "JsObject.h"
#import <objc/runtime.h>
#import <objc/message.h>
//#define __klmurl_macro_concat_inner(A, B) A##B
//#define __klmurl_macro_concat(a,b) __klmurl_macro_concat_inner(a, b)
//#define path(...) \
//compatibility_alias __klmurl_macro_concat(_KLMURL_ , __COUNTER__) KLMURL; \
//- (id)__klmurl_macro_concat( __klmurl_path_ , __COUNTER__ ) { \
//return __VA_ARGS__ ;\

@implementation Parameter {
}

- (void)SetName:(NSString *)name{
    self.name = name;
}
- (NSString*)GetName{
    return self.name;
}
- (void)SetType:(NSNumber*)type{
    self.type = type;
}
- (int)GetType{
    
    return [self.type intValue];
}
- (void)SetValue:(NSString *)value{
    self.value = value;
}
- (NSObject*)GetValue{
    return self.value;
}




//- (void)installDispatcher {
//    Class clz = [_delegate class];
//    _dispatchs = [NSMutableArray array];
//    NSMutableArray<KLMURLDispatcherRule *> *tempRules = [NSMutableArray array];
//    KLMURLDispatcherRule *tempRules = nil;
//    
//    unsigned int methodCount = 0;
//    Method *methods = class_copyMethodList(clz, &methodCount);
//    
//    for (unsigned int i = 0; i < methodCount; i++) {
//        Method method = methods[i];
//        
//        NSString *name = [NSString stringWithCString:sel_getName(method_getName(method)) encoding:NSASCIIStringEncoding];
//        if ([name hasPrefix:@"__klmurl_"]) {//如果是一条注解
//            name = [name substringFromIndex:9];
//            if (!tempRule) tempRule = [KLMURLDispatcherRule create];
//            tempRule.path = [_delegate performSelector:method_getName(method)];
//            //.......
//        } else {//如果是一个真正的方法
//            if (tempRule) {
//                [tempRules addObject:tempRule];
//                tempRule = nil;//清空temp
//            }
//            if (tempRules.count) {
//                KLMURLDispatcherSelector *sel = [[KLMURLDispatcherSelector alloc] init];
//                sel.methods = method;
//                sel.rules = tempRules;
//                [_dispatchs addObject:sel];//绑定方法和temp内容
//                
//                tempRules = [NSMutableArray array];//清空temp
//            }
//        }
//    }
//    free(methods);
//    
//    NSLog(@"%@",_dispatchs);
//}
//



- (void)array:(NSObject*)array{
    NSLog(@"test");
    NSLog(@"%@", [[array class] description]);
    if ([array conformsToProtocol:@protocol(JsObject)]) {
        NSLog(@"test this method");
    }
    SEL sele = NSSelectorFromString(@"convertToJs");
    NSString *tet = [array performSelector:sele];
    NSLog(@"%@", tet);
}
@end
