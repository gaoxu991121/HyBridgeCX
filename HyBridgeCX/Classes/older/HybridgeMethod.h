//
//  HybridgeMethod.h
//  @HIT
//
//  Created by CX02 on 2017/11/1.
//  Copyright © 2017年 FuWen. All rights reserved.
//

#import "CommonMethod.h"
#ifndef Header_h
#define Header_h


#endif /* Header_h */
@interface HyBridgeMethod : NSObject
@property (strong, nonatomic) NSMutableArray* ModelName;
@property (strong, nonatomic) NSMutableDictionary* responseCallbacks;
@property (strong, nonatomic) NSMutableDictionary* messageHandlers;
@property (strong,nonatomic) NSString* mClassName;
@property (strong,nonatomic) NSString* JsCommand;
@property (strong,nonatomic) NSString* MyProtocol;
@property (strong, nonatomic) NSMutableDictionary* mMethod;
@property (nonatomic) bool mIsStatic;

//@property (strong, nonatomic)CommonMethod* mGetMethod;
//@property (strong, nonatomic) WVJBHandler messageHandler;
+ (instancetype)test;
@end

//
//
//

