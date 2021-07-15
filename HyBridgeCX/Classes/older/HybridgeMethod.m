//
//  Hybridge.m
//  @HIT
//
//  Created by CX02 on 2017/11/1.
//  Copyright © 2017年 FuWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HybridgeMethod.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "MyModel.h"
#import "JSMethod.h"
#import "CommonMethod.h"
#import <JavaScriptCore/JavaScriptCore.h>
typedef char MyChar;
@implementation HyBridgeMethod {
}
+(instancetype)test{
    HyBridgeMethod *bridge = [[HyBridgeMethod alloc] init];
    bridge.ModelName = [[NSMutableArray alloc] init];
    bridge.mIsStatic = false;
    bridge.MyProtocol = @"HB";
    [bridge MyInit];
    
    [bridge InjectCommonMethod];
    [bridge GetMethod];
    [bridge InjectModel];
    [bridge LastPart];
    NSLog(@"call this model named<Hybridge>xiao😊");
    return bridge;
}
-(void)MyInit{
    
    
    
    NSInteger *test = 5;
    int tes = test;
    NSLog(@"dxiao😊⬇️🦐");
    NSLog(@"%d", tes);
    
    
    
    int value = arc4random() % 1000;
    NSInteger Random = value;
    _mClassName = (@"%@",[NSString stringWithFormat:@"HB_%ld",(long)Random]);
    NSLog(@"%@", _mClassName);
}
-(void)InjectCommonMethod{
    _JsCommand = @"var ";
    _JsCommand = [_JsCommand stringByAppendingString:_mClassName];
    _JsCommand =[_JsCommand stringByAppendingString:@" = function() {\n"];
}
//
//进行method的处理
-(void)GetMethod{
//  java:先分散最后在getmethod拼凑在一起 这边直接拼凑在一起  todo----判断是否为private--
    CommonMethod* method = [CommonMethod getCommonMethod:_MyProtocol];
    NSString*testString = [method GetMethod];
    _JsCommand = [_JsCommand stringByAppendingString:testString];
}
-(void)InjectModel{
    _mMethod = [[NSMutableDictionary alloc] init];
//与安卓端要一致所以不能这样通过模块名来动态增加model
    unsigned int count;
    unsigned int outCount;
    NSMutableArray *classes = [[NSMutableArray alloc]init];
    const char ** classesTes = objc_copyClassNamesForImage(class_getImageName(NSClassFromString(@"Native")), &outCount);
    for (int i = 0; i < outCount; i++) {
        char *myClassName = classesTes[i];
        NSString *MyClassName = [@"" stringByAppendingFormat:@"%s", classesTes[i]];
        id myObjc = [[NSClassFromString(MyClassName) alloc] init];
        Class mMyModel = [myObjc class];
        BOOL mcanCall = [mMyModel instancesRespondToSelector:NSSelectorFromString(@"modelName")];
        if (mcanCall) {
            [classes addObject:MyClassName];
        }
    }
    for (int i = 0; i < classes.count; i++) {
        NSMutableArray *mMethodName = [[NSMutableArray alloc] init];
        NSString *className = classes[i];
        NSString *objc = @"_HIT";
        if ([className rangeOfString:objc].location == NSNotFound) {
            NSLog(className);
            [_ModelName addObject:className];
            id myObj = [[NSClassFromString(className) alloc] init];
            Class test = [myObj class];
            BOOL canCall = [test instancesRespondToSelector:NSSelectorFromString(@"getModelName:")];
            if (canCall) {
                NSString *ISStatic = [myObj performSelector:NSSelectorFromString(@"getModelName:") withObject:@"test"];
                NSLog(@"this is%@", ISStatic);
                if ([ISStatic  isEqual: @"STATIC"]) {
                    NSLog(@"text😊😢xi⬇️");
                    self.mIsStatic = true;
                }else{
                    self.mIsStatic = false;
                }
            }
            Method *methodList = class_copyMethodList(test, &count);
            for (NSInteger mCount = 0; mCount < count; mCount++) {
                char dst;
                JsMethod *jsMethd = [[JsMethod alloc] init];
                Method methodJson = methodList[mCount];
                NSString *MethodName = NSStringFromSelector(method_getName(methodJson));
                MethodName = [MethodName stringByReplacingOccurrencesOfString:@":" withString:@""];
                method_getReturnType(methodJson, &dst, sizeof(char));
                struct objc_method_description *description = method_getDescription(methodJson);
                NSLog(@"%s %@",__func__,NSStringFromSelector(description->name));
                NSString *hasRe = [NSString stringWithFormat:@"%c", dst];
                if ([hasRe isEqualToString:@"v"]) {
                   // jsMethd = [JsMethod MethodInit:className Jsmethod:MethodName Protocol:_MyProtocol HasReturn:false IsStatic:_mIsStatic];
                }else{
                    //jsMethd = [JsMethod MethodInit:className Jsmethod:MethodName Protocol:_MyProtocol HasReturn:true IsStatic:_mIsStatic];
                }
//                必须应用自己创建的jsmethod类否则后面很难进行下去

                if ([MethodName  isEqual: @"getModelName"]) {
//                    getModelName不用inject进去
                    MethodName = NULL;
                }
                NSLog(@"methodName ->%@",MethodName);
                if (MethodName != NULL) {
                    [mMethodName addObject:jsMethd];
                }
            }
            if (mMethodName != NULL) {
                [_mMethod setObject:mMethodName forKey:className];
            }
        }
    }
    [self InjectModelAndMethod:_mIsStatic];
}

