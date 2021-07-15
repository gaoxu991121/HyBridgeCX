//
//  JSMethod.h
//  @HIT
//
//  Created by CX02 on 2017/11/1.
//  Copyright © 2017年 FuWen. All rights reserved.
//
#import <objc/runtime.h>
#import <objc/message.h>
#import "JsModule.h"
#ifndef JsMethod_h
#define JsMethod_h

typedef bool myBool;
#endif /* JsMethod_h */
@interface JsMethod : NSObject
+ (JsMethod*)create:(JsModule*)jsModule javaMethod:(Method*)javaMethod methodName:(NSString*)methodName parameterTypeList:(NSMutableArray*)parameterTypeList hasReturn:(BOOL)hasReturn protocol:(NSString*)protocol level:(int)level;
- (void)Jsmethod;
- (Method*)getMethod;
- (void)setJavaMethod:(Method*)javaMethod;
- (JsModule*)getModule;
- (void)setModule:(JsModule*)module;
- (NSString*)getMethodName;
- (void)setMethodName:(NSString*)methodName;
- (BOOL)isHasReturn;
- (void)setHasReturn:(BOOL)hasReturn;
- (NSMutableArray*)getParameterType;
- (void)setParameterType:(NSMutableArray*)parameterType;
- (BOOL)isIsStatic;
- (NSString*)getprotocol;
- (void)setProtocol:(NSString*)protocol;
- (NSString*)getCallBack;
- (NSString*)getInjectJs;
- (NSObject*)invoke:(NSMutableArray*)args;
//test

@end
