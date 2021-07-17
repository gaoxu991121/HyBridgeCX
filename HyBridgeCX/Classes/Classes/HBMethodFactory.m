//
//  HBMethodFactory.m
//  Pods
//
//  Created by CX02 on 2017/11/26.
//
//

#import <Foundation/Foundation.h>
#import "HyBridgeConfig.h"
#import "HBMethodFactory.h"
static NSString* mInjectFunc;
@implementation HBMethodFactory{
    
}
+ (NSString*)getUtilMethods:(NSString *)loadReadyMethod{
    if (mInjectFunc == nil ) {
        mInjectFunc = @"";
//        CommonMethod* commen =  [CommonMethod getCommonMethod:loadReadyMethod];
//        mInjectFunc = [commen GetMethod];
        NSMutableArray *methods = [[NSMutableArray alloc] init];
        [methods addObject:[OnHyBridgeReady OnHyBridgeReady:loadReadyMethod]];
        [methods addObject:[[GetType alloc]init]];
        [methods addObject:[[ParseFunction alloc] init]];
        [methods addObject:[[ErrorPrinter alloc] init]];
        [methods addObject:[[LogPrinter alloc] init]];
        [methods addObject:[[CreateId alloc] init]];
        [methods addObject:[[CallJava alloc] init]];
        for (JsRunMethod *method in methods) {
            mInjectFunc = [mInjectFunc stringByAppendingString:[method getMethod]];
        }
    }
    return mInjectFunc;
}

@end
@implementation OnHyBridgeReady{
    NSString *mLoadReadyMethod;
}
+ (instancetype)OnHyBridgeReady:(NSString *)loadReadyMethod{
    OnHyBridgeReady *bridgeReady = [[OnHyBridgeReady alloc] init];
    [bridgeReady setHybridgeReady:loadReadyMethod];
    return bridgeReady;
}
- (void)setHybridgeReady:(NSString*)loadReadyMethod{
    mLoadReadyMethod = loadReadyMethod;
}
-(NSString*)executeJs{
    NSString *builder = @"";
    builder = [[[[[[[[[[[[[[[[[[builder stringByAppendingString:@"() {\n" ] stringByAppendingString:@"        try {\n" ]
        stringByAppendingString:@"            var ready = window."]
        stringByAppendingString:mLoadReadyMethod]
        stringByAppendingString:@";\n" ]
        stringByAppendingString:@"            if (ready && typeof(ready) === 'function') {\n" ]
        stringByAppendingString:@"                ready();\n" ]
        stringByAppendingString:@"            } else {\n" ]
        stringByAppendingString:@"                var readyEvent = document.createEvent('Events');\n" ]
        stringByAppendingString:@"                readyEvent.initEvent('"]
        stringByAppendingString:mLoadReadyMethod]
        stringByAppendingString:@"');\n" ]
        stringByAppendingString:@"                document.dispatchEvent(readyEvent);\n" ]
        stringByAppendingString:@"            }\n" ]
        stringByAppendingString:@"        } catch (e) {\n" ]
        stringByAppendingString:@"            console.error(e);\n" ]
        stringByAppendingString:@"        };\n" ]
        stringByAppendingString:@"    }"];
    return builder;
}
- (NSString*)methodName{
    return [NSString stringWithFormat:@"on%@Ready", [[HyBridgeConfig getSetting] getProtocol]];
}
- (BOOL)isPrivate{
    return false;
}
@end
@implementation GetType
- (NSString*)executeJs{
    NSString *builder = @"";
    builder = [[[[[[[[[[[[[[[[[[[[[builder stringByAppendingString:@"(args) {\n" ] stringByAppendingString:@"        var type = 0;\n" ]
        stringByAppendingString:@"        if (typeof args === 'string') {\n" ]
        stringByAppendingString:@"            type = 2;\n" ]
        stringByAppendingString:@"        } else if (typeof args === 'number') {\n" ]
        stringByAppendingString:@"            if (Math.floor(args) === args) {\n" ]
        stringByAppendingString:@"                type = 6;\n" ]
        stringByAppendingString:@"            } else {\n" ]
        stringByAppendingString:@"                type = 7;\n" ]
        stringByAppendingString:@"            }\n" ]
        stringByAppendingString:@"        } else if (typeof args === 'boolean') {\n" ]
        stringByAppendingString:@"            type = 1;\n" ]
        stringByAppendingString:@"        } else if (typeof args === 'function') {\n" ]
        stringByAppendingString:@"            type = 3;\n" ]
        stringByAppendingString:@"        } else if (args instanceof Array) {\n" ]
        stringByAppendingString:@"            type = 5;\n" ]
        stringByAppendingString:@"        } else if (typeof args === 'object') {\n" ]
        stringByAppendingString:@"            type = 4;\n" ]
        stringByAppendingString:@"        }\n" ]
        stringByAppendingString:@"        return type;\n" ]
        stringByAppendingString:@"    }"];
    return builder;
}
- (NSString*)methodName{
    return @"_getType";
}
@end
@implementation ParseFunction

