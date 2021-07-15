//
//  HBCallback.h
//  Pods
//
//  Created by CX02 on 2017/11/24.
//
//
#import "JSMethod.h"
#ifndef HBCallback_h
#define HBCallback_h


#endif /* HBCallback_h */
@interface HBCallback : NSObject{
    
}
+ (instancetype)HBCallbackImpl:(NSString*)name method:(JsMethod*)method;
- (void)apply:(NSMutableArray*)args;
@end
