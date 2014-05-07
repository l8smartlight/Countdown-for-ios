//
//  ConfigViewController.m
//  CountDown
//
//  Created by Carlos on 21/04/14.
//  Copyright (c) 2014 l8smartlight. All rights reserved.
//

#import "ConfigViewController.h"

@interface ConfigViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *MinutesSelector;

@property (strong,nonatomic) NSArray* minutes;

@end

@implementation ConfigViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.MinutesSelector
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 60;
}

-(NSAttributedString*)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString* s = [NSString stringWithFormat:@"%d",row+1];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:s attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    return attString;
}

/*-(NSString* )pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString* s = [NSString stringWithFormat:@"%d",row+1];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:s attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    return (NSString*)attString;
}*/

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.time = row;
    NSLog(@"hola %d",row);
}


@end
