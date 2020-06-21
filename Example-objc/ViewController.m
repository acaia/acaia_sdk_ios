//
//  ViewController.m
//  AcaiaSample
//
//  Created by Michael Wu on 2018/10/30.
//  Copyright © 2018 Acaia Corp. All rights reserved.
//

#import "ViewController.h"
#import <AcaiaSDK/AcaiaSDK.h>


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton* _scanScaleButton;
@property (weak, nonatomic) IBOutlet UIButton* _selectModeButton;

@property (strong, nonatomic) IBOutlet UIButton *btnTimer;
@property (strong, nonatomic) IBOutlet UIButton *btnDisconnect;
@property (strong, nonatomic) IBOutlet UIButton *btnPauseTimer;
@property (strong, nonatomic) IBOutlet UIButton *btnTare;
@property (strong, nonatomic) IBOutlet UILabel *scaleNameL;
@property (strong, nonatomic) IBOutlet UILabel *weightL;
@property (strong, nonatomic) IBOutlet UILabel *timerL;
@property BOOL isTimerStarted;
@property BOOL isTimerPaused;
@property (strong, nonatomic) IBOutlet UIView *toolView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self._selectModeButton.hidden = true;

    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onConnect:)
                                                 name:AcaiaScaleDidConnected
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDisconnect:)
                                                 name:AcaiaScaleDidDisconnected
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onWeight:)
                                                 name:AcaiaScaleWeight
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onTimer:)
                                                 name:AcaiaScaleTimer
                                               object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshUI];
}

- (void)onConnect:(NSNotification *)noti {
    [self refreshUI];
}

- (void)onFailed:(NSNotification *)noti {
    [self refreshUI];
}

- (void)onDisconnect:(NSNotification *)noti {
    [self refreshUI];
}

- (void)onWeight:(NSNotification *)noti {
    AcaiaScaleWeightUnit unit = [noti.userInfo[AcaiaScaleUserInfoKeyUnit] unsignedIntegerValue];
    float weight = [noti.userInfo[AcaiaScaleUserInfoKeyWeight] floatValue];
    
    if (unit == AcaiaScaleWeightUnitGram) {
        self.weightL.text = [NSString stringWithFormat:@"%.1f g", weight];
    } else {
        self.weightL.text = [NSString stringWithFormat:@"%.4f oz", weight];
    }
    
}

- (void)onTimer:(NSNotification *)noti {
    NSNumber *timer = [[noti userInfo] objectForKey:@"time"];
    NSInteger time = [timer integerValue];
    
    self.timerL.text = [NSString stringWithFormat:@"%02lu:%02lu", time/60, time%60];
    self.isTimerStarted = true;
}

- (void)refreshUI {
    if ([AcaiaManager sharedManager].connectedScale) {
        AcaiaScale *scale = [AcaiaManager sharedManager].connectedScale;
        self.scaleNameL.text = scale.name;
        self.toolView.hidden = false;
    } else {
        self.toolView.hidden = true;
        self.scaleNameL.text = @"-";
        self.timerL.text = @"-";
        self.weightL.text = @"-";
    }
}

- (IBAction)onBtnTimer {
    AcaiaScale *scale = [AcaiaManager sharedManager].connectedScale;
    if (scale == nil) { return; }
    
    if (self.isTimerStarted) {
        self.isTimerStarted = false;
        self.isTimerPaused = false;
        [scale stopTimer];
        self.btnPauseTimer.enabled = false;
        [self.btnTimer setTitle:@"Start Timer" forState:UIControlStateNormal];
        [self.btnPauseTimer setTitle:@"Pause Timer" forState:UIControlStateNormal];
        self.timerL.text = @"-";
    } else {
        self.btnPauseTimer.enabled = true;
        [scale startTimer];
        [self.btnTimer setTitle:@"Stop Timer" forState:UIControlStateNormal];
    }
}

- (IBAction)onBtnPauseTimer {
    AcaiaScale *scale = [AcaiaManager sharedManager].connectedScale;
    if (scale) {
        if (self.isTimerPaused) {
            self.isTimerPaused = false;
            [scale startTimer];
            [self.btnPauseTimer setTitle:@"Pause Timer" forState:UIControlStateNormal];
        } else {
            [scale pauseTimer];
            self.isTimerPaused = true;
            [self.btnPauseTimer setTitle:@"Resume Timer" forState:UIControlStateNormal];
        }
    }
}

- (IBAction)onBtnTare {
    AcaiaScale *scale = [AcaiaManager sharedManager].connectedScale;
    if (scale) {
        [scale tare];
    }
}

- (IBAction)onBtnDisconnect {
    AcaiaScale *scale = [AcaiaManager sharedManager].connectedScale;
    if (scale) {
        [scale disconnect];
    }
}

@end
