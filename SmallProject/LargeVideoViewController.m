//
//  LargeVideoViewController.m
//  SmallProject
//
//  Created by FangXin on 4/29/16.
//  Copyright © 2016 FangXin. All rights reserved.
//

#import "LargeVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation LargeVideoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.view.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void) playVideo: (NSURL*) url {
  MPMoviePlayerViewController* player = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
  player.moviePlayer.fullscreen = YES;
  player.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
  [self.view addSubview:player.view];
}
@end
