//
//  HBBaseWebView.m
//  Alamofire
//
//  Created by CX02 on 2017/12/2.
//

#import <Foundation/Foundation.h>
#import "HBBaseWebView.h"
static int NONE = -1;
static int BASE = 0;
static int CORE = 5;
static int SYSTEM = 10;
@implementation HBBaseWebView
- (int)containerLevel{
    NSLog(@"test this method");
    return 0;
}

+ (int)core{
    return 5;
}
+ (int)system{
    return 10;
}
+ (int)base{
    return 0;
}
+ (int)none{
    return -1;
}
@end

