//
//  FoodModel.m
//  ALaCarte
//
//  Created by Shane Rosse on 5/4/15.
//  Copyright (c) 2015 Shane Rosse. All rights reserved.
//

#import "FoodModel.h"
#import "ViewController.h"

@interface FoodModel ()

@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSURLConnection *theConnection;
@property (nonatomic, strong) NSMutableDictionary *finalData;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation FoodModel

int counter = 0;

+ (instancetype) sharedModel {
    static FoodModel *_sharedModel = nil;
    //singleton model
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    
    return _sharedModel;
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.loaded = 0;
        
        self.favPlaces = [[NSMutableArray alloc] init];
        self.favURLs = [[NSMutableArray alloc] init];
        
        // Create the request.
        NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.locu.com/v1_0/venue/search/?has_menu=TRUE&postal_code=90007&api_key=641e3bfd79ba59d6fb7713e7788ccc521de27fb8"]
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:60.0];
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        _receivedData = [NSMutableData dataWithCapacity: 0];
        // create the connection with the request
        // and start loading the data
        _theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        
        if (!_theConnection) {
            // Release the receivedData object.
            _receivedData = nil;
            // Inform the user that the connection failed.
            NSLog(@"theConnection Failed!");
        }

    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse object.
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is an instance variable declared elsewhere.
    [_receivedData setLength:0];
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    _theConnection = nil;
    _receivedData = nil;
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // do something with the data
    // receivedData is declared as a property elsewhere
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[_receivedData length]);
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    
    //  self.finalData =(NSMutableDictionary*)self.receivedData;
    
    self.finalData = [NSJSONSerialization JSONObjectWithData:self.receivedData options:0 error:nil];
    self.dataArray = [self.finalData valueForKey:@"objects"];
    self.loaded = 1;
    
    
    
}

- (NSString*) setLabel {
    return (NSString*)[self.dataArray[counter] valueForKey:@"name"];
}

- (NSString*) setLabelToNext {
    NSString* answer = (NSString*)[self.dataArray[counter + 1] valueForKey:@"name"];
    counter = counter + 1;
    return answer;
}

- (void) addToFav {
    [self.favPlaces addObject:[self currentPlace]];
    [self.favURLs addObject:[self currentURL]];
    NSLog(@"Fav added in addToFav!");
    NSLog(@"%@", [self currentPlace]);
    NSLog(@"%@", [self currentURL]);
}

- (NSUInteger*) favLength {
    return (NSUInteger*)[self.favPlaces count];
}

- (NSString*) currentPlace {
    return (NSString*)[self.dataArray[counter] valueForKey:@"name"];
}
- (NSString*) currentURL {
    return (NSString*)[self.dataArray[counter] valueForKey:@"website_url"];
}

@end
