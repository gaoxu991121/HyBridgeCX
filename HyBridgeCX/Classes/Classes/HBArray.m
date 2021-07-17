//
//  HBArray.m
//  Pods
//
//  Created by CX02 on 2017/11/24.
//
//

#import <Foundation/Foundation.h>
#import "HBArray.h"
#import "JsArgumentType.h"
@implementation HBArray {
    NSMutableArray* mArray;
}
#pragma mark -  private
- (void)setMarray:(NSMutableArray*)mArr{
    mArray = mArr;
}
- (void)setMarray{
    mArray = [[NSMutableArray alloc] init];
}
#pragma mark -  写入
- (void)pushNull{
    [mArray addObject:nil];
}
- (void)pushInt:(int)value{
    [mArray addObject:[NSNumber numberWithInt:value]];
}
- (void)pushBoolean:(BOOL)value{
    [mArray addObject:[NSNumber numberWithBool:value]];
}
- (void)pushDouble:(double)value{
    [mArray addObject:[NSNumber numberWithDouble:value]];
}
- (void)pushString:(NSString *)value{
    [mArray addObject:value];
}
- (void)pushHBMap:(HBMap *)value{
    [mArray addObject:value];
}
- (void)pushHBArray:(HBArray *)value{
    [mArray addObject:value];
}
- (void)pushCallback:(HBCallback *)value{
    [mArray addObject:value];
}
#pragma mark -  读取
- (NSObject*)getArray{
    return mArray;
}
+(HBArray *)setArray:(NSMutableArray *)arr{
    HBArray *HbArray = [[HBArray alloc] init];
    [HbArray setMarray:arr];
    HbArray.mIsInit = true;
    return HbArray;
}
+(HBArray *)setArray{
    HBArray *HbArray = [[HBArray alloc] init];
    [HbArray setMarray];
    HbArray.mIsInit = true;
    return HbArray;
}
- (NSString *)_serializeMessage:(id)message pretty:(BOOL)pretty{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:(NSJSONWritingOptions)(pretty ? NSJSONWritingPrettyPrinted : 0) error:nil] encoding:NSUTF8StringEncoding];
}
- (NSString*)convertToJs{
    NSString*str = [self _serializeMessage:mArray pretty:NO];
    return str;
}
- (int)size{
    int size = mArray.count;
    return size;
}
- (BOOL)isEmpty{
    if (self.size == 0) {
        return true;
    }else{
        return false;
    }
}
- (BOOL)isNull:(int)index{
    if ([self get:index] != nil) {
        return true;
    }else{
        return false;
    }
}
#pragma mark -  有点问题一定要确定他是bool值--解决

- (BOOL)getBoolean:(int)index{
    if ([mArray[index] isKindOfClass:[NSNumber class]]) {
        NSNumber *mBool = mArray[index];
        if (strcmp([mBool objCType], @encode(char)) == 0){
            return [mBool boolValue];
        }
        return false;
    }else{
        return false;
    }
}

- (double)getDouble:(int)index{
    if ([mArray[index] isKindOfClass:[NSNumber class]]) {
        NSNumber *mDouble = mArray[index];
        if (strcmp([mDouble objCType], @encode(double)) == 0){
            return [mDouble doubleValue];
        }else{
            return 0.0;
        }
    }else{
        return 0.0;
    }
}
- (int)getInt:(int)index{
    if ([mArray[index] isKindOfClass:[NSNumber class]]) {
        NSNumber *mInt = mArray[index];
        if (strcmp([mInt objCType], @encode(int)) == 0){
            return [mInt doubleValue];
        }else{
            return 0;
        }
    }else{
        return 0;
    }
}
- (NSString*)getString:(int)index{
    if ([mArray[index] isKindOfClass:[NSString class]]) {
        return mArray[index];
    }
    else{
        return @"";
    }
}
- (HBArray*)getHBArray:(int)index{
    HBArray *mArr = [self get:index];
    return mArr;
}
- (HBMap*)getHBMap:(int)index{
    HBMap *mMap = [self get:index];
    return mMap;
}
- (HBCallback*)getCallback:(int)index{
    HBCallback *mCallback = [self get:index];
    return mCallback;
}
- (int)getType:(int)index{
    if ([self get:index] == nil) {
        return[JsArgumentType TYPE__UNDEFINE] ;
    }
    return[JsArgumentType TYPE__UNDEFINE];
}
- (NSObject*)get:(int)index{
    int mIndex = index - 1;
    if (mArray.count >= mIndex) {
        return mArray[mIndex];
    }else{
        return nil;
    }
}

@end
