//
//  APIManager.h
//  SmallProject
//
//  Created by FangXin on 4/27/16.
//  Copyright © 2016 FangXin. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface APIManager : NSObject
{
  NSString * baseURL;
  NSMutableArray * imfos;
  NSString * token;
}
@property (nonatomic, retain) NSString *baseURL;
@property (nonatomic, retain) NSMutableArray *infos;
@property (nonatomic, retain) NSString *token;

- (void) getImageByLink: (NSString*) link withCallBack: (void(^)(NSURL*))completion;
- (void) getVideoByLink: (NSString*) link withCallBack: (void(^)(NSURL*))completion;
- (void) getVedioAndImageLinkArray: (void(^)(bool))completion;
-(void) buildUpBaseURL:(NSString *) urlToken;

+ (id)sharedInstance;

@end

