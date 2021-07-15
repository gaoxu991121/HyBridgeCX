//
//  HBBaseWebView.h
//  Pods
//
//  Created by CX02 on 2017/12/2.
//

#ifndef HBBaseWebView_h
#define HBBaseWebView_h


#endif /* HBBaseWebView_h */
#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "PermissionLevel.h"
@interface HBBaseWebView : WKWebView<PermissionLevel>
- (int)containerLevel;
+ (int)base;
+ (int)none;
+ (int)core;
+ (int)system;
@end
