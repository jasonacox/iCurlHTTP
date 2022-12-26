//
//  iCHSettingsForm.h
//  iCurlHTTP
//
//  Created by Jason Cox on 6/1/14.
//  Copyright (c) 2014 Jason Cox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

typedef NS_ENUM(NSInteger, AuthType)
{
    Basic = 0,
    Digest = 1,
    Any = 2
};

@interface iCHSettingsForm : NSObject <FXForm>
{
    // global settings data
    NSMutableDictionary *settingsdata;
}

// settings form fields
//@property (nonatomic, copy) NSString *userCode;
// AGENT
@property (nonatomic, copy) NSString *userAgent;

// Custom Headers
@property (nonatomic, copy) NSString *userHeaders;

// HTTP POST Data
@property (nonatomic, copy) NSString *userPost;

// SSL Security Mode
@property (nonatomic, assign) BOOL userInsecure;
@property (nonatomic, assign) BOOL userSSLv3;
@property (nonatomic, assign) BOOL userCertDetail;

// HTTP2 Mode
@property (nonatomic, assign) BOOL userHTTP2;

// Timeout
@property (nonatomic, copy) NSNumber *userTimeout;
@property (nonatomic, copy) NSNumber *userConnectTimeout;

// HTTP Authentication
// libcurl can be built to use: Basic, Digest, NTLM, Negotiate, GSS-Negotiate and SPNEGO.
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userPass;
@property (nonatomic, assign) BOOL userAuthBasic;
@property (nonatomic, assign) BOOL userAuthDigest;
@property (nonatomic, assign) BOOL userAuthNTLM;
@property (nonatomic, assign) BOOL userAuthNegotiate;
@property (nonatomic, assign) BOOL userAuthAny;

// IPv4 or IPv6 Support
@property (nonatomic, assign) BOOL userIPv4;
@property (nonatomic, assign) BOOL userIPv6;
@property (nonatomic, copy) NSString *userResolve;


@end
