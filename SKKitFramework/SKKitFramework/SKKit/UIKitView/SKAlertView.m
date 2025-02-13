//
//  SKAlertView.m
//  OleLifeApp
//
//  Created by yanghongjun19 on 2021/12/24.
//  Copyright © 2021 crv.jp007. All rights reserved.
//

#import "SKAlertView.h"

//#import "Wjapp.h"
//#import "WJTabBarController.h"

#define SKAlertRGB(x) [UIColor colorWithRed:((x & 0xff0000) >> 16)/255.0 green:((x & 0x00ff00) >> 8)/255.0 blue:(x & 0x0000ff)/255.0 alpha:1.0]

@implementation SKAlertView

+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)msg comfirmAction:(void (^)(void))comfirmAction{
    [self showAlertWithTitle:title message:msg confirmBtnText:@"确定" cancelBtnText:@"取消" cancelTextColor:nil confirmTextColor:nil comfirmAction:comfirmAction cancelAction:nil];
}

+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)msg cancelTextColor:(UIColor*) cancleTextColor confirmTextColor:(UIColor*)confirmTextColor  comfirmAction:(void (^)(void))comfirmAction {
    
    [self showAlertWithTitle:title message:msg confirmBtnText:@"确定" cancelBtnText:@"取消" cancelTextColor:cancleTextColor confirmTextColor:confirmTextColor comfirmAction:comfirmAction cancelAction:nil];

}


+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)msg comfirmAction:(void (^)(void))comfirmAction cancelAction:(void (^)(void))cancelAction{
    
    [self showAlertWithTitle:title message:msg  confirmBtnText:@"确定" cancelBtnText:@"取消" cancelTextColor:nil confirmTextColor:nil comfirmAction:comfirmAction cancelAction:cancelAction];
}




+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)msg cancelTextColor:(UIColor*) cancleTextColor confirmTextColor:(UIColor*)confirmTextColor comfirmAction:(void (^)(void))comfirmAction cancelAction:(void (^)(void))cancelAction {
   
    [self showAlertWithTitle:title message:msg  confirmBtnText:@"确定" cancelBtnText:@"取消" cancelTextColor:cancleTextColor confirmTextColor:confirmTextColor comfirmAction:comfirmAction cancelAction:cancelAction];
    
}


+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)msg confirmBtnText:(NSString*)confirmText cancelBtnText:(NSString*)cancleText comfirmAction:(void (^)(void))comfirmAction cancelAction:(void (^)(void))cancelAction{
    
    [self showAlertWithTitle:title message:msg  confirmBtnText:confirmText cancelBtnText:cancleText cancelTextColor:nil confirmTextColor:nil comfirmAction:comfirmAction cancelAction:cancelAction];
}

+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)msg confirmBtnText:(NSString*)confirmText cancelBtnText:(NSString*)cancleText cancelTextColor:(UIColor*) cancleTextColor confirmTextColor:(UIColor*)confirmTextColor comfirmAction:(void (^)(void))comfirmAction cancelAction:(void (^)(void))cancelAction {
    
    UIViewController* ctl = [SKAlertView getRootViewController];
    if (!ctl){
        return;
    }
    
    if (confirmText==nil ||[@"" isEqualToString:confirmText]) {
        confirmText = @"确定";
    }
    
    if (cancleText==nil ||[@"" isEqualToString:cancleText]) {
        cancleText = @"取消";
    }
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
   
    
    if (cancelAction) {
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:cancleText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            cancelAction();
        }];
        if (cancleTextColor==nil) {
            cancleTextColor = SKAlertRGB(0x666666);
        }
        [cancel setValue:cancleTextColor forKey:@"_titleTextColor"];
        [alert addAction:cancel];
    }
    
    if (comfirmAction) {
        UIAlertAction * comfirm = [UIAlertAction actionWithTitle:confirmText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            comfirmAction();
        }];
        
        if (confirmTextColor==nil) {
            confirmTextColor =SKAlertRGB(0x666666);
        }
        
        [comfirm setValue:confirmTextColor forKey:@"_titleTextColor"];
        [alert addAction:comfirm];
        
    }
    
    
    
    [ctl presentViewController:alert animated:YES completion:nil];
    
//    [[WJApp currentApp].window.rootViewController presentViewController:alert animated:YES completion:nil];
    
}
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
              cancelAction:(void (^)(void))cancelAction {
    
    UIViewController* ctl = [SKAlertView getRootViewController];
    if (!ctl){
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
     
    if (cancelAction) {
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:cancleText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            cancelAction();
        }];
        if (cancleTextColor==nil) {
            cancleTextColor =SKAlertRGB(0x666666);
        }
        if (cancelBtnFont==nil) {
            confirmTextColor =SKAlertRGB(0x666666);
        }
        [cancel setValue:cancleTextColor forKey:@"_titleTextColor"];
        [alert addAction:cancel];
    }
    
    if (comfirmAction) {
        UIAlertAction * comfirm = [UIAlertAction actionWithTitle:confirmText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            comfirmAction();
        }];
        
        if (confirmTextColor==nil) {
            confirmTextColor =SKAlertRGB(0x666666);
        }
        if (confirmFont==nil) {
            confirmTextColor =SKAlertRGB(0x666666);
        }
        
        [comfirm setValue:confirmTextColor forKey:@"_titleTextColor"];
        
        [alert addAction:comfirm];
        
    }
    NSMutableAttributedString *alertMsgStr = [[NSMutableAttributedString alloc]initWithString: msg];

    [alertMsgStr addAttribute:NSFontAttributeName value:messageFont range:NSMakeRange(0,alertMsgStr.length)];

    [alertMsgStr addAttribute:NSForegroundColorAttributeName value: messageColor range:NSMakeRange(0,alertMsgStr.length)];

    [alert setValue:alertMsgStr forKey:@"attributedTitle"];
     
    [ctl presentViewController:alert animated:YES completion:nil];
}

+(UIViewController*)getRootViewController{
    UIViewController* rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    if (!rootViewController){
        NSSet<UIScene *> *connectedScenes = [[UIApplication sharedApplication] connectedScenes];
        if (connectedScenes.count){
            UIScene *connectedScene = [[connectedScenes allObjects] firstObject];
            if ([connectedScene isMemberOfClass:UIWindowScene.class]){
                NSArray* wins = [((UIWindowScene*)connectedScene) windows];
                if (wins.count){
                    UIWindow* win = [wins firstObject];
                    rootViewController = [win rootViewController];
                }
                
            }
        }
    }
    
    return rootViewController;
}


@end
