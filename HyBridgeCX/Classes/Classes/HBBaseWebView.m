//
//  HBBaseWebView.m
//  Alamofire
//
//  Created by CX02 on 2017/12/2.
//
#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import "HBBaseWebView.h"
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
static char imgUrlArrayKey;
- (void)setMethod:(NSArray *)imgUrlArray {
    objc_setAssociatedObject(self, &imgUrlArrayKey, imgUrlArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)getImgUrlArray {
    return objc_getAssociatedObject(self, &imgUrlArrayKey);
}
    
-(NSArray *)getImageUrlByJS:(HBBaseWebView *)wkWebView

{
    //查看大图代码
    //js方法遍历图片添加点击事件返回图片个数
    
    static  NSString * const jsGetImages = @"function getImages(){\n     var objs = document.getElementsByTagName(\"img\");\n    var imgUrlStr='';\n    for(var i=0;i<objs.length;i++){\n    if(i==0){\n    if(objs[i].alt==''){\n    imgUrlStr=objs[i].src;\n    }\n    }else{\n    if(objs[i].alt==''){\n    imgUrlStr+='#'+objs[i].src;\n    }\n    }\n    objs[i].onclick=function(){\n     if(this.alt==''){\n    document.location=\"myweb:imageClick:\"+this.src;\n     }\n     };\n    };\n    return imgUrlStr;\n    };";
    //用js获取全部图片
    [wkWebView evaluateJavaScript:jsGetImages completionHandler:nil];
    NSString *js2 = @"getImages()";
    __block NSArray *array = [NSArray array];
    [wkWebView evaluateJavaScript:js2 completionHandler:^(id Result, NSError * error) {
        NSString *resurlt = [NSString stringWithFormat:@"%@",Result];
        if([resurlt hasPrefix:@"#"]){
            resurlt = [resurlt substringFromIndex:1];
        }
        array = [resurlt componentsSeparatedByString:@"#"];
        [wkWebView setMethod:array];
    }];
    return array;
}
- (BOOL)showBigImage:(NSURLRequest *)request
{
    //将url转换为string
    NSString *requestString = [[request URL] absoluteString];
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([requestString hasPrefix:@"myweb:imageClick:"]){
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        NSLog(@"image url------%@", imageUrl);
        NSArray *imgUrlArr=[self getImgUrlArray];
        NSInteger index=0;
        for (NSInteger i=0; i<[imgUrlArr count]; i++) {
            if([imageUrl isEqualToString:imgUrlArr[i]]){
                index=i;
                break;
            }
        }
        NSMutableArray *showImgWithImageURLArray = [[NSMutableArray alloc] init];
        [showImgWithImageURLArray addObject:imgUrlArr];
        [showImgWithImageURLArray addObject:[NSNumber numberWithInteger:index]];
        [_mdelegate showImgWithImageURL:showImgWithImageURLArray];
        return YES;
    }
    return NO;
}
@end
