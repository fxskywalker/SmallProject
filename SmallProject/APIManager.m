//
//  APIManager.m
//  SmallProject
//
//  Created by FangXin on 4/27/16.
//  Copyright © 2016 FangXin. All rights reserved.
//

#import "APIManager.h"
#import "AFNetworking.h"
#import "InfoObject.h"


@implementation APIManager
@synthesize baseURL;


#pragma mark Singleton Methods

+ (id)sharedInstance
{
  static APIManager *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (id)init
{
  if (self = [super init])
  {
    self.baseURL = @"https://api.instagram.com/v1/users/3178274469/media/recent?access_token=3178274469.649a0fe.975563ad16f04634b468cb4b72d5477b&count=5&max_id=";
    self.infos = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void) getVedioAndImageLinkArray: (void(^)(bool))completion  {
  if (!self.baseURL) {
    completion(false);
    return;
  }
  
  NSURL *url = [NSURL URLWithString:self.baseURL];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  operation.responseSerializer = [AFJSONResponseSerializer serializer];
  
  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    if (responseObject[@"pagination"]) {
      self.baseURL = responseObject[@"pagination"][@"next_url"];
    } else {
      self.baseURL = nil;
    }
    
    for(int i = 0 ; i < [responseObject[@"data"] count]; i++) {
      InfoObject * tempObject = [[InfoObject alloc] init];
      tempObject.id = (NSString*)(responseObject[@"data"][i][@"id"]);
      tempObject.name = (NSString*)(responseObject[@"data"][i][@"user"][@"username"]);
      tempObject.userProfile = (NSString*)(responseObject[@"data"][i][@"user"][@"profile_picture"]);
      tempObject.like = [(responseObject[@"data"][i][@"comments"][@"count"]) integerValue];
      tempObject.comment = [(responseObject[@"data"][i][@"likes"][@"count"]) integerValue];
            
      if ([(NSString*)(responseObject[@"data"][i][@"type"]) isEqualToString:@"image"]) {
        tempObject.type = @"image";
        tempObject.imageNail = (NSString*) (responseObject[@"data"][i][@"images"][@"thumbnail"][@"url"]);
        tempObject.imageLarge = (NSString*) (responseObject[@"data"][i][@"images"][@"standard_resolution"][@"url"]);
      } else {
        tempObject.type = @"video";
        tempObject.videoNail = (NSString*) (responseObject[@"data"][i][@"videos"][@"low_resolution"][@"url"]);
        tempObject.videoLarge = (NSString*) (responseObject[@"data"][i][@"videos"][@"standard_resolution"][@"url"]);
      }
      [self.infos addObject:tempObject];
    }
    completion(true);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving data"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
  }];
  
  [operation start];
}

- (void) getImageByLink: (NSString*) link withCallBack: (void(^)(NSURL*))completion {
  NSURL *url = [NSURL URLWithString:link];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
  AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
  
  NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
  } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
    completion(filePath);
  }];
  [downloadTask resume];
}

- (void) getVideoByLink: (NSString*) link withCallBack: (void(^)(NSURL*))completion {
  NSURL *url = [NSURL URLWithString:link];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
  AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
  
  NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
  } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
    completion(filePath);
  }];
  [downloadTask resume];
}


@end