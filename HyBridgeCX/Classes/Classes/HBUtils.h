//
//  HBUtils.h
//  Pods
//
//  Created by CX02 on 2017/11/24.
//
//
#import "HBBaseWebView.h"
#import "Parameter.h"
#import "JsModule.h"
#import "JSMethod.h"
#import <objc/runtime.h>
#import <objc/message.h>
#ifndef HBUtils_h
#define HBUtils_h


#endif /* HBUtils_h */
@interface HBUtils : NSObject{
    
}
+ (NSObject*)parseToObject:(int)type Param:(Parameter*)Param method:(JsMethod*)method;
+ (NSString*)toJsObject:(NSObject*)javaObject;
//+ (int)transformType:(Class)cls;
+ (NSMutableDictionary*)getAllMethod:(WKWebView*)webview module:(JsModule*)module injectedCls:(Class)injectedCls protocol:(NSString*)protocol;
+ (NSMutableArray*)moduleSplit:(NSString*)moduleName;
+ (NSString*)parserToJs:(id)message pretty:(BOOL)pretty;
@end
