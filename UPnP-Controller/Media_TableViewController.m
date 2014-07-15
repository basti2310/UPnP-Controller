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


@interface Media_TableViewController ()

@end

@implementation Media_TableViewController
{
    MediaServer1BasicObject *selectedObject;
    
    NSArray *playlist;
    
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
        if ([self.upnpCon isKindOfClass:SonosUPNPController.class] && [(SonosUPNPController *)self.upnpCon isObjectRadio:selectedObject])
        {
            error = [(SonosUPNPController *)self.upnpCon playRadio:(MediaServer1ItemObject *)selectedObject];
            if (error == 1) NSLog(@"no renderer or server");
            else if (error == 2) NSLog(@"render can not play object with this uri");
            else if (error == 3) NSLog(@"no uri for item");
            else if (error == 4) NSLog(@"not meta data for radio");
        }
        else if (self.deviceType == UPNPRendererType_Generic)
        {
            error = [self.upnpCon play:selectedObject];
            if (error == 1) NSLog(@"no renderer or server");
            else if (error == 2) NSLog(@"render can not play object with this uri");
            else if (error == 3) NSLog(@"no uri for queue");
            else if (error == 4) NSLog(@"false protocol type for uri");
        }
        else if (self.deviceType == UPNPRendererType_Sonos)
        {
            error = [(SonosUPNPController *)self.upnpCon playItemWithQueue:selectedObject];
            if (error == 1) NSLog(@"no renderer or server");
            else if (error == 2) NSLog(@"render can not play object with this uri");
            else if (error == 3) NSLog(@"no uri for item");
            else if (error == 4) NSLog(@"no uri for queue");
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
    
/////////////////////
    
    if (self.upnpCon.currentBasicObject.isContainer && [self.upnpCon isKindOfClass:SonosUPNPController.class])
    {
        /*
        error = [self.upnpCon playFolderPlaylist:(MediaServer1ContainerObject *)self.upnpCon.currentBasicObject];
        if (error == 1) NSLog(@"no renderer or server");
        else if (error == 2) NSLog(@"render can not play object with this uri");
        else if (error == 3) NSLog(@"no uri for folder");
         */
        
//        error = [(SonosUPNPController *)self.upnpCon playPlaylistOrQueue:(MediaServer1ContainerObject *)self.upnpCon.currentBasicObject withQueueUri:self.queueUri];
//        if (error == 1) NSLog(@"no renderer or server");
//        else if (error == 2) NSLog(@"render can not play object with this uri");
//        else if (error == 3) NSLog(@"no uri for queue");
    }
}

@end
