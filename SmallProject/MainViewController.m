//
//  MainViewController.m
//  SmallProject
//
//  Created by FangXin on 4/27/16.
//  Copyright © 2016 FangXin. All rights reserved.
//

#import "MainViewController.h"
#import "APIManager.h"
#import <MediaPlayer/MediaPlayer.h>



NSString *accessToken = @"ee544bba51cf4b4cbf1e1391443cb0c1";

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *showImage;


@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  APIManager * temp = [APIManager sharedInstance];
  [temp getVedioAndImageLinkArray];
  
 
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
