//
//  HBUtils.m
//  Pods
//
//  Created by CX02 on 2017/11/24.
//
//

#import <Foundation/Foundation.h>
#import "HBBaseWebView.h"
#import "MethodMap.h"
#import "PermissionLevel.h"
#import "HBArray.h"
#import "HBMap.h"
#import "Parameter.h"
#import "HBCallback.h"
#import "HBUtils.h"
#import "JsArgumentType.h"
#import <objc/runtime.h>
#import <objc/message.h>
@implementation HBUtils{
    
}
#pragma mark -  dic与array 要一直循环

+ (NSObject*)parseObjectLoop:(NSObject*)parser method:(JsMethod*)method{
    if (parser != nil) {
        if ([parser isKindOfClass:[NSNumber class]]) {
            NSNumber* mValue = parser;
            return mValue;
        }else if ([parser isKindOfClass:[NSString class]]){
            NSString *mValue = parser;
            if ([mValue hasPrefix:@"[Function]::"]) {
                NSString *function = [mValue stringByReplacingOccurrencesOfString:@"[Function]::" withString:@""];
                return [HBCallback HBCallbackImpl:function method:method];
            }else{
                return mValue;
            }
        }else if ([parser isKindOfClass:[NSDictionary class]]){
            HBMap *mMap = [HBMap setDic];
            NSDictionary *mDictionary = parser;
            for (NSUInteger i = 0; i < mDictionary.allKeys.count; ++i) {
                NSString *key = mDictionary.allKeys[i];
                NSObject *ret = [self parseObjectLoop:mDictionary[key] method:method];
                if (ret == nil) {
                    [mMap pushNull:key];
                    continue;
                }
                if ([ret isKindOfClass:[NSNumber class]]) {
                    NSNumber *mNum = ret;
                    if (strcmp([mNum objCType], @encode(char)) == 0){
                        [mMap pushBoolean:[mNum boolValue] key:key] ;
                    }else if(strcmp([mNum objCType], @encode(double)) == 0) {
                        [mMap pushDouble:[mNum doubleValue] key:key];
                    }else if(strcmp([mNum objCType], @encode(int)) == 0) {
                        [mMap pushInt:[mNum intValue] key:key];
                    }else{
                        [mMap pushDouble:[mNum doubleValue] key:key];
                    }
                }else if ([ret isKindOfClass:[NSString class]]){
                    NSString *mStr = ret;
                    [mMap pushString:mStr key:key];
                }else if ([ret isKindOfClass:[NSArray class]] || [ret isKindOfClass:[HBArray class]]){
                    if ([ret isKindOfClass:[HBArray class]]) {
                        HBArray *mHBArray = ret;
                        NSArray *mArray = [mHBArray getArray];
                        [mMap pushHBArray:mHBArray key:key];
                    }else{
                        NSArray *mArray = ret;
                        [mMap pushHBArray:mArray key:key];
                    }
                }else if ([ret isKindOfClass:[NSDictionary class]] || [ret isKindOfClass:[HBMap class]]){
                    if ([ret isKindOfClass:[HBMap class]]) {
                        HBMap *mHBMap = ret;
                        NSDictionary *mDic = [mHBMap getDic];
                        [mMap pushHBArray:mDic key:key];
                    }else{
                        NSDictionary *mDic = ret;
                        [mMap pushHBArray:mDic key:key];
                    }
                }else if ([ret isKindOfClass:[HBCallback class]]){
                    HBCallback *mCallback = ret;
                    [mMap pushCallback:mCallback key:key];
                }else{
                    [mMap pushNull:key];
                }
            }
            return mMap;
            
        }else if ([parser isKindOfClass:[NSArray class]]){
            HBArray *MyArray = [HBArray setArray];
            NSArray *mArr = parser;
            for (NSUInteger i = 0; i < mArr.count; ++i) {
                NSObject *ret = [self parseObjectLoop:mArr[i] method:method];
                if (ret == nil) {
                    [MyArray pushNull];
                    continue;
                }
                if ([ret isKindOfClass:[NSNumber class]]) {
                    NSNumber *mNum = ret;
                    if (strcmp([mNum objCType], @encode(char)) == 0){
                        [MyArray pushBoolean:[mNum boolValue]] ;
                    }else if(strcmp([mNum objCType], @encode(double)) == 0) {
                        [MyArray pushDouble:[mNum doubleValue]];
                    }else if(strcmp([mNum objCType], @encode(int)) == 0) {
                        [MyArray pushInt:[mNum intValue]];
                    }else{
                        [MyArray pushInt:[mNum intValue]];
                    }
                }else if ([ret isKindOfClass:[NSString class]]){
                    NSString *mStr = ret;
                    [MyArray pushString:mStr];
                }else if ([ret isKindOfClass:[NSArray class]] || [ret isKindOfClass:[HBArray class]]){
                    if ([ret isKindOfClass:[HBArray class]]) {
                        HBArray *mHBArray = ret;
                        NSArray *mArray = [mHBArray getArray];
                        [MyArray pushHBArray:mArray];
                    }else{
                        NSArray *mArray = ret;
                        [MyArray pushHBArray:mArray];
                    }
                }else if ([ret isKindOfClass:[NSDictionary class]] || [ret isKindOfClass:[HBMap class]]){
                    if ([ret isKindOfClass:[HBMap class]]) {
                        HBMap *mHBMap = ret;
                        NSDictionary *mDic = [mHBMap getDic];
                        [MyArray pushHBArray:mDic];
                    }else{
                        NSDictionary *mDic = ret;
                        [MyArray pushHBArray:mDic];
                    }
                }else if ([ret isKindOfClass:[HBCallback class]]){
                    HBCallback *mCallback = ret;
                    [MyArray pushCallback:mCallback];
                }else{
                    [MyArray pushNull];
                }
            }
            return MyArray;
        }
    }
    return parser;
}




