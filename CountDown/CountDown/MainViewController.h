//
//  MainViewController.h
//  CountDown
//
//  Created by Carlos on 21/04/14.
//  Copyright (c) 2014 l8smartlight. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TIBLECBKeyfob.h"


@interface MainViewController : UIViewController<TIBLECBKeyfobDelegate,UIAlertViewDelegate>

-(IBAction)unwind:(UIStoryboardSegue*)segue;

@property (nonatomic,strong) NSArray *l8Array;

@end
