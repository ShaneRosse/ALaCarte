//
//  WebViewController.m
//  ALaCarte
//
//  Created by Shane Rosse on 5/4/15.
//  Copyright (c) 2015 Shane Rosse. All rights reserved.
//

#import "WebViewController.h"
#import "FoodModel.h"

@interface WebViewController ()


@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) FoodModel* webModel;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webModel = [FoodModel sharedModel];
    // Do any additional setup after loading the view.
    
    
    NSLog(@"%@", self.webModel.favURLs[self.click.row]);
    //grab the URL as a string from the model
    NSString* urlString = self.webModel.favURLs[self.click.row];
    
    //convert the string to a URL
    NSURL* url = [NSURL URLWithString:urlString];
    
    //convert the URL to a URLRequest
    NSURLRequest* urlReq = [NSURLRequest requestWithURL:url];
    
    //Load the request
    [self.webView loadRequest:urlReq];
    
    //title the webview as the name of the restaurant
    self.title = self.webModel.favPlaces[self.click.row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
