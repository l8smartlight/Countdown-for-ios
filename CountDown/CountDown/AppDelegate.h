//
//  AppDelegate.h
//  CountDown
//
//  Created by Carlos on 21/04/14.
//  Copyright (c) 2014 l8smartlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "l8_sdk_objc.h"
#import "TIBLECBKeyfob.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,TIBLECBKeyfobDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) id<L8> l8;

@property (nonatomic,strong) NSArray *l8Array;

@end
