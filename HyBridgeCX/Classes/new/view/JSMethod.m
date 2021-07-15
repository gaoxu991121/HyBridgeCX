//
//  JSMethod.m
//  @HIT
//
//  Created by CX02 on 2017/11/1.
//  Copyright © 2017年 FuWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsStaticModule.h"
#import "JSMethod.h"
#import "JsModule.h"
#import <objc/runtime.h>
#import <objc/message.h>
@implementation JsMethod {
    JsModule *mModule;
    Method *mJavaMethod;
    NSString *mMethodName;
    NSString *mProtocol;
    NSMutableArray *mParameterType;
    bool mHasReturn;
    bool mIsStatic;
    int mLevel;
    
}
- (void)Jsmethod{
    mParameterType = [[NSMutableArray alloc] init];
}
- (Method*)getMethod{
    return mJavaMethod;
}
- (void)setJavaMethod:(Method *)javaMethod{
    mJavaMethod =javaMethod;
    if (javaMethod != nil) {
        NSString *methodName = [NSStringFromSelector(method_getName(*javaMethod)) stringByReplacingOccurrencesOfString:@":" withString:@""];
        mMethodName = methodName;
    }
}
- (JsModule*)getModule{
    return mModule;
}
- (void)setModule:(JsModule *)module{
    mModule = module;
    if ([mModule isKindOfClass:[JsStaticModule class]]) {
        mIsStatic = true;
    }else{
        mIsStatic = false;
    }
}
- (NSString*)getMethodName{
    return mMethodName;
}
- (void)setMethodName:(NSString *)methodName{
    mMethodName = methodName;
}
- (BOOL)isHasReturn{
    return mHasReturn;
}
- (void)setHasReturn:(BOOL)hasReturn{
    mHasReturn = hasReturn;
}
- (NSMutableArray*)getParameterType{
    return mParameterType;
}
- (void)setParameterType:(NSMutableArray *)parameterType{
    mParameterType = parameterType;
}
- (BOOL)isIsStatic{
    return mIsStatic;
}
- (NSString*)getprotocol{
    return mProtocol;
}
- (void)setProtocol:(NSString *)protocol{
    mProtocol = protocol;
}
- (NSString*)getCallBack{
    if (mIsStatic) {
        return [NSString stringWithFormat:@"%@.%@sCallback", self.getprotocol,self.getMethodName];
    }else{
        return [NSString stringWithFormat:@"%@.%@.%@sCallback", self.getprotocol,self.getModule.modelName,self.getMethodName];
    }
}
- (NSString*)getInjectJs{
    NSString *builder = [[NSString alloc]init];
    if (mIsStatic) {
        builder = [[[builder stringByAppendingString:@"        this." ] stringByAppendingString:[NSString stringWithFormat:@"%@", self.getMethodName ]]
            stringByAppendingString:@" = function() {\n"];
    }else{
        builder = [[[builder stringByAppendingString:@"        " ]
            stringByAppendingString:[NSString stringWithFormat:@"%@", self.getMethodName]]
            stringByAppendingString:@": function() {\n"];
    }
    builder = [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[builder stringByAppendingString:@"            try {\n" ]
            stringByAppendingString:@"                var id = _getId(),\n" ]
            stringByAppendingString:@"                    args = [];\n" ]
            stringByAppendingString:@"                if (!" ]
            stringByAppendingString:[NSString stringWithFormat:@"%@", self.getCallBack] ]
            stringByAppendingString:@")\n" ]
            stringByAppendingString:@"                    " ]
            stringByAppendingString:[NSString stringWithFormat:@"%@", self.getCallBack] ]
            stringByAppendingString:@" = {};\n" ]
            stringByAppendingString:@"                for (var i in arguments) {\n" ]
            stringByAppendingString:@"                    var name = id + '_p_' + i,\n" ]
            stringByAppendingString:@"                        item = arguments[i],\n" ]
            stringByAppendingString:@"                        l = {};\n" ]
            stringByAppendingString:@"                    _parseFunction(item, name, l);\n" ]
            stringByAppendingString:@"                    for (var k in l) {\n" ]
            stringByAppendingString:@"                       " ]
            stringByAppendingString:[NSString stringWithFormat:@"%@", self.getCallBack] ]
            stringByAppendingString:@"[k] = l[k];\n" ]
            stringByAppendingString:@"                    };\n" ]
            stringByAppendingString:@"                    args.push({\n" ]
            stringByAppendingString:@"                        type: _getType(item),\n" ]
            stringByAppendingString:@"                        name: name,\n" ]
            stringByAppendingString:@"                        value: item\n" ]
            stringByAppendingString:@"                    })\n" ]
            stringByAppendingString:@"                };\n" ]
            stringByAppendingString:@"                var r = _callJava(id, '" ]
            stringByAppendingString:[NSString stringWithFormat:@"%@", self.getModule.modelName] ]
            stringByAppendingString:@"', '" ]
            stringByAppendingString:[NSString stringWithFormat:@"%@", self.getMethodName] ]
            stringByAppendingString:@"', args);\n" ]
            stringByAppendingString:@"                if (r && r.success) {\n"];
    if (mHasReturn) {
        builder = [builder stringByAppendingString:@"                    return r.msg;\n"];
    }
    builder = [[[[[[[builder stringByAppendingString:@"                } else {\n" ]
            stringByAppendingString:@"                    _err(r.msg);\n" ]
            stringByAppendingString:@"                }\n" ]
            stringByAppendingString:@"            } catch (e) {\n" ]
            stringByAppendingString:@"                _err(e);\n" ]
            stringByAppendingString:@"            };\n" ]
            stringByAppendingString:@"        }"];
    if (!mIsStatic) {
        builder = [builder stringByAppendingString:@",\n"];
    }else{
        builder = [builder stringByAppendingString:@";\n"];
    }
    return builder;
}
- (NSObject*)invoke:(NSMutableArray *)args{
    if (mJavaMethod != nil) {
        NSString* moduleName = self.getModule.modelName;
        
        id myObj = [[NSClassFromString(moduleName) alloc] init];
        NSString* RealMethodName = [[NSString stringWithFormat:@"%@", self.getMethodName] stringByAppendingString:@":"];
        SEL selectorNormal = NSSelectorFromString(RealMethodName);
        return [mModule performSelector:selectorNormal withObject:args];
    }
    return nil;
}
+ (JsMethod*)create:(JsModule *)jsModule javaMethod:(Method *)javaMethod methodName:(NSString *)methodName parameterTypeList:(NSMutableArray *)parameterTypeList hasReturn:(BOOL)hasReturn protocol:(NSString *)protocol level:(int)level{
    JsMethod* method = [[JsMethod alloc]init];
    [method setModule:jsModule];
    [method setJavaMethod:javaMethod];
    [method setParameterType:parameterTypeList];
    [method setMethodName:methodName];
    [method setHasReturn:hasReturn];
    [method setProtocol:protocol];
    return method;
}
@end
