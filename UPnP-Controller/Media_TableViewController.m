//
//  Media_TableViewController.m
//  UPnP-Controller
//
//  Created by Sebastian Peischl on 27.04.14.
//  Copyright (c) 2014 easyMOBIZ. All rights reserved.
//

#import "Media_TableViewController.h"
#import "MediaServerBasicObjectParser.h"
#import "MediaServer1ItemObject.h"
#import "MediaServer1ContainerObject.h"
#import "AVTransport.h"
#import "Rendering.h"
#import "ContentDirectory.h"
#import "OtherFunctions.h"
#import "CocoaTools.h"

@interface Media_TableViewController ()

@end

@implementation Media_TableViewController
{
    NSArray *playlist;
    MediaServer1ContainerObject *container;
    int error;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // header
    self.title = self.header;
    
    // set server and renderer
    [[AVTransport getInstance] setRenderer:GLB.renderer andServer:GLB.server];

    // browse content
    playlist = [[ContentDirectory getInstance] browseContentWithDevice:GLB.server andRootID:self.rootID];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return playlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    MediaServer1ItemObject *item = [playlist objectAtIndex:indexPath.row];
        
    if (item.isContainer)
    {
        cell.textLabel.text = item.title;
    }
    else
    {
        cell.textLabel.text = item.title;
        
        if (item.albumArt != nil)
        {
            NSString *albumArt = [OtherFunctions getURLForAlbumArt:item.albumArt forRenderer:GLB.renderer];
        
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:albumArt]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView.image = image;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                });
            });
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MediaServer1BasicObject *item = [playlist objectAtIndex:indexPath.row];
    
    if (item.isContainer)
    {
        container = [playlist objectAtIndex:indexPath.row];
        
        GLB.currentServerContainerObject = container;
        
        [self performSegueWithIdentifier:@"newfolder" sender:self];
    }
    else
    {
        NSRange range = [[(MediaServer1ItemObject *)item uri] rangeOfString:@"x-sonosapi-stream:" options:NSCaseInsensitiveSearch];
        
        if(range.location == 0)
        {
            error = [[AVTransport getInstance] playRadio:(MediaServer1ItemObject *)item];
            NSLog(@"// play radio");
        }
        else
        {
            // only for sonos
            //error = [[AVTransport getInstance] playTrackSonos:(MediaServer1ItemObject *)item withQueue:GLB.currentQueueUri];
            error = [[AVTransport getInstance] play:item];
        }
        
        if (error == 0)
        {
            GLB.currentServerBasicObject = item;
            GLB.currentPlaylist = playlist;
            GLB.currentTrackNumber = (int)indexPath.row;
        }
        else if (error == -1)
        {
            NSLog(@"no playlist, renderer or server");
        }
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"newfolder"])
    {
        Media_TableViewController *controller = segue.destinationViewController;
        controller.rootID = container.objectID;
        controller.header = container.title;
    }
}

#pragma mark - Buttons

- (IBAction)btnPlayFolder:(id)sender
{
    //error = [[AVTransport getInstance] playPlaylist:GLB.currentServerContainerObject];
    error = [[AVTransport getInstance] playQueueSonos:GLB.currentServerContainerObject withQueue:GLB.currentQueueUri];
    
    if (error == -1)
    {
        NSLog(@"no renderer or server");
    }
    else if (error == 1)
    {
        NSLog(@"false uri");
    }
    else if (error == 2)
    {
        NSLog(@"no uri");
    }
    else if (error == 0)
    {
        if (playlist.count > 0)
            GLB.currentServerBasicObject = [playlist objectAtIndex:0];
        
        GLB.currentPlaylist = playlist;
        GLB.currentTrackNumber = 0;
    }
}

@end
