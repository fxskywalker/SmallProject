//
//  LoginController.h
//  SmallProject
//
//  Created by FangXin on 4/29/16.
//  Copyright © 2016 FangXin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface LoginController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *loginWebView;
@property (weak, nonatomic) MainViewController* mainVC;
@end
