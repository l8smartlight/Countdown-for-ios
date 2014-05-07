//
//  MainViewController.m
//  CountDown
//
//  Created by Carlos on 21/04/14.
//  Copyright (c) 2014 l8smartlight. All rights reserved.
//

#import "MainViewController.h"
#import "ConfigViewController.h"
#import "l8_sdk_objc.h"
#import "ColorUtils.h"
#import "TIBLECBKeyfob.h"
#import "BluetoothL8.h"

NSString* const logol8ty = @"#000000-#000000-#000000-#000000-#000000-#000000-#000000-#000000-#000000-#0016ff-#000000-#000000-#000000-#000000-#000000-#000000-#000000-#009bdb-#ffef00-#ffef00-#ffef00-#ff6700-#ff6700-#000000-#000000-#00c9db-#ffef00-#000000-#ffef00-#000000-#ff6700-#000000-#000000-#00d3db-#ffef00-#ffef00-#ffef00-#ff6700-#ff6700-#000000-#000000-#00dbb1-#00dbb1-#00dbb1-#000000-#000000-#000000-#000000-#000000-#000000-#000000-#000000-#000000-#000000-#000000-#000000-#000000-#000000-#000000-#000000-#000000-#000000-#000000-#000000-#0000ff";

NSString* const numberColor = @"#ff0000";

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UILabel *counterLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property BOOL play;
@property BOOL reset;
@property int time;
@property NSThread* hilo;
@property (nonatomic,strong) TIBLECBKeyfob *t;
@property NSString* colorBar;

@end

