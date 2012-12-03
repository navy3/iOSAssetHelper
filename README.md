iOSAssetHelper
==============

show how to use ALAssetsLibrary and ALAssets on iOS.

use this 4 funcion include full operate about use iOS Photo Albums.

How to use

enumerate -> save -> use url -> find large image -> find image info.
<p>
1,`- (void)getAlbumAssets` function.<p>
used to enumerate iOS Photos Application Albums.

2,`- (void)getAssetsFromAssetURL:(NSString *)urlString` function.<p>
used to get asset from url.

3,`+ (NSDictionary *)infoByAssert:(ALAsset *)result andType:(NSString *)type` function.<p>
get asset infomation like exif,gps,tiff and so on.

4,`+ (UIImage *)findLargeImage:(ALAsset *)result`function<p>
get large image by asset