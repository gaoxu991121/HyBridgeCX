//
//  JsArgumentType.m
//  Pods
//
//  Created by CX02 on 2017/11/25.
//
//

#import <Foundation/Foundation.h>
#import "JsArgumentType.h"
@implementation JsArgumentType{
    
}
+ (int)TYPE__UNDEFINE{
    return 0;
}
+ (int)TYPE__BOOL{
    return 1;
}
+ (int)TYPE__STRING{
    return 2;
}
+ (int)TYPE__FUNCTION{
    return 3;
}
+ (int)TYPE__OBJECT{
    return 4;
}
+ (int)TYPE__ARRAY{
    return 5;
}
+ (int)TYPE__INT{
    return 6;
}
+ (int)TYPE__DOUBLE{
    return 7;
}
@end
