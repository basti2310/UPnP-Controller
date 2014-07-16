//
//  Media_TableViewController.m
//  UPnP-Controller
//
//  Created by Sebastian Peischl on 27.04.14.
//  Copyright (c) 2014 easyMOBIZ. All rights reserved.
//

#import "Media_TableViewController.h"
#import "UPNPController.h"
#import "Init_ViewController.h"
#import "SonosUPNPController.h"


@interface Media_TableViewController ()

@end

@implementation Media_TableViewController
{
    MediaServer1BasicObject *selectedObject;
    
    NSArray *playlist;
    
    UPNP_Error error;
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
    
    playlist = [self.upnpCon browseContentForRootID:self.rootID];
    
    self.title = self.header;
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
//            NSString *albumArt = [OtherFunctions getURLForAlbumArt:item.albumArt forRenderer:GLB.renderer];
//        
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:albumArt]]];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    cell.imageView.image = image;
//                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                });
//            });
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedObject = [playlist objectAtIndex:indexPath.row];
    
    if (selectedObject.isContainer)
    {
        self.upnpCon.currentBasicObject = selectedObject;
        [self performSegueWithIdentifier:@"newfolder" sender:self];
    }
    else
    {
        if ([SonosUPNPController canPlayRadio:selectedObject] && (self.deviceType == UPNPRendererType_Sonos))
        {
            error = [(SonosUPNPController *)self.upnpCon playRadio:(MediaServer1ItemObject *)selectedObject];
            [SonosUPNPController upnpErrorLog:error];
        }
        else if (self.deviceType == UPNPRendererType_Generic)
        {
            error = [self.upnpCon play:selectedObject];
            [UPNPController upnpErrorLog:error];
        }
        else if (self.deviceType == UPNPRendererType_Sonos)
        {
            error = [(SonosUPNPController *)self.upnpCon playItemWithQueue:selectedObject];
            [SonosUPNPController upnpErrorLog:error];
        }
    
        self.upnpCon.currentBasicObject = selectedObject;
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"newfolder"])
    {
        Media_TableViewController *controllerMedia = segue.destinationViewController;
        controllerMedia.header = selectedObject.title;
        controllerMedia.rootID = selectedObject.objectID;
        controllerMedia.upnpCon = self.upnpCon;
        controllerMedia.deviceType = self.deviceType;
    }
}

#pragma mark - Buttons

- (IBAction)btnPlayFolder:(id)sender
{
    if (self.upnpCon.currentBasicObject.isContainer)
    {
        if (self.deviceType == UPNPRendererType_Generic)
        {
            error = [self.upnpCon playFolderPlaylist:(MediaServer1ContainerObject *)self.upnpCon.currentBasicObject];
            [UPNPController upnpErrorLog:error];
        }
        else if (self.deviceType == UPNPRendererType_Sonos)
        {
            error = [(SonosUPNPController *)self.upnpCon playPlaylistOrQueue:(MediaServer1ContainerObject *)self.upnpCon.currentBasicObject];
            [SonosUPNPController upnpErrorLog:error];
        }
    }
}

@end
