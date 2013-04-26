//
//  Created by Anh Quang Do on 4/25/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import "WebViewController.h"
#import "HealthVault.h"
#import "Common.h"

@interface WebViewController ()

@property (nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    _isSuccess = NO;

    [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
}

- (void)viewWillDisappear:(BOOL)animated {

    [self.webView stopLoading];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[HealthVault mainVault] startSpinner];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[HealthVault mainVault] stopSpinner];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (error.code == -999) return;

    alertMessage(error);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {

    NSString *URLString = [[request URL] absoluteString];

    NSRange authSuccessRange = [URLString rangeOfString:@"target=AppAuthSuccess"];
    if (authSuccessRange.location != NSNotFound) {
        [self.webView stopLoading];
        _isSuccess = YES;

        [self performSegueWithIdentifier:@"finishShellAuth" sender:nil];
    }

    return YES;
}

@end