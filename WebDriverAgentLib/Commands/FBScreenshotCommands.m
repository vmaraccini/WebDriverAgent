/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBScreenshotCommands.h"

#import "XCUIDevice+FBHelpers.h"

@implementation FBScreenshotCommands

#pragma mark - <FBCommandHandler>

+ (NSArray *)routes
{
  return
  @[
    [[FBRoute GET:@"/screenshot"].withoutSession respondWithTarget:self action:@selector(handleGetScreenshot:)],
    [[FBRoute GET:@"/screenshot"] respondWithTarget:self action:@selector(handleGetScreenshot:)],
    [[FBRoute GET:@"/screenshot-lowres"] respondWithTarget:self action:@selector(handleGetScreenshotLowResolution:)],
    [[FBRoute GET:@"/screenshot-lowres"].withoutSession respondWithTarget:self action:@selector(handleGetScreenshotLowResolution:)]
  ];
}


#pragma mark - Commands

+ (id<FBResponsePayload>)handleGetScreenshot:(FBRouteRequest *)request
{
  NSString *screenshot = [[XCUIDevice sharedDevice].fb_screenshot base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
  return FBResponseWithObject(screenshot);
}

+ (id<FBResponsePayload>)handleGetScreenshotLowResolution:(FBRouteRequest *)request
{
    UIImage *screenshot = [[UIImage alloc] initWithData:[XCUIDevice sharedDevice].fb_screenshot];
    
    CGSize size = CGSizeApplyAffineTransform(screenshot.size, CGAffineTransformMakeScale(0.25, 0.25));
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [screenshot drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString *screenshotString = [UIImagePNGRepresentation(scaledImage) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return FBResponseWithObject(screenshotString);
}

@end
