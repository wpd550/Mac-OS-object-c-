//
//  CreatePDFWithTable.m
//  testCreatePDFwithView
//
//  Created by wudong on 2018/3/13.
//  Copyright © 2018年 wudong. All rights reserved.
//

#import "CreatePDFWithTable.h"

@interface CreatePDFWithTable ()

@end

@implementation CreatePDFWithTable

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    CGFloat PageWidth = 420;
    CGFloat PageHeight = 594;
    CGRect mediaBox = CGRectMake(0, 0, PageWidth, PageHeight);
    
    NSString *filePath = @"/Users/wudong/Desktop/create.pdf";
    
    //设置路径
    const char *cfilePath = [filePath UTF8String];
    CFStringRef pathRef = CFStringCreateWithCString(NULL, cfilePath, kCFStringEncodingUTF8);
    CFStringRef myKeys[1];
    CFTypeRef myValues[1];
    myKeys[0] = kCGPDFContextMediaBox;
    myValues[0] = (CFTypeRef) CFDataCreate(NULL,(const UInt8 *)&mediaBox, sizeof (CGRect));
    
    CFDictionaryRef pageDictionary = CFDictionaryCreate(NULL, (const void**)myKeys, (const void**)myValues, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    CGContextRef myPDFContext = MyPDFContextCreateSecond(&mediaBox, pathRef);
    //开始绘画
    CGPDFContextBeginPage(myPDFContext, pageDictionary);
    CGContextSetRGBStrokeColor(myPDFContext, 1, 0, 0, 1);
    CGContextSetLineWidth(myPDFContext, 1.0);
    CGContextMoveToPoint(myPDFContext, 0, 100);
    CGContextAddLineToPoint(myPDFContext, 200 , 200);
    
    
    CGContextSetRGBStrokeColor(myPDFContext, 1, 0, 0, 1);//改变画笔颜色
    CGContextMoveToPoint(myPDFContext, 0 , 400);//开始坐标p1
    //CGContextAddArcToPoint(CGContextRef c, CGFloat x1, CGFloat y1,CGFloat x2, CGFloat y2, CGFloat radius)
    //x1,y1跟p1形成一条线的坐标p2，x2,y2结束坐标跟p3形成一条线的p3,radius半径,注意, 需要算好半径的长度,
    CGContextAddLineToPoint(myPDFContext, 400, 400);
   // CGContextAddArcToPoint(myPDFContext, 148, 68, 156, 80, 10);
    CGContextStrokePath(myPDFContext);//绘画路径
    

    
//    CGContextSetRGBFillColor (myPDFContext, 0, 0, 0, 1);
//    CGContextFillRect (myPDFContext, CGRectMake (0, 400, 400, 2));
    
    CGPDFContextEndPage(myPDFContext);
    
    //page 02
    CFDictionaryRef pageDictionary02 = CFDictionaryCreate(NULL, (const void**)myKeys, (const void**)myValues, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    CGPDFContextBeginPage(myPDFContext, pageDictionary02);
    
    CGContextSetRGBStrokeColor(myPDFContext, 0, 0, 1, 1);//改变画笔颜色
    CGContextMoveToPoint(myPDFContext, 140, 80);//开始坐标p1
    //CGContextAddArcToPoint(CGContextRef c, CGFloat x1, CGFloat y1,CGFloat x2, CGFloat y2, CGFloat radius)
    //x1,y1跟p1形成一条线的坐标p2，x2,y2结束坐标跟p3形成一条线的p3,radius半径,注意, 需要算好半径的长度,
    CGContextAddArcToPoint(myPDFContext, 148, 68, 156, 80, 10);
    CGContextStrokePath(myPDFContext);//绘画路径
    
    //右
    CGContextMoveToPoint(myPDFContext, 160, 80);//开始坐标p1
    //CGContextAddArcToPoint(CGContextRef c, CGFloat x1, CGFloat y1,CGFloat x2, CGFloat y2, CGFloat radius)
    //x1,y1跟p1形成一条线的坐标p2，x2,y2结束坐标跟p3形成一条线的p3,radius半径,注意, 需要算好半径的长度,
    CGContextAddArcToPoint(myPDFContext, 168, 68, 176, 80, 10);
    CGContextStrokePath(myPDFContext);//绘画路径
    
    //右
    CGContextMoveToPoint(myPDFContext, 150, 90);//开始坐标p1
    //CGContextAddArcToPoint(CGContextRef c, CGFloat x1, CGFloat y1,CGFloat x2, CGFloat y2, CGFloat radius)
    //x1,y1跟p1形成一条线的坐标p2，x2,y2结束坐标跟p3形成一条线的p3,radius半径,注意, 需要算好半径的长度,
    CGContextAddArcToPoint(myPDFContext, 158, 102, 166, 90, 10);
    CGContextStrokePath(myPDFContext);//绘画路径
    
    CGPDFContextEndPage(myPDFContext);
    
    //释放相关资源
    CFRelease(pageDictionary);
    CFRelease(myValues[0]);
    CGContextRelease(myPDFContext);
}

CGContextRef MyPDFContextCreateSecond (const CGRect *inMediaBox, CFStringRef path)
{
    CGContextRef myOutContext = NULL;
    CFURLRef url;
    CGDataConsumerRef dataConsumer;

    url = CFURLCreateWithFileSystemPath (NULL, path, kCFURLPOSIXPathStyle, false);

    if (url != NULL)
    {
        dataConsumer = CGDataConsumerCreateWithURL(url);
        if (dataConsumer != NULL)
        {
            myOutContext = CGPDFContextCreate (dataConsumer, inMediaBox, NULL);
            CGDataConsumerRelease (dataConsumer);
        }
        CFRelease(url);
    }
    return myOutContext;
}
@end
