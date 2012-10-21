//
//  PPPostWebForm.h
//  HTTPForm
//
//  Created by Qiliang Shen on 09-9-10.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PPPostWebForm;
@protocol PPPostWebFormDelegate

- (void)postWebForm:(PPPostWebForm*)form didReceivedAsynchronousData:(NSData*)data;

@end


@interface PPPostWebForm : NSObject {
	NSMutableData *_data;
	NSMutableURLRequest *_request;
	NSMutableData *_responseData;
	id<PPPostWebFormDelegate>delegate;
}
- (id)initWithPostURL:(NSURL*)postURL;
- (void)addTextElement:(NSString*)name value:(NSString*)value;
- (void)addFileElement:(NSString*)name value:(NSString*)filePath;
- (NSData*)commitFormSynchronous;
- (void)commitFormAsynchronous;
@property(nonatomic,assign) id<PPPostWebFormDelegate>delegate;
@property(nonatomic,retain) NSMutableURLRequest *request;
@property(nonatomic,retain) NSData *responseData;
@end
