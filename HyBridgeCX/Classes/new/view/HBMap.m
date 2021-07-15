//
//  HBMap.m
//  Pods
//
//  Created by CX02 on 2017/11/24.
//
//

#import <Foundation/Foundation.h>
#import "HBArray.h"
#import "HBCallback.h"
#import "HBMap.h"
@implementation HBMap{
    NSMutableDictionary* mDic;
}
#pragma mark -  private
- (void)setMyMap:(NSMutableDictionary*)Dic{
    mDic = Dic;
}
- (void)setMyMap{
    mDic = [[NSMutableDictionary alloc] init];
}
#pragma mark -  写入
- (NSObject*)getDic{
    return mDic;
}
+ (HBMap*)setDic:(NSMutableDictionary*)dic{
    HBMap *HbDic = [[HBMap alloc] init];
    [HbDic setMyMap:dic];
    return HbDic;
}
+ (HBMap*)setDic{
    HBMap *HbDic = [[HBMap alloc] init];
    [HbDic setMyMap];
    return HbDic;
}
- (NSObject*)removeElement:(NSString *)name{
    [mDic removeObjectForKey:name];
    return mDic;
}
- (void)pushNull:(NSString*)key{
    [mDic setObject:nil forKey:key];
}
- (void)pushInt:(int)value key:(NSString *)key{
    NSNumber *num = [NSNumber numberWithInt:value];
    [mDic setObject:num forKey:key];
}
- (void)pushBoolean:(BOOL)value key:(NSString *)key{
    NSNumber *num = [NSNumber numberWithBool:value];
    [mDic setObject:num forKey:key];
}
- (void)pushDouble:(double)value key:(NSString *)key{
    NSNumber *num = [NSNumber numberWithDouble:value];
    [mDic setObject:num forKey:key];
}
- (void)pushString:(NSString *)value key:(NSString *)key{
    [mDic setObject:value forKey:key];
}
- (void)pushHBMap:(HBMap *)value key:(NSString *)key{
    [mDic setObject:value forKey:key];
}
- (void)pushCallback:(HBCallback *)value key:(NSString *)key {
    [mDic setObject:value forKey:key];
}
- (void)pushHBArray:(NSObject *)value key:(NSString *)key{
    [mDic setObject:value forKey:key];
}
#pragma mark -  读取

- (BOOL)isEmpty{
    return mDic.allKeys.count == 0 ? true:false;
}
- (BOOL)isNull:(NSString *)name{
    if (mDic == nil) {
        return true;
    }else{
        return false;
    }
}
- (BOOL)getBoolen:(NSString *)name{
    if ([mDic[name] isKindOfClass:[NSNumber class]]) {
        NSNumber *mBool = mDic[name];
        if (strcmp([mBool objCType], @encode(char)) == 0){
            return [mBool boolValue];
        }
        return false;
    }else{
        return false;
    }
}
- (double)getDouble:(NSString *)name{
    if ([mDic[name] isKindOfClass:[NSNumber class]]) {
        NSNumber *mDouble = mDic[name];
        if (strcmp([mDouble objCType], @encode(double)) == 0){
            return [mDouble doubleValue];
        }else{
            return 0.0;
        }
    }else{
        return 0.0;
    }
}
- (int)getInt:(NSString *)name{
    if ([mDic[name] isKindOfClass:[NSNumber class]]) {
        NSNumber *mInt = mDic[name];
        if (strcmp([mInt objCType], @encode(int)) == 0){
            return [mInt doubleValue];
        }else{
            return 0;
        }
    }else{
        return 0;
    }
}
- (NSString*)getString:(NSString *)name{
    if ([mDic[name] isKindOfClass:[NSString class]]) {
        return mDic[name];
    }
    else{
        return @"";
    }
}
- (HBMap*)getHBMap:(NSString *)name{
    return [self get:name];
}
- (HBCallback*)getCallback:(NSString *)name{
    if ([self get:name] && [[self get:name] isKindOfClass:[HBCallback class]]) {
        return [self get:name];
    }
    return nil;
}
- (NSObject*)getHBArray:(NSString*)name{
    return [self get:name];
}

- (NSMutableArray*)keySet{
    return mDic.allKeys;
}
- (NSObject*)get:(NSString *)name{
    return mDic[name];
}
- (BOOL)hasKey:(NSString *)name{
    return [mDic.allKeys containsObject:name];
}
- (NSString *)_serializeMessage:(id)message pretty:(BOOL)pretty{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:(NSJSONWritingOptions)(pretty ? NSJSONWritingPrettyPrinted : 0) error:nil] encoding:NSUTF8StringEncoding];
}
- (NSString*)convertToJs{
    NSString*str = [self _serializeMessage:mDic pretty:NO];
    return str;
}
@end
