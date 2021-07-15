//
//  MyModel.h
//  @HIT
//
//  Created by CX02 on 2017/11/1.
//  Copyright © 2017年 FuWen. All rights reserved.
//
#import "Callback.h"
#ifndef myModel_h
#define myModel_h

#endif /* myModel_h */
@interface myModel : NSObject
@property (strong, nonatomic) Callback* CallBack;
@property (strong,nonatomic) WKWebView* mWebview;
- (WKWebView*)getwebview;
- (NSObject*) getWebViewObject;
- (NSString*) getModule;
- (id)pSelector:(SEL)selector withObjects:(NSArray *)objects;
- (UIViewController*)getCurrentViewController;
@end
