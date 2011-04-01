//
//  Live.h
//  mySmartGrid
//
//  Created by Benedikt Marquard on 16.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"

@interface Live : UIViewController {
    IBOutlet UILabel *lblVerbrauch;
    NSTimer *my_timer;
	NSMutableData *receivedData;
	NSURLConnection *theConnection;   
    NSString *theHost;
    NSString *theToken;
    
}

- (void)startMyTimer:(NSInteger) time;


@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSURLConnection *theConnection;
@property (nonatomic, retain) NSTimer *my_timer;
@property (nonatomic, retain) NSString *theHost;
@property (nonatomic, retain) NSString *theToken;



@end
