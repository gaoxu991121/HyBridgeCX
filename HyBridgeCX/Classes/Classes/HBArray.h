//
//  HBArray.h
//  Pods
//
//  Created by CX02 on 2017/11/24.
//
//
#import "HBMap.h"
#import "HBCallback.h"
#import "JsObject.h"
#ifndef HBArray_h
#define HBArray_h


#endif /* HBArray_h */
@interface HBArray : NSObject<JsObject>
@property (nonatomic) BOOL mIsInit;
- (void)addMyValue:(NSObject*)element;
- (int)size;
- (BOOL)isEmpty;
- (BOOL)isNull:(int)index;
- (BOOL)getBoolean:(int)index;
- (double)getDouble:(int)index;
- (int)getInt:(int)index;
- (NSString*)getString:(int)index;
- (HBArray*)getHBArray:(int)index;
- (HBMap*)getHBMap:(int)index;
- (HBCallback*)getCallback:(int)index;
- (int)getType:(int)index;
- (NSObject*)get:(int)index;
#pragma mark -  初始化
+ (HBArray*)setArray;
+ (HBArray*)setArray:(NSMutableArray*)arr;
- (NSObject*)getArray;
#pragma mark -  写入

- (void)pushNull;
- (void)pushBoolean:(BOOL)value;
- (void)pushDouble:(double)value;
- (void)pushInt:(int)value;
- (void)pushString:(NSString*)value;
- (void)pushHBArray:(HBArray*)value;
- (void)pushHBMap:(HBMap*)value;
- (void)pushCallback:(HBCallback*)value;
@end

