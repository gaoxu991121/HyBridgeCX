//
//  MethodMap.m
//  Alamofire
//
//  Created by CX02 on 2017/12/2.
//

#import <Foundation/Foundation.h>
#import "MethodMap.h"
#import "HBBaseWebView.h"
static NSMutableDictionary *methodLevel;
@implementation MethodMap{
    
}
- (NSMutableDictionary*)setLevel{
    methodLevel = [[NSMutableDictionary alloc]init];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"@STATIC.toast"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Network.request"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"Network.removeAllCookie"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Storage.setStorage"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Storage.getStorage"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Device.getDisplayMetrics"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Device.getAppInfo"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Device.getDeviceBuildInfo"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Interface.navigateTo"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Interface.toast"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Page.onResume"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Page.onPause"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Page.onStop"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Page.closeThis"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Event.register"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView base]] forKey:@"Event.post"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"User.login"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"User.reLogin"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"User.getDID"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"User.getUUID"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"User.getUUIDSync"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"User.getUserInfo"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"User.getUserInfoSync"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"User.setUserInfo"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"User.bind"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"User.addToBlackList"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"User.removeFromBlackList"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView core]] forKey:@"User.getUserInfoForMiniApp"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView core]] forKey:@"Interface.navigateToForMiniApp"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"Curriculum.getDefaultInfo"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"Curriculum.reloadCourse"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"Curriculum.getNowCurriculum"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"Curriculum.createCurriculum"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"Curriculum.updateCurriculum"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"Curriculum.manageCurriculum"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"Curriculum.showCurriculum"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"Curriculum.addCourse"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"Curriculum.updateCourse"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"Curriculum.deleteCourse"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"Curriculum.weekPicker"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"Interface.updateRedDot"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"Interface.reduceRedDot"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"Interface.openCircle"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"Interface.refreshCircleInfo"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"Interface.setCommentBar"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"Interface.systemNavigateTo"];
    [methodLevel setObject:[NSNumber numberWithInt:[HBBaseWebView system]] forKey:@"Interface.manageMiniAppCompleted"];

    return methodLevel;
}
+ (int)getMethodLevel:(NSString*)methodName{
    if (methodLevel == nil || methodLevel.allKeys.count == 0) {
        NSMutableDictionary *levelMap =  [[self alloc] setLevel];
        if (![levelMap.allKeys containsObject:methodName]||levelMap[methodName] == nil) {
            NSLog(@"%@", methodName);
            return 0;
        }else{
            NSLog(@"%@", methodName);
            NSNumber *num = levelMap[methodName];
            return [num intValue];
        }
    }else{
        if (![methodLevel.allKeys containsObject:methodName]||methodLevel[methodName] == nil) {
            return 0;
        }else{
            NSNumber *num = methodLevel[methodName];
            return [num intValue];
        }
    }
}
//private

@end