@implementation MainViewController

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
    self.t = [[TIBLECBKeyfob alloc] init];   // Init TIBLECBKeyfob class.
    [self.t controlSetup:1];                 // Do initial setup of TIBLECBKeyfob class.
    self.t.delegate = self;

    [super viewDidLoad];
    self.play = NO;
    self.reset = NO;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
         self.counterLabel.font = [UIFont fontWithName:@"Let's go Digital" size:200];
    }else{
         self.counterLabel.font = [UIFont fontWithName:@"Let's go Digital" size:100];
    }
    self.time = 10;
    self.colorBar = @"#0000ff";
  /*  UIAlertView *newAlertView = [[UIAlertView alloc] initWithTitle:@"CONNECTION" message:@"Select the connection type" delegate:self cancelButtonTitle:@"SIMULATOR" otherButtonTitles:@"WITH L8", nil];
    [newAlertView setTag:2];
    
    [newAlertView show];*/
    [self initConnection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)unwind:(UIStoryboardSegue*)segue{
    ConfigViewController* c = [segue sourceViewController];
    NSString* timeText = [NSString stringWithFormat:@"%d:00",c.time+1];
    self.time = c.time+1;
    self.counterLabel.text = timeText;
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
- (IBAction)play:(id)sender {
    
    if(self.play == NO){
        self.play = YES;
        UIImage* image = [UIImage imageNamed:@"stop"];
        [self.playButton setImage:image forState:UIControlStateNormal];
        self.hilo = [[NSThread alloc] initWithTarget:self selector:@selector(threadRun) object:nil];
        [self.hilo start];
    }else{
        self.play = NO;
        UIImage* image = [UIImage imageNamed:@"play"];
        [self.playButton setImage:image forState:UIControlStateNormal];
        if(self.hilo){
            [self.hilo cancel];
        }
    }
}


-(void)threadRun{
    if (!self.t.activePeripheral || !self.t.activePeripheral.isConnected)
    {
        [self connectToL8];
        [NSThread sleepForTimeInterval:5];
    }
    self.reset = NO;
    int minutesCounter = self.time-1;
    int secondsCounter = 60;
    bool active = true;
    if(!self.t.activePeripheral || !self.t.activePeripheral.isConnected){
        dispatch_sync(dispatch_get_main_queue(),^{self.counterLabel.text = [NSString stringWithFormat:@"%d:00",self.time];});
        dispatch_sync(dispatch_get_main_queue(),^{
            
            self.play = NO;
            UIImage* image = [UIImage imageNamed:@"play"];
            [self.playButton setImage:image forState:UIControlStateNormal]; });
        return;
    }
    self.colorBar = [self getColorByTime:minutesCounter+1];
    NSMutableString*  matrix = [self generateMatrixBar:minutesCounter+1];
    [self setMatrix:matrix];
    while(active && self.play){
        [NSThread sleepForTimeInterval:1];
        self.colorBar = [self getColorByTime:minutesCounter+1];
        [self setMatrix:matrix];
        if(secondsCounter>0){
            secondsCounter--;
        }else if(minutesCounter>0){
            minutesCounter--;
            secondsCounter = 59;
            matrix = [self generateMatrixBar:minutesCounter+1];
            [self setMatrix:matrix];
        }else{
            active = false;
            minutesCounter = 0;
            secondsCounter = 0;
            matrix = [self generateMatrixBar:0];
            [self setMatrix:matrix];
            [NSThread sleepForTimeInterval:1];
        }
        
        if(!self.reset){
        NSString* seconds = secondsCounter>9?[NSString stringWithFormat:@"%d",secondsCounter]:[NSString stringWithFormat:@"0%d",secondsCounter];
        
        NSString* timeText = minutesCounter>9?[NSString stringWithFormat:@"%d:%@",minutesCounter,seconds]:[NSString stringWithFormat:@"0%d:%@",minutesCounter,seconds];
        dispatch_sync(dispatch_get_main_queue(),^{self.counterLabel.text = timeText;});
        NSLog(@"Time: %@",timeText);
        }
        if(self.reset){
            minutesCounter = self.time-1;
            secondsCounter = 60;
            self.reset = NO;
            dispatch_sync(dispatch_get_main_queue(),^{self.counterLabel.text = [NSString stringWithFormat:@"%d:00",self.time];});
            self.colorBar = [self getColorByTime:minutesCounter+1];
            NSMutableString*  matrix = [self generateMatrixBar:minutesCounter+1];
            [self setMatrix:matrix];
        }
    }
    
    if(active){
        dispatch_sync(dispatch_get_main_queue(),^{self.counterLabel.text = [NSString stringWithFormat:@"%d:00",self.time];});
    }
    dispatch_sync(dispatch_get_main_queue(),^{
        self.play = NO;
        UIImage* image = [UIImage imageNamed:@"play"];
        [self.playButton setImage:image forState:UIControlStateNormal]; });
    
    [self setLogo:nil];
}

- (IBAction)reset:(id)sender {
    if(self.play){
        self.reset = YES;
    }
}

- (IBAction)setLogo:(id)sender {
    NSArray *subStrings = [logol8ty componentsSeparatedByString:@"-#"];
    BluetoothL8* l8 = self.l8Array.lastObject;
    [l8  setMatrix:subStrings withSuccess:^{NSLog(@"send Ok");} failure:^(NSMutableDictionary *result) {
        NSLog(@"setLED ERROR");
    }];
    
     L8VoidOperationHandler v = ^() {
     NSLog(@"success yellow superled");
     };
     
     L8JSONOperationHandler f = ^(NSMutableDictionary *r) {
     NSLog(@"failure: %@", r);
     };
    
    [l8 clearSuperLEDWithSuccess:v failure:f];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        NSLog(@"pressed cancel");
    }else{
        NSLog(@"pressed ok");

    }
}

-(void)connectToL8{
    NSLog(@"Connecting with l8...");
    if (self.t.activePeripheral)
        if(self.t.activePeripheral.isConnected)
            [[self.t CM] cancelPeripheralConnection:[self.t activePeripheral]];
    if (self.t.peripherals)
        self.t.peripherals = nil;
    [self.t findBLEPeripherals:10];
    //[NSTimer scheduledTimerWithTimeInterval:(float)50.0 /* //JPS poner mas tiempo?*/ target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    BluetoothL8 *l8Bluetooth=[[BluetoothL8 alloc]init];
    l8Bluetooth.t=self.t;
    self.l8Array=[[NSMutableArray alloc] initWithObjects:l8Bluetooth, nil];
}

