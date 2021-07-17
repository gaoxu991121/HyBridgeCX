//
//  HBBaseWebView.h
//  Pods
//
//  Created by CX02 on 2017/12/2.
//
@protocol myDelegate<NSObject>
@required
- (void)showImgWithImageURL:(NSMutableArray *)imageArr;
@end
#ifndef HBBaseWebView_h
#define HBBaseWebView_h


#endif /* HBBaseWebView_h */
#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "PermissionLevel.h"
static char iamgeUrlArrayKey;
@interface HBBaseWebView : WKWebView<PermissionLevel>
@property (weak, nonatomic) id <myDelegate> mdelegate;
- (int)containerLevel;
+ (int)base;
+ (int)none;
+ (int)core;
+ (int)system;
- (void)setMethod:(NSArray *)imgUrlArray;
- (NSArray *)getImgUrlArray;
- (NSArray *)getImageUrlByJS:(HBBaseWebView *)wkWebView;
- (BOOL)showBigImage:(NSURLRequest *)request;
@end