+ (NSMutableDictionary*)getAllMethod:(WKWebView *)webview module:(JsModule *)module injectedCls:(Class)injectedCls protocol:(NSString *)protocol{
     unsigned int count;
    NSMutableDictionary *methodMultiValueMap = [[NSMutableDictionary alloc]init];
    Method *methodList = class_copyMethodList(injectedCls, &count);
    if (count == 0 || methodList == nil) {
        return methodMultiValueMap;
    }
    if (![webview conformsToProtocol:@protocol(PermissionLevel)]) {
        return methodMultiValueMap;
    }
    for (NSInteger mCount = 0; mCount < count; mCount++) {
        char dst;
        BOOL hasReturn;
        Method javaMethod = methodList[mCount];
        NSString *MethodName = NSStringFromSelector(method_getName(javaMethod));
        NSLog(@"@%",MethodName);
        MethodName = [MethodName stringByReplacingOccurrencesOfString:@":" withString:@""];
        NSString *methodLevelKey = [[[module modelName] stringByAppendingString:@"."] stringByAppendingString:MethodName];
        int WebLevel = [webview performSelector:NSSelectorFromString(@"containerLevel")];
        if ([MethodMap getMethodLevel:methodLevelKey] > WebLevel) {
            continue;
        }
        method_getReturnType(javaMethod, &dst, sizeof(char));
        NSString *hasRe = [NSString stringWithFormat:@"%c", dst];
        if ([hasRe isEqualToString:@"v"]) {
            hasReturn = false;
        }else{
            hasReturn = true;
        }
        JsMethod *createMethod = [JsMethod create:module javaMethod:&javaMethod methodName:MethodName parameterTypeList:nil hasReturn:hasReturn protocol:protocol level:0];
        [methodMultiValueMap setObject:createMethod forKey:MethodName];
    }
    return methodMultiValueMap;
    
}
+ (NSString*)moduleSplit:(NSString*)moduleName{
//    NSMutableArray *moduleGroup = [[NSMutableArray alloc]init];
//    unsigned int index = -1;
//    do {
//        int temp = moduleName;
//    } while (index >= 0);
//    [moduleGroup addObject:moduleName];
    return moduleName;
    
}

