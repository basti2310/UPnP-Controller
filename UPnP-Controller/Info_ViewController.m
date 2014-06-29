//
//  Info_ViewController.m
//  UPnP-Controller
//
//  Created by Sebastian Peischl on 31.05.14.
//  Copyright (c) 2014 easyMOBIZ. All rights reserved.
//

#import "Info_ViewController.h"

@interface Info_ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblTrackName;
@property (weak, nonatomic) IBOutlet UILabel *lblArtist;
@property (weak, nonatomic) IBOutlet UILabel *lblAlbum;
@property (weak, nonatomic) IBOutlet UILabel *lblGenre;
@property (weak, nonatomic) IBOutlet UILabel *lblLastPlaybackTime;
@property (weak, nonatomic) IBOutlet UILabel *lblLastPlaybackPos;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaybackCount;
@property (weak, nonatomic) IBOutlet UILabel *lblCreators;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthors;
@property (weak, nonatomic) IBOutlet UILabel *lblDirectors;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@property (weak, nonatomic) IBOutlet UIImageView *imgCover;

@end

@implementation Info_ViewController

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
    
    MediaServer1ItemObject *item = (MediaServer1ItemObject *)GLB.currentServerBasicObject;
    
    // set track infos
    self.lblTrackName.text = item.title;
    self.lblArtist.text = [NSString stringWithFormat:@"Artist: %@", item.artist];
    self.lblAlbum.text = [NSString stringWithFormat:@"Album: %@", item.album];
    self.lblGenre.text = [NSString stringWithFormat:@"Genre: %@", item.genre];
    self.lblLastPlaybackTime.text = [NSString stringWithFormat:@"lastPlaybackTime: %@", item.lastPlaybacktime];
    self.lblLastPlaybackPos.text = [NSString stringWithFormat:@"lastPlaybackPos: %@", item.lastPlaybackPosition];
    self.lblPlaybackCount.text = [NSString stringWithFormat:@"playbackCount: %@", item.playbackCount];
    self.lblCreators.text = [NSString stringWithFormat:@"Creators: %@", [item.creators componentsJoinedByString:@", "]];
    self.lblAuthors.text = [NSString stringWithFormat:@"Authors: %@", [item.authors componentsJoinedByString:@", "]];
    self.lblDirectors.text = [NSString stringWithFormat:@"Directors: %@", [item.directors componentsJoinedByString:@", "]];
    self.lblDescription.text = [NSString stringWithFormat:@"Description: %@", item.longDescription];

    // set cover
    self.imgCover.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.albumArt]]];
    
    NSLog(@"// authors: %@", item.authors);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
