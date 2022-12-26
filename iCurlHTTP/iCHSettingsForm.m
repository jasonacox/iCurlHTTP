//
//  iCHSettingsForm.m
//  iCurlHTTP
//
//  Created by Jason Cox on 6/1/14.
//  Copyright (c) 2014 Jason Cox. All rights reserved.
//

#import "iCHSettingsForm.h"
#import "curl.h"

@implementation iCHSettingsForm

// format fields
- (NSArray *)fields
{

        return @[
                 @{FXFormFieldKey: @"userAgent", FXFormFieldTitle: @"", FXFormFieldType: FXFormFieldTypeLongText, FXFormFieldHeader: @"Custom User Agent"},
                 @{FXFormFieldKey: @"userHeaders", FXFormFieldTitle: @"", FXFormFieldFooter: @"(ex. Label: Data)", FXFormFieldType: FXFormFieldTypeLongText, FXFormFieldHeader: @"Additional HTTP Headers ⓗ"},
                 @{FXFormFieldKey: @"userPost", FXFormFieldTitle: @"", FXFormFieldFooter: @"(ex. field1=data&field2=data)", FXFormFieldType: FXFormFieldTypeLongText, FXFormFieldHeader: @"POST Data ⓟ"},
                 
                 @{FXFormFieldKey: @"userInsecure", FXFormFieldTitle: @"Insecure Mode",  FXFormFieldType: FXFormFieldTypeOption, FXFormFieldHeader: @"SSL/TLS Settings"},
                 @{FXFormFieldKey: @"userCertDetail", FXFormFieldTitle: @"Cert Chain Details", FXFormFieldType: FXFormFieldTypeOption},
                 @{FXFormFieldKey: @"userSSLv3", FXFormFieldTitle: @"Force SSLv3", FXFormFieldType: FXFormFieldTypeOption, FXFormFieldFooter: @"(Select to disable TLS)"},
                 
                 @{FXFormFieldKey: @"userHTTP2", FXFormFieldTitle: @"Use HTTP2", FXFormFieldType: FXFormFieldTypeOption, FXFormFieldFooter: @"(Select for HTTP/2 support)"},
                 
                 @{FXFormFieldKey: @"userTimeout", FXFormFieldTitle: @"Timeout (sec):", FXFormFieldHeader: @"Timeouts", FXFormFieldType:FXFormFieldTypeInteger},
                 @{FXFormFieldKey: @"userConnectTimeout", FXFormFieldTitle: @"Connect Timeout (sec)", FXFormFieldType:FXFormFieldTypeInteger},
                 
                 @{FXFormFieldKey: @"userIPv4", FXFormFieldTitle: @"IPv4", FXFormFieldType: FXFormFieldTypeOption, FXFormFieldHeader: @"DNS Resolution Setting"},
                 @{FXFormFieldKey: @"userIPv6", FXFormFieldTitle: @"IPv6", FXFormFieldType: FXFormFieldTypeOption},
                 @{FXFormFieldKey: @"userResolve", FXFormFieldTitle: @"Resolve:", FXFormFieldFooter: @"Resolve format: [host]:[port]:[address]\n(ex: jasonacox.com:80:10.0.0.1)"},
                 
                 @{FXFormFieldKey: @"userName", FXFormFieldTitle: @"Username:", FXFormFieldHeader: @"HTTP Authentication"},
                 @{FXFormFieldKey: @"userPass", FXFormFieldTitle: @"Password:"},
                 @{FXFormFieldKey: @"userAuthBasic", FXFormFieldTitle: @"Auth-Basic", FXFormFieldType: FXFormFieldTypeOption},
                 @{FXFormFieldKey: @"userAuthDigest",  FXFormFieldTitle: @"Auth-Digest", FXFormFieldType: FXFormFieldTypeOption},
                 @{FXFormFieldKey: @"userAuthNTLM", FXFormFieldTitle: @"Auth-NTLM", FXFormFieldType: FXFormFieldTypeOption},
                 @{FXFormFieldKey: @"userAuthNegotiate", FXFormFieldTitle: @"Auth-Negotiate", FXFormFieldType: FXFormFieldTypeOption},
                 @{FXFormFieldKey: @"userAuthAny", FXFormFieldFooter: [@"" stringByAppendingFormat:@"iCurlHTTP v%@ Build %@\n(c) 2022 Jason A. Cox\n\nUsing:\n%s",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"], curl_version()], FXFormFieldTitle: @"Auth-Any", FXFormFieldType: FXFormFieldTypeOption},
                 ];
}

@end
