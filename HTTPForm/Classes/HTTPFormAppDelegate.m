//
//  HTTPFormAppDelegate.m
//  HTTPForm
//
//  Created by Qiliang Shen on 09-9-10.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "HTTPFormAppDelegate.h"
#import "PPPostWebForm.h"
@implementation HTTPFormAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	PPPostWebForm *a = [[PPPostWebForm alloc] initWithPostURL:[NSURL URLWithString:@"http://www.getbabywise.com/upload/uploadFile"]];
	[a addFileElement:@"upload[datafile]" value:@"/Users/qiliangshen/Desktop/save.jpg"];
	[a addTextElement:@"userid" value:@"1"];
	[a addTextElement:@"commit" value:@"uploadFile"];
	a.delegate = self;
	[a commitFormAsynchronous];
//	NSData *d = [a commitFormSynchronous];
//	NSString *s = [NSString stringWithUTF8String:[d bytes]];
//	NSLog(s);
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}

- (void)postWebForm:(PPPostWebForm*)form didReceivedAsynchronousData:(NSData*)data{
	NSString *s = [NSString stringWithUTF8String:[data bytes]];
	NSLog(s);

}

- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