//todo
//判断是否是静态方法--
-(void)InjectModelAndMethod:(bool)Isstatic{
    unsigned int Count;
    unsigned int MethodCount;
//
//新增加判断静态模块
//
    for (Count = 0; Count < _ModelName.count; Count++) {
        JsMethod *mMethod = _mMethod[_ModelName[Count]][0];
        if (mMethod) {
//            静态方法
        }else{
            _JsCommand = [[[[[_JsCommand stringByAppendingString:@"    " ] stringByAppendingString: _mClassName ] stringByAppendingString:
                            @".prototype." ] stringByAppendingString:
                           _ModelName[Count]] stringByAppendingString:
                          @" = {\n"];
            
        }
//        injectMethod
        NSArray *MethodList = _mMethod[_ModelName[Count]];
        for (MethodCount = 0; MethodCount < MethodList.count; MethodCount++) {
//            停用了MethodList[MethodCount]该用jsmethod类
            JsMethod *Tmethod = MethodList[MethodCount];
            NSString *methodName = @"";//Tmethod.mJsmethod;
            if (mMethod) {
                _JsCommand = [[[_JsCommand stringByAppendingString:@"        this." ] stringByAppendingString:
                    methodName ] stringByAppendingString:
                    @" = function() {\n"];
            }else{
                _JsCommand = [[[_JsCommand stringByAppendingString:@"        " ] stringByAppendingString:
                    methodName ] stringByAppendingString:
                    @": function() {\n"];
            }
//
//          CallBack
//
            NSString *CallBack = @"";
            if (mMethod) {
                CallBack = [NSString stringWithFormat:@"%@.%@Callback",_MyProtocol,methodName];
            }else{
                CallBack = [NSString stringWithFormat:@"%@.%@.%@Callback",_MyProtocol,_ModelName[Count],methodName];
            }
//
//
            _JsCommand = [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[_JsCommand stringByAppendingString:@"            try {\n" ] stringByAppendingString:
                @"                var id = _getId(),\n" ] stringByAppendingString:
                @"                    args = [];\n" ] stringByAppendingString:
                @"                if (!" ] stringByAppendingString:
                CallBack ] stringByAppendingString:
                @")\n" ] stringByAppendingString:
                @"                    " ] stringByAppendingString:
                CallBack ] stringByAppendingString:
                @" = {};\n" ] stringByAppendingString:
                @"                for (var i in arguments) {\n" ] stringByAppendingString:
                @"                    var name = id + '_p_' + i,\n" ] stringByAppendingString:
                @"                        item = arguments[i],\n" ] stringByAppendingString:
                @"                        l = {};\n" ] stringByAppendingString:
                @"                    _parseFunction(item, name, l);\n" ] stringByAppendingString:
                @"                    for (var k in l) {\n" ] stringByAppendingString:
                @"                       " ] stringByAppendingString:
                CallBack ] stringByAppendingString:
                @"[k] = l[k];\n" ] stringByAppendingString:
                @"                    };\n" ] stringByAppendingString:
                @"                    args.push({\n" ] stringByAppendingString:
                @"                        type: _getType(item),\n" ] stringByAppendingString:
                @"                        name: name,\n" ] stringByAppendingString:
                @"                        value: item\n" ] stringByAppendingString:
                @"                    })\n" ]stringByAppendingString:
                @"                };\n" ] stringByAppendingString:
                @"                var r = _callJava(id, '" ] stringByAppendingString:
                _ModelName[Count] ] stringByAppendingString:
                @"', '" ] stringByAppendingString:
                methodName ] stringByAppendingString:
                @"', args);\n" ] stringByAppendingString:
                @"                if (r && r.success) {\n"];
            //
            //  默认没有返回值
            if (mMethod) {
                _JsCommand = [_JsCommand stringByAppendingString:@"                    return r.msg;"];
            }
            //
            _JsCommand = [[[[[[[_JsCommand stringByAppendingString:@"                } else {\n" ] stringByAppendingString:
                    @"                    _err(r.msg);\n" ] stringByAppendingString:
                    @"                }\n" ] stringByAppendingString:
                    @"            } catch (e) {\n" ] stringByAppendingString:
                    @"                _err(e);\n" ] stringByAppendingString:
                    @"            };\n" ] stringByAppendingString:
                    @"        }"];
            if (!mMethod) {
                _JsCommand = [_JsCommand stringByAppendingString:@",\n"];
            }else{
                _JsCommand = [_JsCommand stringByAppendingString:@";\n"];
            }
            
        }
        //        动态模块加上";"
        if (mMethod) {
        }else{
            _JsCommand =[_JsCommand stringByAppendingString:@"    };\n"];
        }
    }
}
-(void)LastPart{
    
    _JsCommand = [_JsCommand stringByAppendingString:@"};\n"];
    _JsCommand = [[[[[_JsCommand stringByAppendingString:@"window." ] stringByAppendingString:                                             _MyProtocol ] stringByAppendingString:
                @" = new " ] stringByAppendingString:
                _mClassName ] stringByAppendingString:
                @"();\n"];
    _JsCommand = [[[[_JsCommand stringByAppendingString:_MyProtocol ] stringByAppendingString: @".On"]stringByAppendingString:_MyProtocol]stringByAppendingString:@"Ready();"];
    NSLog(_JsCommand);
}
@end

