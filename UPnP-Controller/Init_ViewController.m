//
//  Init_ViewController.m
//  UPnP-Controller
//
//  Created by Sebastian Peischl on 26.04.14.
//  Copyright (c) 2014 easyMOBIZ. All rights reserved.
//

#import "Init_ViewController.h"
#import "UPNPDiscovery.h"
//#import "UPNPController.h"
#import "SonosUPNPController.h"
#import "Server_TableViewController.h"
#import "Player_TableViewController.h"
#import "Media_TableViewController.h"
#import "BasicUPnPDevice.h"


@interface Init_ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblQuelle;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer;
@property (weak, nonatomic) IBOutlet UILabel *lblTrackName;

@property (weak, nonatomic) IBOutlet UIImageView *imgCover;

@property (weak, nonatomic) IBOutlet UIButton *btnPlayPause;

@property (weak, nonatomic) IBOutlet UISlider *sliderSeek;
@property (weak, nonatomic) IBOutlet UISlider *sliderVolume;

@end


@implementation Init_ViewController
{
    UPNPDiscovery *upnpDisc;
    SonosUPNPController *upnpCon;
    
    Server_TableViewController *controllerServer;
    Player_TableViewController *controllerPlayer;
    Media_TableViewController *controllerMedia;
    
    BOOL newServerOrRenderer;   // YES = new server or renderer selected
    BOOL pausePlayTag;          // YES = button name is Pause
    
    int error;
    
    NSTimer *seekTimer;
    
    NSString *queueUri;
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
    
    upnpDisc = [[UPNPDiscovery alloc] init];
    
    [upnpDisc startUPnPDeviceSearch];
    
    self.lblPlayer.text = @"";
    self.lblQuelle.text = @"";
    self.lblTrackName.text = @"";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (newServerOrRenderer)
    {
        newServerOrRenderer = NO;
        upnpCon = [[SonosUPNPController alloc] initWithRenderer:controllerPlayer.renderer andServer:controllerServer.server];
        
        self.lblQuelle.text = controllerServer.server.friendlyName;
        self.lblPlayer.text = controllerPlayer.renderer.friendlyName;

        // min & max values of the volume slider
        NSDictionary *volumeMinMax = [upnpCon getVolumeMinMax];
        if (volumeMinMax == nil) NSLog(@"no renderer");
        
        self.sliderVolume.minimumValue = [[volumeMinMax valueForKey:@"VolumeMin"] floatValue];
        self.sliderVolume.maximumValue = [[volumeMinMax valueForKey:@"VolumeMax"] floatValue];
    }
    
    NSDictionary *trackInf = [upnpCon getPositionAndTrackInfo];
    if (trackInf == nil) NSLog(@"no renderer");
    
    if (upnpCon.currentBasicObject == nil)
    {
        self.lblTrackName.text = [[trackInf objectForKey:@"MediaServer1ItemObject"] title];
    }
    else
    {
        if (!upnpCon.currentBasicObject.isContainer)
        {
            self.lblTrackName.text = upnpCon.currentBasicObject.title;
        }
    }
    
    // min & max values of the seek slider
    self.sliderSeek.minimumValue = 0;
    
    if (![[trackInf valueForKey:@"trackDuration"] isEqualToString:@"NOT_IMPLEMENTED"])
    {
        self.sliderSeek.maximumValue = (float)[upnpCon timeStringIntoInt:[trackInf valueForKey:@"trackDuration"]];
    }
    
    // get the current slider values
    if (![[trackInf valueForKey:@"relTime"] isEqualToString:@"NOT_IMPLEMENTED"])
    {
        self.sliderSeek.value = (float)[upnpCon timeStringIntoInt:[trackInf valueForKey:@"relTime"]];
    }
    
    self.sliderVolume.value = [[upnpCon getVolumeForChannel:@"Master"] floatValue];
    
    // update the seek slider
    if (self.sliderSeek.value > 5 || self.lblTrackName.text != nil)
    {
        seekTimer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(updateSeek) userInfo:nil repeats:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [seekTimer invalidate];
    seekTimer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons

- (IBAction)btnChooseServer:(id)sender
{
    newServerOrRenderer = YES;
    [self performSegueWithIdentifier:@"server" sender:self];
}

- (IBAction)btnChooseRenderer:(id)sender
{
    newServerOrRenderer = YES;
    [self performSegueWithIdentifier:@"renderer" sender:self];
}

- (IBAction)btnContentView:(id)sender
{
    NSArray *queueUris = [upnpCon getQueueOfMediaDirectoryOnServerWithRootID:@"0"];
    
    if (queueUris.count > 0)
    {
        queueUri = queueUris[0];
    }
    
    [self performSegueWithIdentifier:@"content" sender:self];
}

- (IBAction)btnRefresh:(id)sender
{
    [upnpDisc refreshUPnPDeviceSearch];
}

- (IBAction)btnPausePlay:(id)sender
{
    pausePlayTag = !pausePlayTag;
    
    if (pausePlayTag)   // pause
    {
        error = [upnpCon pause];
        if (error == 1) NSLog(@"no renderer");
        [self.btnPlayPause setTitle:@"Play" forState:UIControlStateNormal];
    }
    else    // play
    {
        error = [upnpCon replay];
        if (error == 1) NSLog(@"no renderer");
        [self.btnPlayPause setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

- (IBAction)btnStop:(id)sender
{
    error = [upnpCon stop];
    if (error == 0)
    {
        self.lblTrackName.text = @"";
        [seekTimer invalidate];
        seekTimer = nil;
    }
    else if (error == 1) NSLog(@"no renderer");
}

- (IBAction)btnNext:(id)sender
{
    error = [upnpCon next];
    if (error == 1) NSLog(@"no renderer");
}

- (IBAction)btnPrevious:(id)sender
{
    error = [upnpCon previous];
    if (error == 1) NSLog(@"no renderer");
}

#pragma mark - Slider

- (IBAction)sliderSeek:(UISlider *)sender
{
    NSString *timeStr = [upnpCon intIntoTimeString:(int)sender.value];
    
    error = [upnpCon seekWithMode:@"REL_TIME" andTarget:timeStr];
    if (error == 1) NSLog(@"no renderer");
}

- (IBAction)sliderVolume:(UISlider *)sender
{
    error = [upnpCon setVolume:[NSString stringWithFormat:@"%d", (int)sender.value] forChannel:@"Master"];
    if (error == 1) NSLog(@"no renderer");
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"server"])
    {
        controllerServer = segue.destinationViewController;
        controllerServer.servers = upnpDisc.upnpServers;
        
    }
    else if ([segue.identifier isEqualToString:@"renderer"])
    {
        controllerPlayer = segue.destinationViewController;
        controllerPlayer.renderers = upnpDisc.upnpRenderers;
        
    }
    else if ([segue.identifier isEqualToString:@"content"])
    {
        controllerMedia = segue.destinationViewController;
        controllerMedia.rootID = @"0";
        controllerMedia.header = @"root";
        controllerMedia.upnpCon = upnpCon;
        controllerMedia.queueUri = queueUri;
    }
}

#pragma mark - other functions

- (void)updateSeek
{
    NSDictionary *trackInf = [upnpCon getPositionAndTrackInfo];
    if (trackInf == nil) NSLog(@"no renderer");
    
    // get the current slider values
    self.sliderSeek.value = (float)[upnpCon timeStringIntoInt:[trackInf valueForKey:@"relTime"]];
}

@end
