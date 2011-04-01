//
//  Live.m
//  mySmartGrid
//
//  Created by Benedikt Marquard on 16.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Live.h"


@implementation Live

@synthesize receivedData, theConnection, my_timer, theHost, theToken;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)reload_data_method{
    
    NSLog(@"Request");
    
    NSString *theURL = [NSString stringWithFormat:@"http://%@/sensor/%@",theHost ,theToken ];
    
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:theURL]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:60.0];
	// create the connection with the request
	// and start loading the data
	theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if (theConnection) {
		// Create the NSMutableData to hold the received data.
		// receivedData is an instance variable declared elsewhere.
		receivedData = [[NSMutableData data] retain];
	} 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    theHost = @"localhost:8877";
    theToken = @"d1f8040e75a57e1509e6034558c3dea8";
    
    lblVerbrauch.text = @"0 Watt";
       
    [self startMyTimer:1];
 
}

- (void)startMyTimer:(NSInteger) time
{
    
    my_timer = [NSTimer scheduledTimerWithTimeInterval:time 
                                                target:self 
                                              selector:@selector(reload_data_method) 
                                              userInfo:nil
                                               repeats:NO];   
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	// This method is called when the server has determined that it
	// has enough information to create the NSURLResponse.
	
	// It can be called multiple times, for example in the case of a
	// redirect, so each time we reset the data.
	
	// receivedData is an instance variable declared elsewhere.
	[receivedData setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	// Append the new data to receivedData.
	// receivedData is an instance variable declared elsewhere.
	[receivedData appendData:data];
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// release the connection, and the data object
	[connection release];
	// receivedData is declared as a method instance elsewhere
	[receivedData release];
	
	// inform the user
	NSLog(@"Connection failed! Error - %@ %@",
		  [error localizedDescription],
		  [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    [self startMyTimer:5];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	
	NSString *content = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	NSArray *results = [content JSONValue];
    
    NSArray *lastValue = [results objectAtIndex:[results count]-1];
	
    lblVerbrauch.text = [[NSString alloc] initWithFormat:@"%@ Watt", [lastValue objectAtIndex:1]];

	[content release];
	[connection release];
	[receivedData release];
    [self startMyTimer:1];
    
}



@end
