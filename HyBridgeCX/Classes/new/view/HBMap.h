//
//  HBMap.h
//  Pods
//
//  Created by CX02 on 2017/11/24.
//
//
#import "HBCallback.h"
#import "JsObject.h"
#import "HBArray.h"
#ifndef HBMap_h
#define HBMap_h

//typedef HBArray myArray;
#endif /* HBMap_h */
@interface HBMap : NSObject<JsObject>{
}
- (BOOL)isEmpty;
- (BOOL)hasKey:(NSString*)name;
- (BOOL)isNull:(NSString*)name;
- (BOOL)getBoolen:(NSString*)name;
- (double)getDouble:(NSString*)name;
- (int)getInt:(NSString*)name;
- (NSString*)getString:(NSString*)name;
- (HBCallback*)getCallback:(NSString*)name;
- (HBMap*)getHBMap:(NSString*)name;
- (NSMutableArray*)keySet;
- (NSObject*)get:(NSString*)name;
- (NSObject*)getHBArray:(NSString*)name;
#pragma mark - 初始化
+ (HBMap*)setDic:(NSMutableDictionary*)dic;
+ (HBMap*)setDic;
- (NSObject*)getDic;
#pragma mark -  写入

- (void)pushNull:(NSString*)key;
- (void)pushBoolean:(BOOL)value key:(NSString*)key;
- (void)pushDouble:(double)value key:(NSString*)key;
- (void)pushInt:(int)value key:(NSString*)key;
- (void)pushString:(NSString*)value key:(NSString*)key;
- (void)pushHBArray:(NSObject*)value key:(NSString*)key;
- (void)pushHBMap:(HBMap*)value key:(NSString*)key;
- (void)pushCallback:(HBCallback*)value key:(NSString*)key;
- (NSObject*)removeElement:(NSString *)name;
@end
