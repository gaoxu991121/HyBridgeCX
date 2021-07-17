//  HyBridgeConfig.h
//  Pods
//
//  Created by CX02 on 2017/11/22.
//
//

#ifndef HyBridgeConfig_h
#define HyBridgeConfig_h


#endif /* HyBridgeConfig_h */
@interface HyBridgeConfig : NSObject
+ (instancetype)getSetting;
- (instancetype)mountDefaultModule:(NSMutableArray*)modules;
- (instancetype)setProtocol:(NSString*)protocol;
- (instancetype)setReadyMethod:(NSString*)readyMethod;
- (instancetype)setVersion:(int)version;
- (instancetype)debugMode:(BOOL)debug;
- (int)getVersion;
- (NSString*)getProtocol;
- (NSString*)getReadyMethod;
- (NSMutableArray*)getDefaultModule;
- (BOOL)isDebug;
@end
