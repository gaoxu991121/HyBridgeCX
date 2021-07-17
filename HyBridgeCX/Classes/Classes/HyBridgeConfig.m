//
//  HyBridgeConfig.m
//  Pods
//
//  Created by CX02 on 2017/11/22.
//
//

#import <Foundation/Foundation.h>
#import "HyBridgeConfig.h"
#import "JsModule.h"
static NSString *DEFAULT_PROTOCOL = @"HyBridge";
static int DEFAULT_VERSION = 1;
@implementation HyBridgeConfig {
    NSString *mProtocol;
    NSString *mReadyMethod;
    int mVersion;
    BOOL mDebug;
    NSMutableArray *mDefaultModules;
}
static HyBridgeConfig* _instance = nil;
- (void)HyBridgeConfigImpl{
    mDefaultModules = [[NSMutableArray alloc] init];
}
//public
+ (instancetype)getSetting{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    return _instance;
}
- (instancetype)mountDefaultModule:(NSMutableArray *)modules{
    if (modules.count != 0) {
        mDefaultModules = [[NSMutableArray alloc] init];
        for (JsModule *module in modules) {
            [mDefaultModules addObject:module];
        }
    }
    NSLog(@"%lu", [self getDefaultModule].count);
    return self;
}
- (NSMutableArray*)getDefaultModule{
    return mDefaultModules;
}
- (instancetype)setProtocol:(NSString *)protocol{
    mProtocol = protocol;
    return self;
}
-(instancetype)setReadyMethod:(NSString *)readyMethod{
    mReadyMethod = readyMethod;
    return self;
}
- (instancetype)setVersion:(int)version{
    mVersion = version;
    return self;
}
- (int)getVersion{
        if (mVersion == 0) {
            return DEFAULT_VERSION;
        }else{
            return mVersion;
        }
}
- (NSString*)getProtocol{
    if (mProtocol == nil) {
        return DEFAULT_PROTOCOL;
    }else{
        return mProtocol;
    }
}
- (NSString*)getReadyMethod{
    if (mReadyMethod == nil) {
        return [NSString stringWithFormat:@"on%@Ready",[self getProtocol]];
    }else{
        return mReadyMethod;
    }
}
- (instancetype)debugMode:(BOOL)debug{
    mDebug = debug;
    return self;
}
- (BOOL)isDebug{
    return mDebug;
}
@end

