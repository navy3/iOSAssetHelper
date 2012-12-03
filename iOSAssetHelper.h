//
//  iOSAssetHelper.h
//  iDilicious_ASI
//
//  Created by navy on 12-12-3.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>

@interface iOSAssetHelper : NSObject
{
    ALAssetsLibrary *assetsLib;
    NSInteger totalNumber;
}

+ (NSDictionary *)infoByAssert:(ALAsset *)result andType:(NSString *)type;
+ (UIImage *)findLargeImage:(ALAsset *)result;

@end