- (NSString*)executeJs{
    NSString *builder = @"";
    builder = [[[[[[[[[[[[[[[[[[[[[[[[[builder stringByAppendingString:@"(obj, name, callback) {\n" ]
        stringByAppendingString:@"        if (typeof obj === 'function') {\n" ]
        stringByAppendingString:@"            callback[name] = obj;\n" ]
        stringByAppendingString:@"            obj = '[Function]::' + name;\n" ]
        stringByAppendingString:@"            return;\n" ]
        stringByAppendingString:@"        }\n" ]
        stringByAppendingString:@"        if (typeof obj !== 'object') {\n" ]
        stringByAppendingString:@"            return;\n" ]
        stringByAppendingString:@"        }\n" ]
        stringByAppendingString:@"        for (var p in obj) {\n" ]
        stringByAppendingString:@"            switch (typeof obj[p]) {\n" ]
        stringByAppendingString:@"                case 'object':\n" ]
        stringByAppendingString:@"                    var ret = name ? name + '_' + p : p;\n" ]
        stringByAppendingString:@"                    _parseFunction(obj[p], ret, callback);\n" ]
        stringByAppendingString:@"                    break;\n" ]
        stringByAppendingString:@"                case 'function':\n" ]
        stringByAppendingString:@"                    var ret = name ? name + '_' + p : p;\n" ]
        stringByAppendingString:@"                    callback[ret] = (obj[p]);\n" ]
        stringByAppendingString:@"                    obj[p] = '[Function]::' + ret;\n" ]
        stringByAppendingString:@"                    break;\n" ]
        stringByAppendingString:@"                default:\n" ]
        stringByAppendingString:@"                    break;\n" ]
        stringByAppendingString:@"            }\n" ]
        stringByAppendingString:@"        }\n" ]
        stringByAppendingString:@"    }" ];
    return builder;
}
- (NSString*)methodName{
    return @"_parseFunction";
}
@end
@implementation CreateId

- (NSString*)executeJs{
    NSString *builder = @"";
    builder = [[[builder stringByAppendingString:@"() {\n" ]
        stringByAppendingString:@"        return Math.floor(Math.random() * (1 << 12));\n" ]
        stringByAppendingString:@"    }"];
    return builder;
}
- (NSString*)methodName{
    return @"_getId";
}
@end
@implementation CallJava
- (NSString*)executeJs{
    NSString *builder = @"";
    builder = [[[[[[[[[[[[[[[[[builder stringByAppendingString:@"(id, module, method, args) {\n" ]
        stringByAppendingString:@"        if(typeof args === 'object' && args.length > 0) {\n" ]
        stringByAppendingString:@"           if(args[0].value.success == undefined)\n" ]
        stringByAppendingString:@"               args[0].value.success = '[Function]::' + args[0].name + '_success';\n" ]
        stringByAppendingString:@"           if(args[0].value.fail == undefined)\n" ]
        stringByAppendingString:@"               args[0].value.fail = '[Function]::' + args[0].name + '_fail';\n" ]
        stringByAppendingString:@"           if(args[0].value.complete == undefined)\n" ]
        stringByAppendingString:@"               args[0].value.complete = '[Function]::' + args[0].name + '_complete';\n" ]
        stringByAppendingString:@"        }\n" ]
        stringByAppendingString:@"        var req = {\n" ]
        stringByAppendingString:@"            id: id,\n" ]
        stringByAppendingString:@"            module: module,\n" ]
        stringByAppendingString:@"            method: method,\n" ]
        stringByAppendingString:@"            parameters: args\n" ]
        stringByAppendingString:@"        };\n" ]
        stringByAppendingString:@"        return JSON.parse(prompt(JSON.stringify(req)));\n" ]
        stringByAppendingString:@"    }"];
    return builder;
}
- (NSString*)methodName{
    return @"_callJava";
}
@end
@implementation ErrorPrinter

- (NSString*)executeJs{
    NSString *builder = @"";
    builder = [[[builder stringByAppendingString:@"(s) {\n" ]
        stringByAppendingString:@"        console.error(s);\n" ]
        stringByAppendingString:@"    }"];
    return builder;
}
- (NSString*)methodName{
    return @"_err";
}
@end
@implementation LogPrinter

- (NSString*)executeJs{
    NSString *builder = @"";
    builder = [[[builder stringByAppendingString:@"(s) {\n" ]
                stringByAppendingString:@"        console.log(s);\n" ]
               stringByAppendingString:@"    }"];
    return builder;
}
- (NSString*)methodName{
    return @"_log";
}
@end

