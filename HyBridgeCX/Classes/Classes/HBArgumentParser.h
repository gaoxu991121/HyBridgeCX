//
//  HBArgumentParser.h
//  Pods
//
//  Created by CX02 on 2017/11/20.
//
//
#import "Parameter.h"
#import "HBMap.h"
#import "HBArray.h"
#ifndef HBArgumentParser_h
#define HBArgumentParser_h

typedef bool myBool;
#endif /* HBArgumentParser_h */

@interface HBArgumentPaser : NSObject
@property (nonatomic) long Id;
@property (strong,nonatomic) NSString* module;
@property (strong,nonatomic) NSString* method;
@property (strong,nonatomic) NSMutableArray* Parameters;

- (long)GetId;
- (void)SetId:(long)ID;
- (NSString*)GetModule;
- (void)SetModule:(NSString *)module;
- (NSString*)GetMethod;
- (void)SetMethod:(NSString *)method;
- (NSMutableArray*)GetParameters;
- (void)SetParameters:(NSMutableArray *)parameters;
+ (instancetype)parse:(NSString*)jsonString;
- (HBArray*)test;
- (HBMap*)tet;
@end