+ (NSObject*)parseToObject:(int)type Param:(Parameter*)Param method:(JsMethod*)method{

    if ([Param GetType] == [JsArgumentType TYPE__INT]) {
/*        int type1 = [Param GetType];
int type2 = [JsArgumentType TYPE__INT];
        if(type1 != type2){
            return nil;
        }*/
        NSNumber *value = [Param GetValue];
        return [Param GetValue];
    }else if ([Param GetType] == [JsArgumentType TYPE__DOUBLE]){
/*       int type1 = [Param GetType];
int type2 = [JsArgumentType TYPE__DOUBLE];
        if(type1 != type2){
            return nil;
        }*/
        NSNumber *value = [Param GetValue];
        return [Param GetValue];
    }else if ([Param GetType] == [JsArgumentType TYPE__STRING]){
/*        int type1 = [Param GetType];
        int type2 = [JsArgumentType TYPE__STRING];
        if(type1 != type2){
            return nil;
        }*/
        NSString *value = [Param GetValue];
        return [Param GetValue];
    }else if ([Param GetType] == [JsArgumentType TYPE__FUNCTION]){
/* int type1 = [Param GetType];
        int type2 = [JsArgumentType TYPE__FUNCTION];
        if(type1 != type2){
            NSLog(@"parameter error, expect <function>");
            return nil;
        }*/
        HBCallback *Callback = [HBCallback HBCallbackImpl:[Param GetName] method:method];
        return Callback;
    }else if ([Param GetType] == [JsArgumentType TYPE__OBJECT]){
        @try {
            NSMutableDictionary *dic = [Param GetValue];
            return [self parseObjectLoop:dic method:method];
        } @catch (NSException *exception) {
            NSLog(@"解析出错!");
        } @finally {
            
        }
        
    }else if ([Param GetType] == [JsArgumentType TYPE__ARRAY]){
        @try {
            NSMutableArray *arr = [Param GetValue];
            return [self parseObjectLoop:arr method:method];
        } @catch (NSException *exception) {
            NSLog(@"解析出错!");
        } @finally {
            
        }
        
    }else if ([Param GetType] == [JsArgumentType TYPE__BOOL]){
        NSNumber *value = [Param GetValue];
        return [Param GetValue];
    }
    return nil;
    
}
+ (NSString*)toJsObject:(NSObject *)javaObject{
    if (javaObject == nil || [javaObject isKindOfClass:[NSNumber class]]) {
        return [@"" stringByAppendingString:[NSString stringWithFormat:@"%@", javaObject]];
    }else if ([javaObject isKindOfClass:[NSString class]]){
        NSString *format = [NSString stringWithFormat:@"%@", javaObject];
        format = [[format stringByReplacingOccurrencesOfString:@"'" withString:@"\\\\\'"]stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        return [[@"'" stringByAppendingString:format] stringByAppendingString:@"'"];
    }else if ([javaObject conformsToProtocol:@protocol(JsObject)]){
        SEL selectorNormal = NSSelectorFromString(@"convertToJs");
        return [javaObject performSelector:selectorNormal];
    }else if([javaObject isKindOfClass:[NSArray class]] ||[javaObject isKindOfClass:[NSDictionary class]]){
        NSString *Js = [self parserToJs:javaObject pretty:false];
        return Js;
    }else{
        NSString *jsString = [javaObject description];
        jsString = [[jsString stringByReplacingOccurrencesOfString:@"'" withString:@"\\\\\'"]stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        return [[@"'" stringByAppendingString:jsString] stringByAppendingString:@"'"];
    }
}

+ (NSString*)parserToJs:(id)message pretty:(BOOL)pretty{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:(NSJSONWritingOptions)(pretty ? NSJSONWritingPrettyPrinted : 0) error:nil] encoding:NSUTF8StringEncoding];
}

/*


+ (int)transformType:(Class)cls{
    id className = [[cls alloc] init];
    if ([className isKindOfClass:[NSNumber class]]) {
//        if (<#condition#>) {
//            <#statements#>
//        }
    }
}
 */
@end
