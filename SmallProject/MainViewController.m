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
  [temp getImageByLink:^(NSURL *reply){
    MPMoviePlayerController *moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:reply];
    [moviePlayerController.view setFrame:self.view.frame];
    [self.view addSubview:moviePlayerController.view];
    moviePlayerController.movieSourceType=MPMovieSourceTypeFile;
    moviePlayerController.fullscreen = YES;
    [moviePlayerController play];
  }];
 
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
