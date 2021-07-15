//
//  CommonMethod.m
//  @HIT
//
//  Created by CX02 on 2017/11/1.
//  Copyright © 2017年 FuWen. All rights reserved.
#import <Foundation/Foundation.h>
#import "CommonMethod.h"
@implementation CommonMethod {
}
+(instancetype)getCommonMethod:(NSString*)protocal{
    CommonMethod* common = [[CommonMethod alloc]init];
    common.mProtocal = protocal;
    return common;
}
-(NSString*)GetMethod{
    //
    //  java:先分散最后在getmethod拼凑在一起 这边直接拼凑在一起  todo----判断是否为private--
//first: GetType
    NSString* CommenMethodIMP = @"";
    CommenMethodIMP = [CommenMethodIMP stringByAppendingString:@"    function _getType"];
    CommenMethodIMP = [[[[[[[[[[[[[[[[[[[[[CommenMethodIMP stringByAppendingString:@"(args) {\n" ] stringByAppendingString:
            @"        var type = 0;\n" ] stringByAppendingString:
            @"        if (typeof args === 'string') {\n" ] stringByAppendingString:
            @"            type = 2;\n" ] stringByAppendingString:
            @"        } else if (typeof args === 'number') {\n" ] stringByAppendingString:
            @"            if (Math.floor(args) === args) {\n" ] stringByAppendingString:
            @"                type = 6;\n" ] stringByAppendingString:
            @"            } else {\n" ] stringByAppendingString:
            @"                type = 7;\n" ] stringByAppendingString:
            @"            }\n" ] stringByAppendingString:
            @"        } else if (typeof args === 'boolean') {\n" ] stringByAppendingString:
            @"            type = 1;\n" ] stringByAppendingString:
            @"        } else if (typeof args === 'function') {\n" ] stringByAppendingString:
            @"            type = 3;\n" ] stringByAppendingString:
            @"        } else if (args instanceof Array) {\n" ] stringByAppendingString:
            @"            type = 5;\n" ] stringByAppendingString:
            @"        } else if (typeof args === 'object') {\n" ] stringByAppendingString:
            @"            type = 4;\n" ] stringByAppendingString:
            @"        }\n" ] stringByAppendingString:
            @"        return type;\n" ] stringByAppendingString:
            @"    };\n"];
//    second : _parseFunction
    CommenMethodIMP = [CommenMethodIMP stringByAppendingString:@"    function _parseFunction"];
    CommenMethodIMP = [[[[[[[[[[[[[[[[[[[[[[[[[CommenMethodIMP stringByAppendingString:@"(obj, name, callback) {\n" ] stringByAppendingString:
            @"        if (typeof obj === 'function') {\n" ] stringByAppendingString:
            @"            callback[name] = obj;\n" ] stringByAppendingString:
            @"            obj = '[Function]::' + name;\n" ] stringByAppendingString:
            @"            return;\n" ] stringByAppendingString:
            @"        }\n" ] stringByAppendingString:
            @"        if (typeof obj !== 'object') {\n" ] stringByAppendingString:
            @"            return;\n" ] stringByAppendingString:
            @"        }\n" ] stringByAppendingString:
            @"        for (var p in obj) {\n" ] stringByAppendingString:
            @"            switch (typeof obj[p]) {\n" ] stringByAppendingString:
            @"                case 'object':\n" ] stringByAppendingString:
            @"                    var ret = name ? name + '_' + p : p;\n" ] stringByAppendingString:
            @"                    _parseFunction(obj[p], ret, callback);\n" ] stringByAppendingString:
            @"                    break;\n" ] stringByAppendingString:
            @"                case 'function':\n" ] stringByAppendingString:
            @"                    var ret = name ? name + '_' + p : p;\n" ] stringByAppendingString:
            @"                    callback[ret] = (obj[p]);\n" ] stringByAppendingString:
            @"                    obj[p] = '[Function]::' + ret;\n" ] stringByAppendingString:
            @"                    break;\n" ] stringByAppendingString:
            @"                default:\n" ] stringByAppendingString:
            @"                    break;\n" ] stringByAppendingString:
            @"            }\n" ] stringByAppendingString:
            @"        }\n" ] stringByAppendingString:
            @"    };\n" ];
//    third method:print
    CommenMethodIMP = [CommenMethodIMP stringByAppendingString:@"    function _err"];
    CommenMethodIMP = [[[CommenMethodIMP stringByAppendingString:@"(s) {\n" ] stringByAppendingString:
            @"        console.error(s);\n" ] stringByAppendingString:
            @"    };\n"];
//    log error
    CommenMethodIMP = [CommenMethodIMP stringByAppendingString:@"    function _log"];
    CommenMethodIMP = [[[CommenMethodIMP stringByAppendingString:@"(s) {\n" ] stringByAppendingString:
            @"        console.log(s);\n" ] stringByAppendingString:
            @"    };\n"];
//four :CreateId
    CommenMethodIMP = [CommenMethodIMP stringByAppendingString:@"    function _getId"];
    CommenMethodIMP = [[[CommenMethodIMP stringByAppendingString:@"() {\n" ] stringByAppendingString:
            @"        return Math.floor(Math.random() * (1 << 12));\n" ] stringByAppendingString:
            @"    };\n"];
//    five:_callJava
    CommenMethodIMP = [CommenMethodIMP stringByAppendingString:@"    function _callJava"];
    CommenMethodIMP = [[[[[[[[[[[[[[[[[CommenMethodIMP stringByAppendingString:@"(id, module, method, args) {\n" ] stringByAppendingString:
        @"        if(typeof args === 'object' && args.length > 0) {\n" ] stringByAppendingString:
        @"           if(args[0].value.success == undefined)\n" ] stringByAppendingString:
        @"               args[0].value.success = '[Function]::' + args[0].name + '_success';\n" ] stringByAppendingString:
        @"           if(args[0].value.fail == undefined)\n" ] stringByAppendingString:
        @"               args[0].value.fail = '[Function]::' + args[0].name + '_fail';\n" ] stringByAppendingString:
        @"           if(args[0].value.complete == undefined)\n" ] stringByAppendingString:
        @"               args[0].value.complete = '[Function]::' + args[0].name + '_complete';\n" ] stringByAppendingString:
        @"        }\n" ] stringByAppendingString:
        @"        var req = {\n" ] stringByAppendingString:
        @"            id: id,\n" ] stringByAppendingString:
        @"            module: module,\n" ]stringByAppendingString:
        @"            method: method,\n" ] stringByAppendingString:
        @"            parameters: args\n" ] stringByAppendingString:
        @"        };\n" ] stringByAppendingString:
        @"        return JSON.parse(prompt(JSON.stringify(req)));\n" ]stringByAppendingString:
        @"    };\n"];
//    six:OnHyBridgeReady
    CommenMethodIMP = [[[[CommenMethodIMP stringByAppendingString:@"    this.On"]stringByAppendingString:
    _mProtocal]stringByAppendingString:
    @"Ready"]stringByAppendingString:
    @" = function"];
    CommenMethodIMP = [[[[[[[[[[[[[[[[[[[[CommenMethodIMP stringByAppendingString:@"() {\n" ] stringByAppendingString:
        @"        try {\n" ] stringByAppendingString:
        @"            var ready = window.on"]stringByAppendingString:
        _mProtocal]stringByAppendingString:
        @"Ready"] stringByAppendingString:
        @";\n" ] stringByAppendingString:
        @"            if (ready && typeof(ready) === 'function') {\n" ] stringByAppendingString:
        @"                ready();\n" ] stringByAppendingString:
        @"            } else {\n" ] stringByAppendingString:
        @"                var readyEvent = document.createEvent('Events');\n" ] stringByAppendingString:
        @"                readyEvent.initEvent('on"]stringByAppendingString:
        _mProtocal]stringByAppendingString:
        @"Ready"  ] stringByAppendingString:
        @"');\n" ] stringByAppendingString:
        @"                document.dispatchEvent(readyEvent);\n" ] stringByAppendingString:
        @"            }\n" ] stringByAppendingString:
        @"        } catch (e) {\n" ] stringByAppendingString:
        @"            console.error(e);\n" ] stringByAppendingString:
        @"        };\n" ] stringByAppendingString:
        @"    };\n"];
    return CommenMethodIMP;
}
@end