-(void)configUpdated:(NSData *)config{
    
}


-(void)TXPwrLevelUpdated:(char)TXPwr{
    
}

-(void)notificationRcvd:(Byte)not1{
    
}

-(void)keyValuesUpdated:(char)sw{
    
}

-(void)accelerometerValuesUpdated:(char)x y:(char)y z:(char)z{
    
}

-(void)batteryLevelRcvd:(Byte)batLvl{
    
}

-(void)processDataFromPeripheral:(NSData *)data{
    NSLog(@"data l8: %@",data);
}

-(void) keyfobReady{
    NSLog(@"bt ready");
    id<L8> l8=[self.l8Array lastObject];
    //TODO: Clear not found in this method
    [l8 clearMatrixWithSuccess:^{NSLog(@"matrix cleared");} failure:^(NSMutableDictionary *result) {
        NSLog(@"Error matrix cleared");
    }];
    for(int i=0;i<[[self.t userPeripherals] count];i++){
        
        
        if([[[[self.t userPeripherals] objectAtIndex:i] valueForKey:@"isUserChecked"] isEqualToString:@"YES"]){
            CBPeripheral * activePeripheralUser = [[[self.t userPeripherals] objectAtIndex:i] valueForKey:@"peripheral"];
            [self.t L8SL_PrepareForReceiveDataFromL8SL:activePeripheralUser];
            
            usleep(800);
        }
        
    }
    
    NSString *prubeString = @"#5cff5c-#60f83f-#5cff5c-#5cff5c-#5cff5c-#5cff5c-#5cff5c-#5cff5c-#00ff00-#60f83f-#60f83f-#60f83f-#00ff00-#00ff00-#ffffff-#ffffff-#60f83f-#60f83f-#60f83f-#00ff00-#ffffff-#ffffff-#ffffff-#ffffff-#34b918-#34b918-#34b918-#34b918-#ffffff-#ffffff-#34b918-#34b918-#ffffff-#ffffff-#34b918-#ffffff-#ffffff-#ffffff-#34b918-#34b918-#34b918-#ffffff-#ffffff-#ffffff-#ffffff-#34b918-#34b918-#03a603-#03a603-#03a603-#ffffff-#ffffff-#03a603-#03a603-#03a603-#03a603-#017001-#017001-#017001-#ffffff-#017001-#017001-#017001-#017001-#3dfa3d";
    NSArray *subStrings = [prubeString componentsSeparatedByString:@"-#"];
    
    [l8  setMatrix:subStrings withSuccess:^{NSLog(@"send Ok");} failure:^(NSMutableDictionary *result) {
        NSLog(@"setLED ERROR");
    }];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [l8 clearMatrixWithSuccess:^{
            
        } failure:^(NSMutableDictionary *result) {
            
        }];
        
        [l8 clearSuperLEDWithSuccess:^(NSArray *result) {
            
        } failure:^(NSMutableDictionary *result) {
            
        }];
    });
    self.t.delegate=self;
}

-(void)initConnection{
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self connectToL8];
    });

}


-(NSMutableString*)generateMatrixBar:(int)minutes{
    int count = 0;
    NSMutableString* matrixString = [NSMutableString stringWithString:@""];
    NSMutableArray *colorMatrix = [NSMutableArray arrayWithCapacity:8];
    for (int i = 0; i < 8; i++) {
        [colorMatrix addObject:[NSMutableArray arrayWithCapacity:8]];
        for (int j = 0; j < 8; j++) {
            [[colorMatrix objectAtIndex:i] addObject:[UIColor blackColor]];
        }
    }
    for(NSMutableArray* row in colorMatrix){
        for(int i=0;i<row.count;i++){
            if(count< minutes){
                row[i] = self.colorBar;
                count++;
            }else{
                row[i] = @"000000";
            }
            
        }
    }
    if (minutes < 10) {
        [self drawNumber:colorMatrix withStart:2 number:minutes];
    } else {
        [self drawNumber:colorMatrix withStart:0 number:minutes/10];
        [self drawNumber:colorMatrix withStart:4 number:minutes-((minutes/10)*10)];
        
    }
    for(int i=0;i<colorMatrix.count;i++){
        NSMutableArray* row = colorMatrix[i];
        for(int j = 0 ;j<row.count;j++){
            NSString*  temp = nil;
            if(j==0 && i==0){
                temp = row[j];
            }else{
                temp = [NSString stringWithFormat:@"-%@",row[j]];
            }
                [matrixString appendString:temp];
        }
    }
    
       NSLog(@"%@",matrixString);
    return matrixString;
}

