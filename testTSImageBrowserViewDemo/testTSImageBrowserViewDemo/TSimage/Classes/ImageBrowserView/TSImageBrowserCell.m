//
//  TSImageBrowserCell.m
//
//  Created by liu on 2018/3/8.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "TSImageBrowserCell.h"

//---------------------------------------------------------------------------------
// setBundleImageOnLayer
//
// Utilty function that creates, and sets the image (from the bundle) on the layer.
//---------------------------------------------------------------------------------
//static void setBundleImageOnLayer(CALayer *layer, CFStringRef imageName)
//{
//    CGImageRef image = NULL;
//    NSString *path = [[NSBundle mainBundle] pathForResource:((__bridge NSString *)imageName).stringByDeletingPathExtension ofType:((__bridge NSString *)imageName).pathExtension];
//    if (!path)
//    {
//        return;
//    }
//
//    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:path], NULL);
//    if (!imageSource)
//    {
//        return;
//    }
//
//    image = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
//    if (!image)
//    {
//        CFRelease(imageSource);
//        return;
//    }
//
//    layer.contents = (__bridge id)image;
//
//    CFRelease(imageSource);
//    CFRelease(image);
//}

@interface TSImageBrowserCell()

@end

#pragma mark -

@implementation TSImageBrowserCell

//---------------------------------------------------------------------------------
// layerForType:
//
// Provides the layers for the given types.
//---------------------------------------------------------------------------------
- (CALayer *)layerForType:(NSString*) type
{
	CGColorRef color;
	
	// retrieve some usefull rects
	NSRect frame = [self frame];
    NSRect imageFrame = [self imageFrame];
	NSRect relativeImageFrame =
        NSMakeRect(imageFrame.origin.x - frame.origin.x, imageFrame.origin.y - frame.origin.y, imageFrame.size.width, imageFrame.size.height);
    
	// 占位layer 没有数据时显示
	if (type == IKImageBrowserCellPlaceHolderLayer)
    {
		// create a place holder layer
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);

		CALayer *placeHolderLayer = [CALayer layer];
        placeHolderLayer.frame = NSRectToCGRect(relativeImageFrame);
//        placeHolderLayer.frame = *(CGRect*) &relativeImageFrame;

		CGFloat fillComponents[4] = {0.9, 0.9, 0.9, 0.3};
		CGFloat strokeComponents[4] = {0.9, 0.9, 0.9, 0.9};
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

		// set a background color
		color = CGColorCreate(colorSpace, fillComponents);
		placeHolderLayer.backgroundColor = color;
		CFRelease(color);
		
		// set a stroke color
		color = CGColorCreate(colorSpace, strokeComponents);
		placeHolderLayer.borderColor = color;
		CFRelease(color);
	
		placeHolderLayer.borderWidth = 2.0;
		placeHolderLayer.cornerRadius = 10;
		CFRelease(colorSpace);
		
		[layer addSublayer:placeHolderLayer];
		
		return layer;
	}
	
	// 前景layer
