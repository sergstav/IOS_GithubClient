//
//  User.h
//  GithubClient
//
//  Created by Sergey Stavitckii on 12/1/14.
//  Copyright (c) 2014 Sergey Stavitckii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, copy) NSString *login;

@property (nonatomic, copy) NSString *avatar_url;

@end
