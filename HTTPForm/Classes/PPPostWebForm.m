//
//  PPPostWebForm.m
//  HTTPForm
//
//  Created by Qiliang Shen on 09-9-10.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PPPostWebForm.h"
#define SEPARATE_STRING @"---------------------------7193b3223d0130"

@implementation PPPostWebForm
@synthesize request = _request,responseData = _responseData,delegate;
- (id)initWithPostURL:(NSURL*)postURL{
	if(self=[super init]){
		self.request = [NSMutableURLRequest requestWithURL:postURL];
		_responseData = [[NSMutableData alloc] init];
		_data = [[NSMutableData alloc] init];
		[_data appendData:[[NSString stringWithFormat:@"--%@",SEPARATE_STRING] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	return self;
}
- (void)addFileElement:(NSString*)name value:(NSString*)filePath{
	NSData *d = [NSData dataWithContentsOfFile:filePath];
	if(d){
		NSString *tmp = [NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: image/x-png\r\n\r\n",name,filePath];
		[_data appendData:[tmp dataUsingEncoding:NSUTF8StringEncoding]];
		[_data appendData:d];
		[_data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
		[_data appendData:[[NSString stringWithFormat:@"--%@\r\n",SEPARATE_STRING] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
}
- (void)addTextElement:(NSString*)name value:(NSString*)value{
	NSString *tmp = [NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",name,value];
	[_data appendData:[tmp dataUsingEncoding:NSUTF8StringEncoding]];
	[_data appendData:[[NSString stringWithFormat:@"--%@",SEPARATE_STRING] dataUsingEncoding:NSUTF8StringEncoding]];
}
- (NSData*)commitFormSynchronous{
	[_data appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
	[_request setHTTPMethod:@"POST"];
	[_request setHTTPBody:_data];
	[_request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",SEPARATE_STRING] forHTTPHeaderField:@"Content-Type"];
	NSError *error;
	self.responseData = [NSURLConnection sendSynchronousRequest:_request returningResponse:nil error:&error];
	if(self.responseData==nil){
		NSLog(@"%@",error);
	}
	return self.responseData;
}
- (void)commitFormAsynchronous{
	[_data appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
	[_request setHTTPMethod:@"POST"];
	[_request setHTTPBody:_data];
	[_request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",SEPARATE_STRING] forHTTPHeaderField:@"Content-Type"];
	[NSURLConnection connectionWithRequest:_request delegate:self];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[_responseData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	[self.delegate postWebForm:self didReceivedAsynchronousData:_responseData];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	NSLog(@"%@",error);
	[self.delegate postWebForm:self didReceivedAsynchronousData:nil];
}
- (void)dealloc{
	[_responseData release];
	[_data release];
	[super dealloc];
}
@end
