//
//  RenderControl_ViewController.m
//  UPnP-Controller
//
//  Created by Sebastian Peischl on 27.04.14.
//  Copyright (c) 2014 easyMOBIZ. All rights reserved.
//

#import "RenderControl_ViewController.h"
#import "Rendering.h"
#import "AVTransport.h"
#import "OtherFunctions.h"
#import "UPnPManager.h"
#import "MediaServerBasicObjectParser.h"
#import "StateVariableRangeList.h"

@interface RenderControl_ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblTrackName;

@property (weak, nonatomic) IBOutlet UISlider *slidVolume;
@property (weak, nonatomic) IBOutlet UISlider *slidSeek;

@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnPause;
@property (weak, nonatomic) IBOutlet UIButton *btnStop;
@property (weak, nonatomic) IBOutlet UIButton *btnPrevious;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@end

@implementation RenderControl_ViewController
{
    int error;
    BOOL isNext;
}

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
    // Do any additional setup after loading the view.
    
    // set server and renderer
    [[Rendering getInstance] setRenderer:GLB.renderer];
    [[AVTransport getInstance] setRenderer:GLB.renderer andServer:GLB.server];
    
    // get available actions
    NSArray *renderActions = @[@"SetVolume", @"GetVolume"];
    NSArray *avtransportActions = @[@"Play", @"Pause", @"Stop", @"Previous", @"Next", @"GetPositionInfo", @"Seek"];
    
    NSArray *availableRenderActions = [OtherFunctions availableActionsForDevice:GLB.renderer forUrn:URN_SERVICE_RENDERING_CONTROL_1 withNeededActions:renderActions];
    NSArray *availableAVTransportActions = [OtherFunctions availableActionsForDevice:GLB.renderer forUrn:URN_SERVICE_AVTRANSPORT_1 withNeededActions:avtransportActions];
    
    // check if buttons, etc. are available
    self.btnPlay.enabled = [OtherFunctions actionList:availableAVTransportActions containsAction:@"Play"];
    self.btnPause.enabled = [OtherFunctions actionList:availableAVTransportActions containsAction:@"Pause"];
    self.btnStop.enabled = [OtherFunctions actionList:availableAVTransportActions containsAction:@"Stop"];
    self.btnPrevious.enabled = [OtherFunctions actionList:availableAVTransportActions containsAction:@"Previous"];
    self.btnNext.enabled = [OtherFunctions actionList:availableAVTransportActions containsAction:@"Next"];
    self.slidVolume.enabled = [OtherFunctions actionList:availableRenderActions containsAction:@"SetVolume"];
    self.slidSeek.enabled = [OtherFunctions actionList:availableAVTransportActions containsAction:@"Seek"];
    
    // set volume
    if ([OtherFunctions actionList:availableRenderActions containsAction:@"GetVolume"])
        self.slidVolume.value = [[[Rendering getInstance] getVolume] floatValue];

    // set volume slider min max
    self.slidVolume.minimumValue = [[[StateVariableRangeList getVolumeMinMax] objectForKey:@"VolumeMin"] floatValue];
    self.slidVolume.maximumValue = [[[StateVariableRangeList getVolumeMinMax] objectForKey:@"VolumeMax"] floatValue];
    
    // set track name
    [self updateTrackName];
    
    // set seek slider max value
    self.slidSeek.maximumValue = [OtherFunctions timeStringIntoFloat:[[[AVTransport getInstance] getPositionAndTrackInfo] objectForKey:@"trackDuration"]];
    
    // get track time
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getTrackTimePosition) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Seek

- (void)getTrackTimePosition
{
    self.slidSeek.value = [OtherFunctions timeStringIntoFloat:[[[AVTransport getInstance] getPositionAndTrackInfo] objectForKey:@"relTime"]];
    
    if ((self.slidSeek.value >= self.slidSeek.maximumValue - 1) && !isNext)
    {
        // play next track
        isNext = YES;
        [self performSelector:@selector(btnNext:) withObject:nil afterDelay:1.5];
    }
}

#pragma mark - Buttons

- (IBAction)btnPlay:(id)sender
{
    error = [[AVTransport getInstance] replay];
    if (error == -1) NSLog(@"no renderer");
}

- (IBAction)btnPause:(id)sender
{
    [[AVTransport getInstance] pause];
    if (error == -1) NSLog(@"no renderer");
}

- (IBAction)btnStop:(id)sender
{
    error = [[AVTransport getInstance] stop];
    if (error == -1) NSLog(@"no renderer");
    
    self.lblTrackName.text = @"";
    GLB.currentServerBasicObject = nil;
}

- (IBAction)btnPrevious:(id)sender
{
//    GLB.currentTrackNumber--;
//    
//    if (GLB.currentTrackNumber < 0)
//        GLB.currentTrackNumber = GLB.currentPlaylist.count - 1;
//    
//    GLB.currentServerBasicObject = [GLB.currentPlaylist objectAtIndex:GLB.currentTrackNumber];
//    
//    [self playNextPrevious];
    
    error = [[AVTransport getInstance] previous];
    if (error == -1) NSLog(@"no renderer");
    
    NSLog(@"// PREVIOUS");
}

- (IBAction)btnNext:(id)sender
{
//    GLB.currentTrackNumber++;
//    
//    if (GLB.currentTrackNumber >= GLB.currentPlaylist.count - 1)
//        GLB.currentTrackNumber = 0;
//    
//    GLB.currentServerBasicObject = [GLB.currentPlaylist objectAtIndex:GLB.currentTrackNumber];
//    
//    [self playNextPrevious];
    
    error = [[AVTransport getInstance] next];
    if (error == -1) NSLog(@"no renderer");
    
    NSLog(@"// NEXT");
}

#pragma mark - Slider

- (IBAction)slidVolume:(UISlider *)sender
{
//    [[Rendering getInstance] setVolume:[otherFunctions floatIntoString:sender.value]];
    [[Rendering getInstance] setVolume:[NSString stringWithFormat:@"%d", (int)sender.value]];
}

- (IBAction)slidSeek:(UISlider *)sender
{
    [[AVTransport getInstance] seekWithMode:@"REL_TIME" andTarget:[OtherFunctions floatIntoTimeString:sender.value]];
}

#pragma mark - other functions

- (void)updateTrackName
{
    if (GLB.currentServerBasicObject != nil)
    {
        // set track title
        self.lblTrackName.text = GLB.currentServerBasicObject.title;
    }
    else
    {
        // set track title, if there is no current MediaServer1BasicObject available
        MediaServer1ItemObject *item = [[[AVTransport getInstance] getPositionAndTrackInfo] objectForKey:@"MediaServer1ItemObject"];
        self.lblTrackName.text = item.title;
    }
}

- (void)playNextPrevious
{
    error = [[AVTransport getInstance] play:GLB.currentServerBasicObject];
    if (error == -1) NSLog(@"no renderer");
    
    // set track name
    [self updateTrackName];
    
    [self performSelector:@selector(getTrackDuration) withObject:nil afterDelay:1.5];
}

- (void)getTrackDuration
{
    // set seek slider max value
    self.slidSeek.maximumValue = [OtherFunctions timeStringIntoFloat:[[[AVTransport getInstance] getPositionAndTrackInfo] objectForKey:@"trackDuration"]];
    isNext = NO;
}

@end