//    if (type == IKImageBrowserCellForegroundLayer)
//    {
//        // no foreground layer on place holders
//        if ([self cellState] != IKImageStateReady)
//        {
//            return nil;
//        }
//
//        // create a foreground layer that will contain several childs layer
//        CALayer *layer = [CALayer layer];
//        layer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
//
//        NSRect imageContainerFrame = [self imageContainerFrame];
//        NSRect relativeImageContainerFrame = NSMakeRect(imageContainerFrame.origin.x - frame.origin.x, imageContainerFrame.origin.y - frame.origin.y, imageContainerFrame.size.width, imageContainerFrame.size.height);
//
//        // add a glossy overlay
//        CALayer *glossyLayer = [CALayer layer];
//        glossyLayer.frame = *(CGRect *) &relativeImageContainerFrame;
//        setBundleImageOnLayer(glossyLayer, CFSTR("glossy.png"));
//        [layer addSublayer:glossyLayer];
//
//        // add a pin icon
//        CALayer *pinLayer = [CALayer layer];
//        setBundleImageOnLayer(pinLayer, CFSTR("pin.tiff"));
//        pinLayer.frame = CGRectMake((frame.size.width/2)-5, frame.size.height - 17, 24, 30);
//        [layer addSublayer:pinLayer];
//
//        return layer;
//    }

	// 选中时layer
	if (type == IKImageBrowserCellSelectionLayer)
    {
		// create a selection layer
		CALayer *selectionLayer = [CALayer layer];
		selectionLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
		
        NSColor *selectColor = [self.imageBrowserView valueForKey:IKImageBrowserSelectionColorKey];
        CGFloat red = 0.0;
        CGFloat green = 0.0;
        CGFloat blue = 0.0;
        if (selectColor != nil) {
            red = selectColor.redComponent;
            green = selectColor.greenComponent;
            blue = selectColor.blueComponent;
        }
		CGFloat fillComponents[4] = {red, green, blue, 0.2};
		CGFloat strokeComponents[4] = {red, green, blue, 1.0};
		
		// set a background color
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		color = CGColorCreate(colorSpace, fillComponents);
		selectionLayer.backgroundColor = color;
		CFRelease(color);
		
		// set a border color
		color = CGColorCreate(colorSpace, strokeComponents);
        CFRelease(colorSpace);
		selectionLayer.borderColor = color;
		CFRelease(color);

		selectionLayer.borderWidth = 2.0;
		selectionLayer.cornerRadius = 5;
		
		return selectionLayer;
	}
	
	// 背景
	if (type == IKImageBrowserCellBackgroundLayer)
    {
		// no background layer on place holders
		if ([self cellState] != IKImageStateReady)
        {
			return nil;
        }

		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
		NSRect backgroundRect = NSMakeRect(0, 0, frame.size.width, frame.size.height);		
		
		CALayer *photoBackgroundLayer = [CALayer layer];
        photoBackgroundLayer.frame = NSRectToCGRect(backgroundRect);
//        photoBackgroundLayer.frame = *(CGRect*) &backgroundRect;
        
        CGFloat fillComponents[4] = {0.95, 0.95, 0.95, 1.0};
        CGFloat strokeComponents[4] = {0.2, 0.2, 0.2, 0.5};

        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

        color = CGColorCreate(colorSpace, fillComponents);
        photoBackgroundLayer.backgroundColor = color;
        CFRelease(color);

        color = CGColorCreate(colorSpace, strokeComponents);
        photoBackgroundLayer.borderColor = color;
        CFRelease(color);

        CFRelease(colorSpace);

//        photoBackgroundLayer.borderWidth = 1.0;
		photoBackgroundLayer.shadowOpacity = 0.5;
        photoBackgroundLayer.shadowOffset = CGSizeMake(0.0, -1.0);
//        photoBackgroundLayer.cornerRadius = 3;
		
		[layer addSublayer:photoBackgroundLayer];
		
		return layer;
	}
	
	return nil;
}

//---------------------------------------------------------------------------------
// selectionFrame
//
// Make the selection frame a little bit larger than the default one.
//---------------------------------------------------------------------------------
- (NSRect)selectionFrame
{
    return NSInsetRect([self frame], -5, -5);
}

//---------------------------------------------------------------------------------
// imageFrame
//
// Define where the image should be drawn.
//---------------------------------------------------------------------------------
- (NSRect)imageFrame
{
	// 设置图片frame为容器的frame大小
	NSRect imageFrame = [super imageFrame];
    imageFrame = self.imageContainerFrame;
    
    // round it 取整消除误差
    imageFrame.origin.x = floorf(imageFrame.origin.x);
    imageFrame.origin.y = floorf(imageFrame.origin.y);
    imageFrame.size.width = ceilf(imageFrame.size.width);
    imageFrame.size.height = ceilf(imageFrame.size.height);
    
	return imageFrame;
}
/*
//---------------------------------------------------------------------------------
// imageContainerFrame
//
// Override the default image container frame.
//---------------------------------------------------------------------------------
- (NSRect)imageContainerFrame
{
	NSRect container = [super frame];
	
	// make the image container 15 pixels up
	container.origin.y += 15;
	container.size.height -= 15;
	
	return container;
}

//---------------------------------------------------------------------------------
// titleFrame
//
// Override the default frame for the title.
//---------------------------------------------------------------------------------
- (NSRect)titleFrame
{
	// get the default frame for the title
	NSRect titleFrame = [super titleFrame];
	
	// move the title inside the 'photo' background image
	NSRect container = [self frame];
	titleFrame.origin.y = container.origin.y + 3;
	
	// make sure the title has a 7px margin with the left/right borders
	float margin = titleFrame.origin.x - (container.origin.x + 7);
	if (margin < 0)
    {
		titleFrame = NSInsetRect(titleFrame, -margin, 0);
    }
    
	return titleFrame;
}
*/

@end
