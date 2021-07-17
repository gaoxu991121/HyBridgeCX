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