-(NSString*)getColorByTime:(int)minutes{
    NSString* result = @"000000";
    NSArray* colors = @[@"#ff0000",@"#ff8c00",@"#ffff00",@"#00ff00",@"#0000ff"];
    float part = ((float)self.time / (float)5);
    for(int i = 0;i<5;i++){
        if(minutes >=(part*i) && minutes<= ((part * i)+part)){
            return colors[i];
        }
    }
    return result;
}

-(void)setMatrix:(NSString*)matrix{
    BluetoothL8* l8 = self.l8Array.lastObject;
    NSArray *subStrings = [matrix componentsSeparatedByString:@"-#"];
    [l8  setMatrix:subStrings withSuccess:^{NSLog(@"send Ok");} failure:^(NSMutableDictionary *result) {
        NSLog(@"setLED ERROR");
    }];

}

-(void)drawNumber:(NSMutableArray*)matrix withStart:(int)startY number:(int)number{
    switch (number) {
        case 0: {
            [self zero:matrix y:startY];
            break;
        }
        case 1: {
            [self one:matrix y:startY];
            break;
        }
        case 2: {
            [self two:matrix y:startY];
            break;
        }
        case 3: {
            [self three:matrix y:startY];
            break;
        }
        case 4: {
            [self four:matrix y:startY];
            break;
        }
        case 5: {
            [self five:matrix y:startY];
            break;
        }
        case 6: {
            [self six:matrix y:startY];
            break;
        }
        case 7: {
            [self seven:matrix y:startY];
            break;
        }
        case 8: {
            [self eight:matrix y:startY];
            break;
        }
        case 9: {
            [self nine:matrix y:startY];
            break;
        }
    }
}

-(void)zero:(NSMutableArray*)matrix y:(int)startY{
    matrix[3][startY + 0] = numberColor;
    matrix[3][startY + 1] = numberColor;
    matrix[3][startY + 2] = numberColor;
    matrix[4][startY + 0] = numberColor;
    matrix[4][startY + 2] = numberColor;
    matrix[5][startY + 0] = numberColor;
    matrix[5][startY + 2] = numberColor;
    matrix[6][startY + 0] = numberColor;
    matrix[6][startY + 2] = numberColor;
    matrix[7][startY + 0] = numberColor;
    matrix[7][startY + 1] = numberColor;
    matrix[7][startY + 2] = numberColor;
}

-(void)one:(NSMutableArray*)matrix y:(int)startY{
    matrix[3][startY + 2] = numberColor;
    matrix[4][startY + 2] = numberColor;
    matrix[5][startY + 2] = numberColor;
    matrix[6][startY + 2] = numberColor;
    matrix[7][startY + 2] = numberColor;
}

-(void)two:(NSMutableArray*)matrix y:(int)startY{
    matrix[3][startY + 0] = numberColor;
    matrix[3][startY + 1] = numberColor;
    matrix[3][startY + 2] = numberColor;
    matrix[4][startY + 2] = numberColor;
    matrix[5][startY + 0] = numberColor;
    matrix[5][startY + 1] = numberColor;
    matrix[5][startY + 2] = numberColor;
    matrix[6][startY + 0] = numberColor;
    matrix[7][startY + 0] = numberColor;
    matrix[7][startY + 1] = numberColor;
    matrix[7][startY + 2] = numberColor;
}

