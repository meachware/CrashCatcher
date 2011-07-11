//
//  main.m
//  CrashCatcher
//
//  Created by Greg Meach on 7/9/11.
//  Copyright 2011 MeachWare. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
