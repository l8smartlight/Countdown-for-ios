//
//  AppDelegate.m
//  CountDown
//
//  Created by Carlos on 21/04/14.
//  Copyright (c) 2014 l8smartlight. All rights reserved.
//

#import "AppDelegate.h"

#import "l8_sdk_objc.h"
#import "ColorUtils.h"
#import "RESTFulL8.h"
#import "L8Sensor.h"
#import "TIBLECBKeyfob.h"
#import "BluetoothL8.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
  /*  
   //Example of use L8 simulator
   L8DiscoverOperationHandler success = ^(NSArray *result) {
        
        self.l8 = [result objectAtIndex:0];
        
        NSLog(@"Created L8 with id: %@ accesible at %@ elements: %d", [self.l8 l8Id], [self.l8 connectionURL],result.count);
        
        L8VoidOperationHandler v = ^() {
            NSLog(@"success");
        };
        L8ColorOperationHandler c = ^(UIColor *result) {
            NSLog(@"success: %@", [result stringValue]);
        };
        L8IntegerOperationHandler i = ^(NSInteger result) {
            NSLog(@"success: %d", result);
        };
        L8BooleanOperationHandler b = ^(BOOL result) {
            NSLog(@"success: %@", result? @"Y": @"N");
        };
        L8VersionOperationHandler r = ^(L8Version *result) {
            NSLog(@"success: %d %d", result.hardware, result.software);
        };
        L8JSONOperationHandler f = ^(NSMutableDictionary *r) {
            NSLog(@"failure: %@", r);
        };
        
        
        [self.l8 setSuperLED:[UIColor yellowColor] withSuccess:v failure:f];
        
        [self.l8 setLED:CGPointMake(0, 0) color:[UIColor cyanColor] withSuccess:v failure:f];
        [self.l8 setLED:CGPointMake(2, 3) color:[UIColor cyanColor] withSuccess:v failure:f];
        [self.l8 setLED:CGPointMake(5, 7) color:[UIColor redColor] withSuccess:v failure:f];
        [self.l8 setLED:CGPointMake(7, 7) color:[UIColor cyanColor] withSuccess:v failure:f];
        
        [self.l8 clearLED:CGPointMake(7, 7) withSuccess:v failure:f];
        [self.l8 clearLED:CGPointMake(0, 0) withSuccess:v failure:f];
        
        [self.l8 readLED:CGPointMake(2, 3) withSuccess:c failure:f];
        [self.l8 readLED:CGPointMake(5, 7) withSuccess:c failure:f];
        
        [self.l8 readSuperLEDWithSuccess:c failure:f];
        
        [self.l8 readBatteryStatusWithSuccess:i failure:f];
        [self.l8 readButtonWithSuccess:i failure:f];
        [self.l8 readMemorySizeWithSuccess:i failure:f];
        [self.l8 readFreeMemoryWithSuccess:i failure:f];
        
        [self.l8 readBluetoothEnabledWithSuccess:b failure:f];
        
        [self.l8 readVersionWithSuccess:r failure:f];
        
        [self.l8 readSensorEnabled:[L8Sensor proximitySensor] withSuccess:b failure:f];
        [self.l8 readSensorEnabled:[L8Sensor temperatureSensor] withSuccess:b failure:f];
        
        [self.l8 disableSensor:[L8Sensor proximitySensor] withSuccess:v failure:f];
        [self.l8 enableSensor:[L8Sensor proximitySensor] withSuccess:v failure:f];
        
        [self.l8 readSensorsStatusWithSuccess:^(NSArray *result) {
            NSLog(@"sensors %@", result);
        }
                                      failure:f];
        
        
        [self.l8 readSensorStatus:[L8Sensor temperatureSensor]
                      withSuccess:^(L8SensorStatus *result) {
                          L8TemperatureStatus *status = (L8TemperatureStatus *)result;
                          NSLog(@"temperature: %@", status);
                      }
                          failure:f];
        [self.l8 readSensorStatus:[L8Sensor proximitySensor]
                      withSuccess:^(L8SensorStatus *result) {
                          L8ProximityStatus *status = (L8ProximityStatus *)result;
                          NSLog(@"proximity: %@", status);
                      }
                          failure:f];*/
    /*    [self.l8 readSensorStatus:[L8Sensor accelerationSensor]
                      withSuccess:^(L8SensorStatus *result) {
                          L8AccelerationStatus *status = (L8AccelerationStatus *)result;
                          NSLog(@"acceleration: %@", status);
                      }
                          failure:f];*/
        
   /*     NSMutableArray *colorMatrix = [NSMutableArray arrayWithCapacity:8];
        for (int i = 0; i < 8; i++) {
            [colorMatrix addObject:[NSMutableArray arrayWithCapacity:8]];
            for (int j = 0; j < 8; j++) {
                [[colorMatrix objectAtIndex:i] addObject:[UIColor redColor]];
            }
        }
        [self.l8 clearMatrixWithSuccess:v failure:f];
        [self.l8 setMatrix:colorMatrix withSuccess:v failure:f];*/
        
     /*   L8ColorMatrixOperationHandler cm = ^(NSArray *colorMatrix) {
            for (int i = 0; i < colorMatrix.count; i++) {
                NSArray *columns = [colorMatrix objectAtIndex:i];
                for (int j = 0; j < columns.count; j++) {
                    UIColor *color = [columns objectAtIndex:j];
                    NSLog(@"(%d, %d): %@", i, j, [color stringValue]);
                }
            }
        };
        [self.l8 readMatrixWithSuccess:cm failure:f];
        
        NSMutableArray *colorMatrix1 = [NSMutableArray arrayWithCapacity:8];
        for (int i = 0; i < 8; i++) {
            [colorMatrix1 addObject:[NSMutableArray arrayWithCapacity:8]];
            for (int j = 0; j < 8; j++) {
                [[colorMatrix1 objectAtIndex:i] addObject:[UIColor redColor]];
            }
        }
        L8Frame *frame1 = [[L8Frame alloc] init];
        [frame1 setColorMatrix:colorMatrix1];
        [frame1 setDuration:100];
        
        NSMutableArray *colorMatrix2 = [NSMutableArray arrayWithCapacity:8];
        for (int i = 0; i < 8; i++) {
            [colorMatrix2 addObject:[NSMutableArray arrayWithCapacity:8]];
            for (int j = 0; j < 8; j++) {
                [[colorMatrix2 objectAtIndex:i] addObject:[UIColor blueColor]];
            }
        }
        L8Frame *frame2 = [[L8Frame alloc] init];
        [frame2 setColorMatrix:colorMatrix2];
        [frame2 setDuration:100];
        
        NSMutableArray *colorMatrix3 = [NSMutableArray arrayWithCapacity:8];
        for (int i = 0; i < 8; i++) {
            [colorMatrix3 addObject:[NSMutableArray arrayWithCapacity:8]];
            for (int j = 0; j < 8; j++) {
                [[colorMatrix3 objectAtIndex:i] addObject:[UIColor yellowColor]];
            }
        }
        L8Frame *frame3 = [[L8Frame alloc] init];
        [frame3 setColorMatrix:colorMatrix3];
        [frame3 setDuration:200];
        
        L8Animation *animation = [[L8Animation alloc] init];
        animation.frames = [NSMutableArray arrayWithObjects:frame1, frame2, frame3, nil];
        [self.l8 setAnimation:animation withSuccess:v failure:f];
        
    };
    L8JSONOperationHandler failure = ^(NSMutableDictionary *response) {
        NSLog(@"Some error happened during l8 initialization: %@", response);
    };
    
    L8Manager *l8Manager = [[L8Manager alloc] init];
    [l8Manager discoverL8sWithSuccess:success failure:failure];
    */
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
