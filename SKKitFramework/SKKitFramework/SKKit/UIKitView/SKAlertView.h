//
//  AlertViewUtil.h
//  OleLifeApp
//
//  Created by yanghongjun19 on 2021/12/24.
//  Copyright © 2021 crv.jp007. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SKAlertView : NSObject<UITextViewDelegate>


/**
 * 1:
 */
+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)msg comfirmAction:(void (^)(void))comfirmAction;


+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)msg comfirmAction:(void (^)(void))comfirmAction cancelAction:(void (^)(void))cancelAction;




+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)msg confirmBtnText:(NSString*)confirmText cancelBtnText:(NSString*)confirmText cancelTextColor:(UIColor*) cancleTextColor confirmTextColor:(UIColor*)confirmTextColor comfirmAction:(void (^)(void))comfirmAction cancelAction:(void (^)(void))cancelAction;



/**
 * 2: 需要传 确定和取消按钮颜色
 */

+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)msg cancelTextColor:(UIColor*) cancleTextColor confirmTextColor:(UIColor*)confirmTextColor  comfirmAction:(void (^)(void))comfirmAction;

+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)msg cancelTextColor:(UIColor*) cancleTextColor confirmTextColor:(UIColor*)confirmTextColor comfirmAction:(void (^)(void))comfirmAction cancelAction:(void (^)(void))cancelAction;

+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)msg confirmBtnText:(NSString*)confirmText cancelBtnText:(NSString*)confirmText comfirmAction:(void (^)(void))comfirmAction cancelAction:(void (^)(void))cancelAction;

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)msg
               messageFont:(UIFont *)messageFont
              messageColor:(UIColor*) messageColor
            confirmBtnText:(NSString *)confirmText
            confirmBtnFont:(UIFont *)confirmFont
             cancelBtnText:(NSString *)cancleText
           cancelTextColor:(UIColor*) cancleTextColor
             cancelBtnFont:(UIFont *)cancelBtnFont
          confirmTextColor:(UIColor*)confirmTextColor
             comfirmAction:(void (^)(void))comfirmAction
              cancelAction:(void (^)(void))cancelAction;


@end

