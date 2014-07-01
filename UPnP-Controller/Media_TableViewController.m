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
#import "otherFunctions.h"

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
    [[AVTransport getInstance] setRenderer:GLB.renderer];

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
        cell.detailTextLabel.numberOfLines = 2;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Authors: %@", [item.authors componentsJoinedByString:@", "]];
        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.albumArt]]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MediaServer1BasicObject *item = [playlist objectAtIndex:indexPath.row];
    
    if (item.isContainer)
    {
        container = [playlist objectAtIndex:indexPath.row];
        
        [self performSegueWithIdentifier:@"newfolder" sender:self];
    }
    else
    {
        error = [[AVTransport getInstance] play:playlist position:(int)indexPath.row];
        
        GLB.currentServerBasicObject = item;
        GLB.currentPlaylist = playlist;
        GLB.currentTrackNumber = (int)indexPath.row;
        
        if (error == -1) NSLog(@"no playlist or renderer");
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


@end
