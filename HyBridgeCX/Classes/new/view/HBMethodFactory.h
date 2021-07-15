//
//  HBMethodFactory.h
//  Pods
//
//  Created by CX02 on 2017/11/26.
//
//
#import "JsRunMethod.h"
#ifndef HBMethodFactory_h
#define HBMethodFactory_h


#endif /* HBMethodFactory_h */
@interface HBMethodFactory:NSObject{
    
}
+ (NSString*)getUtilMethods:(NSString*)loadReadyMethod;
@end
@interface OnHyBridgeReady : JsRunMethod{
}
+ (instancetype)OnHyBridgeReady:(NSString*)loadReadyMethod;
- (NSString*)executeJs;
- (NSString*)methodName;
- (BOOL)isPrivate;
@end
@interface GetType : JsRunMethod
- (NSString*)executeJs;
- (NSString*)methodName;
@end
@interface ParseFunction : JsRunMethod
- (NSString*)executeJs;
- (NSString*)methodName;
@end
@interface CreateId : JsRunMethod
- (NSString*)executeJs;
- (NSString*)methodName;
@end
@interface CallJava : JsRunMethod
- (NSString*)executeJs;
- (NSString*)methodName;
@end
@interface ErrorPrinter : JsRunMethod
- (NSString*)executeJs;
- (NSString*)methodName;
@end
@interface LogPrinter : JsRunMethod
- (NSString*)executeJs;
- (NSString*)methodName;
@end
