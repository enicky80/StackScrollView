//
//  DataViewController.m
//  StackScrollView
//
//  Created by Reefaq on 2/24/11.
//  Copyright 2011 raw engineering . All rights reserved.
//

#import "DataViewController.h"
#import "StackScrollViewAppDelegate.h"
#import "RootViewController.h"
#import "StackScrollViewController.h"
#import "RoundedUITableView.h"
#import "TweetTableViewCell.h"
#import "NSDate+Formatting.h"

@implementation DataViewController
@synthesize tableView = _tableView;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithFrame:(CGRect)frame squareCorners:(BOOL)squareCorners
{
    if (self = [super init])
	{
		tweets = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tweets" ofType:@"plist"]];
		
		//http://stackoverflow.com/questions/2002544/iphone-twitter-api-converting-time
		formatter = [[NSDateFormatter alloc] init];
		NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
		[formatter setLocale:usLocale]; 
		[usLocale release];
		[formatter setDateStyle:NSDateFormatterLongStyle];
		[formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		
		// see http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
		[formatter setDateFormat: @"EEE MMM dd HH:mm:ss +0000 yyyy"];
		
		[self.view setFrame:frame];

		_tableView = [[RoundedUITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
		_tableView.squareCorners = squareCorners;
		[_tableView setDelegate:self];
		[_tableView setDataSource:self];
		_tableView.backgroundColor = [UIColor whiteColor];
		_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
		[self.view addSubview:_tableView];
	}
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
		
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tweets count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [TweetTableViewCell heightForTweetWithText:[[tweets objectAtIndex:indexPath.row] objectForKey:@"text"]];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    TweetTableViewCell *cell = (TweetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
	if (cell == nil) {
        cell = [[[TweetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	NSDictionary *tweet = [tweets objectAtIndex:indexPath.row];
	
	NSDate *createdAt = [formatter dateFromString:[tweet objectForKey:@"created_at"]];
		    
	cell.imageView.image = [UIImage imageNamed:@"avatar.png"];
	cell.authorLabel.text = [[tweet objectForKey:@"user"] objectForKey:@"screen_name"];
	cell.tweetLabel.text = [tweet objectForKey:@"text"];
	cell.timestampLabel.text = [createdAt distanceOfTimeInWords];
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DataViewController *dataViewController = [[DataViewController alloc] initWithFrame:CGRectMake(0, 0, 477, self.view.frame.size.height) squareCorners:YES];
	[[StackScrollViewAppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:dataViewController invokeByController:self isStackStartView:FALSE];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}


- (void)dealloc {
	[formatter release];
	[tweets release];
    [super dealloc];
}


@end

