//
//  UIViewController+Base.h
//  CollagePicture
//
//  Created by simon on 15/7/6.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIViewController (LoginAndAlert)

//适用于最多2个按钮的警告框
- (void)zh_presentAlertControllerStyleAlertInitWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle cancleHandler:(void (^ __nullable)(UIAlertAction *action))handler doButtonTitle:(nullable NSString *)doButtonTitle doHandler:(void (^ __nullable)(UIAlertAction *action))doHandler;

/**
 判断是否有登录过，如果没有登录则弹出登录界面

 @param flag 是否需要弹出警告提示
 @return 返回是否登录过；
 */
- (BOOL)zh_performIsLoginActionWithPopAlertView:(BOOL)flag;

/**
 判断是否有登录过，如果没有登录弹出登录界面； 如果登录过则执行action事件

 @param action 如果是登录的，则执行这个事件；
 */
- (void)zh_performIsLoginActionWithSelector:(SEL)action withPopAlertView:(BOOL)flag;


- (void)zh_performLoginAlertViewWithSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;



//- (void)pushBaseGeneralDyanmicControllerWithRequestUrlString:(NSString *)urlString title:(NSString *)aTitle;


- (void)zh_presentLoginController;




@end

NS_ASSUME_NONNULL_END
