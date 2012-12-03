//
//  iOSAssetHelper.m
//  iDilicious_ASI
//
//  Created by navy on 12-12-3.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import "iOSAssetHelper.h"

@implementation iOSAssetHelper

- (void)dealloc
{
    [assetsLib release];
    assetsLib = nil;
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        if (!assetsLib) {
            assetsLib = [[ALAssetsLibrary alloc] init];
        }
        //totalNumber is flag,used judge all photos is add to dictionary
        totalNumber = 0;
    }
    return self;
}

- (void)getAlbumAssets
{
    NSMutableArray* assetURLDictionaries = [[[NSMutableArray alloc] init] autorelease];
    
    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result != nil) {
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                [assetURLDictionaries addObject:result];
                if ([assetURLDictionaries count] == totalNumber) {
                    //todo
                    //use assetURLDictionaries here
                    
                }
            }
        }
    };
    
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
            //this code show just enumerate SavedPhotos in iOS Photos Application
            if (ALAssetsGroupSavedPhotos == [[group valueForProperty:ALAssetsGroupPropertyType] intValue] ) {
                totalNumber = [group numberOfAssets];
                [group enumerateAssetsUsingBlock:assetEnumerator];
                //[group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:assetEnumerator];
            }
            
        }
    };
    
    [assetsLib enumerateGroupsWithTypes:ALAssetsGroupAll
                       usingBlock:assetGroupEnumerator
                     failureBlock:^(NSError *error){
                         NSLog(@"error");
                     }];
}

- (void)getAssetsFromAssetURL:(NSString *)urlString
{
    [assetsLib assetForURL:[NSURL URLWithString:urlString] resultBlock:^(ALAsset *asset)
     {
         //use asset here
         NSLog(@"%@",asset);
     }
        failureBlock:^(NSError *error)
     {
         NSLog(@"error");
     }
     ];
}

+ (NSDictionary *)infoByAssert:(ALAsset *)result andType:(NSString *)type
{
    ALAssetRepresentation *image_representation = [result defaultRepresentation];
    
    // create a buffer to hold image data
    uint8_t *buffer = (Byte*)malloc(image_representation.size);
    NSUInteger length = [image_representation getBytes:buffer fromOffset: 0.0  length:image_representation.size error:nil];
    
    if (length != 0)  {
        
        // buffer -> NSData object; free buffer afterwards
        NSData *adata = [[NSData alloc] initWithBytesNoCopy:buffer length:image_representation.size freeWhenDone:YES];
        
        // identify image type (jpeg, png, RAW file, ...) using UTI hint
        NSDictionary* sourceOptionsDict = [NSDictionary dictionaryWithObjectsAndKeys:(id)[image_representation UTI] ,kCGImageSourceTypeIdentifierHint,nil];
        
        // create CGImageSource with NSData
        CGImageSourceRef sourceRef = CGImageSourceCreateWithData((CFDataRef) adata,  (CFDictionaryRef) sourceOptionsDict);
        
        // get imagePropertiesDictionary
        CFDictionaryRef imagePropertiesDictionary;
        imagePropertiesDictionary = CGImageSourceCopyPropertiesAtIndex(sourceRef,0, NULL);
        
        // get exif data
        //use param type here,like kCGImagePropertyExifDictionary,kCGImagePropertyTIFFDictionary and so on.
        CFDictionaryRef exif = (CFDictionaryRef)CFDictionaryGetValue(imagePropertiesDictionary, (CFStringRef)type);
        NSDictionary *exif_dict = (NSDictionary*)exif;
        
        [adata release];
        //CFRelease(sourceRef);
        //CFRelease(imagePropertiesDictionary);
        
        return exif_dict;
    }
    return nil;
}

+ (UIImage *)findLargeImage:(ALAsset *)result
{
    UIImage *img = nil;
    ALAssetRepresentation *image_representation = [result defaultRepresentation];
    CGImageRef iref = [image_representation fullResolutionImage];
    if (iref)
        img = [UIImage imageWithCGImage:iref scale:image_representation.scale orientation:image_representation.orientation];
    return img;
}

@end
