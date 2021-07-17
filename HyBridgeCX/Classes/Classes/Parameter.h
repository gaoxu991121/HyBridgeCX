//
//  Parameter.h
//  Pods
//
//  Created by CX02 on 2017/11/21.
//
//
#import "HBArray.h"
#ifndef Parameter_h
#define Parameter_h


#endif /* Parameter_h */
@interface Parameter : NSObject
@property (strong,nonatomic) NSNumber* type;
@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSObject* value;
- (int)GetType;
- (void)SetType:(NSNumber*)type;
- (NSString*)GetName;
- (void)SetName:(NSString*)name;
- (NSObject*)GetValue;
- (void)SetValue:(NSString*)value;
- (void)array:(NSObject*)array;
@end