-(void)three:(NSMutableArray*)matrix y:(int)startY{
    matrix[3][startY + 0] = numberColor;
    matrix[3][startY + 1] = numberColor;
    matrix[3][startY + 2] = numberColor;
    matrix[4][startY + 2] = numberColor;
    matrix[5][startY + 0] = numberColor;
    matrix[5][startY + 1] = numberColor;
    matrix[5][startY + 2] = numberColor;
    matrix[6][startY + 2] = numberColor;
    matrix[7][startY + 0] = numberColor;
    matrix[7][startY + 1] = numberColor;
    matrix[7][startY + 2] = numberColor;
}

-(void)four:(NSMutableArray*)matrix y:(int)startY{
    matrix[3][startY + 0] = numberColor;
    matrix[3][startY + 2] = numberColor;
    matrix[4][startY + 0] = numberColor;
    matrix[4][startY + 2] = numberColor;
    matrix[5][startY + 0] = numberColor;
    matrix[5][startY + 1] = numberColor;
    matrix[5][startY + 2] = numberColor;
    matrix[6][startY + 2] = numberColor;
    matrix[7][startY + 2] = numberColor;
}

-(void)five:(NSMutableArray*)matrix y:(int)startY{
    matrix[3][startY + 0] = numberColor;
    matrix[3][startY + 1] = numberColor;
    matrix[3][startY + 2] = numberColor;
    matrix[4][startY + 0] = numberColor;
    matrix[5][startY + 0] = numberColor;
    matrix[5][startY + 1] = numberColor;
    matrix[5][startY + 2] = numberColor;
    matrix[6][startY + 2] = numberColor;
    matrix[7][startY + 0] = numberColor;
    matrix[7][startY + 1] = numberColor;
    matrix[7][startY + 2] = numberColor;
}

-(void)six:(NSMutableArray*)matrix y:(int)startY{
    matrix[3][startY + 0] = numberColor;
    matrix[3][startY + 1] = numberColor;
    matrix[3][startY + 2] = numberColor;
    matrix[4][startY + 0] = numberColor;
    matrix[5][startY + 0] = numberColor;
    matrix[5][startY + 1] = numberColor;
    matrix[5][startY + 2] = numberColor;
    matrix[6][startY + 0] = numberColor;
    matrix[6][startY + 2] = numberColor;
    matrix[7][startY + 0] = numberColor;
    matrix[7][startY + 1] = numberColor;
    matrix[7][startY + 2] = numberColor;
}

-(void)seven:(NSMutableArray*)matrix y:(int)startY{
    matrix[3][startY + 0] = numberColor;
    matrix[3][startY + 1] = numberColor;
    matrix[3][startY + 2] = numberColor;
    matrix[4][startY + 2] = numberColor;
    matrix[5][startY + 2] = numberColor;
    matrix[6][startY + 2] = numberColor;
    matrix[7][startY + 2] = numberColor;
}

-(void)eight:(NSMutableArray*)matrix y:(int)startY{
    matrix[3][startY + 0] = numberColor;
    matrix[3][startY + 1] = numberColor;
    matrix[3][startY + 2] = numberColor;
    matrix[4][startY + 0] = numberColor;
    matrix[4][startY + 2] = numberColor;
    matrix[5][startY + 0] = numberColor;
    matrix[5][startY + 1] = numberColor;
    matrix[5][startY + 2] = numberColor;
    matrix[6][startY + 0] = numberColor;
    matrix[6][startY + 2] = numberColor;
    matrix[7][startY + 0] = numberColor;
    matrix[7][startY + 1] = numberColor;
    matrix[7][startY + 2] = numberColor;
}

-(void)nine:(NSMutableArray*)matrix y:(int)startY{
    matrix[3][startY + 0] = numberColor;
    matrix[3][startY + 1] = numberColor;
    matrix[3][startY + 2] = numberColor;
    matrix[4][startY + 0] = numberColor;
    matrix[4][startY + 2] = numberColor;
    matrix[5][startY + 0] = numberColor;
    matrix[5][startY + 1] = numberColor;
    matrix[5][startY + 2] = numberColor;
    matrix[6][startY + 2] = numberColor;
    matrix[7][startY + 2] = numberColor;
}


@end
