//
//  RenderControl_ViewController.m
//  UPnP-Controller
//
//  Created by Sebastian Peischl on 27.04.14.
//  Copyright (c) 2014 easyMOBIZ. All rights reserved.
//

#import "RenderControl_ViewController.h"


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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons

- (IBAction)btnPlay:(id)sender
{
    
}

- (IBAction)btnPause:(id)sender
{
    
}

- (IBAction)btnStop:(id)sender
{
    
}

- (IBAction)btnPrevious:(id)sender
{
    
}

- (IBAction)btnNext:(id)sender
{
    
}

#pragma mark - Slider

- (IBAction)slidVolume:(UISlider *)sender
{

}

- (IBAction)slidSeek:(UISlider *)sender
{
    
}

@end
