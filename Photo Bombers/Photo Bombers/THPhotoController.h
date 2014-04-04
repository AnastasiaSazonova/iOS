//
//  THPhotoController.h
//  Photo Bombers
//
//  Created by Anastasia on 3/27/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THPhotoController : NSObject

+(void)imageForPhoto:(NSDictionary *)photo size:(NSString *)size completion:(void (^)(UIImage * image))completion;

@end
