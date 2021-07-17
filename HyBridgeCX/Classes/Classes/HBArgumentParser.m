//
//  HBArgumentParser.m
//  Pods
//
//  Created by CX02 on 2017/11/20.
//
//

#import <Foundation/Foundation.h>
#import "JsArgumentType.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "HBArgumentParser.h"
#import "Parameter.h"
@implementation HBArgumentPaser {
}
- (long)GetId{
    return self.Id;
}
- (void)SetId:(long)ID{
    self.Id = ID;
}
- (NSString*)GetModule{
    return self.module;
}
- (void)SetModule:(NSString *)module{
    self.module = module;
}
- (NSString*)GetMethod{
    return self.method;
}
- (void)SetMethod:(NSString *)method{
    self.method = method;
}
- (NSMutableArray*)GetParameters{
    return self.Parameters;
}
- (void)SetParameters:(NSMutableArray *)parameters{
    self.Parameters = parameters ;
}
+ (instancetype)parse:(NSString *)jsonString{
    
    if ([jsonString isEqualToString:@"" ]|| jsonString == nil ||(![jsonString hasPrefix:@"{"] && ![jsonString hasPrefix:@"["])){
        return nil;
    }
    HBArgumentPaser *parser = [[HBArgumentPaser alloc] init];
    BOOL isYes = [NSJSONSerialization isValidJSONObject:jsonString];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id obj = [NSJSONSerialization JSONObjectWithData: jsonData options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *argument = obj;
    if (argument[@"id"] == nil || argument[@"method"] == nil) {
        return nil;
    }
    NSNumber* MyId = argument[@"id"];
    long tes = [MyId longValue];
    [parser SetMethod:argument[@"method"]];
    [parser SetId:tes];
    [parser SetModule:argument[@"module"]];
    NSMutableArray *parameterList;
    NSMutableArray *params = argument[@"parameters"];
    parameterList = [[NSMutableArray alloc]init];
    for (NSUInteger mindex = 0; mindex < params.count; mindex++) {
        NSDictionary*param = params[mindex];
        if (param == nil) {
            return nil;
        }
#pragma mark -  @"param value😊:%@"
        Parameter *parameter = [[Parameter alloc] init];
        if ([param objectForKey:@"name"]) {
            [parameter SetName:param[@"name"]];
        }
        if ([param objectForKey:@"type"]) {
            NSNumber *typeNum = param[@"type"];
            [parameter SetType:typeNum];
        }
        if ([param objectForKey:@"value"]) {
#pragma mark -  对布尔值特殊处理:
            if ([parameter GetType] == 1) {
                NSNumber *mBool = param[@"value"];
                if ([mBool boolValue]) {
                    [parameter SetValue:@"true"];
                }else{
                    [parameter SetValue:@"false"];
                }
            }
            [parameter SetValue:param[@"value"]];
        }
        [parameterList addObject:parameter];
    }
    [parser SetParameters:parameterList];
    return parser;
}
@end

