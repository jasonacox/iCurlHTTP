# Release Notes

Version history for iCurlHTTP, most recent first. Compiled from the revision
notes in [iCHViewController.m](iCurlHTTP/iCHViewController.m).

## v1.19

- Added "Display Headers Only" setting under Response Output ([#8](https://github.com/jasonacox/iCurlHTTP/pull/8)) -
  discards the response body (like `curl -o /dev/null`) and shows a one-line
  notice instead, skipping the Large File Warning for big downloads. Thanks
  @jasonacox-sam, requested by @sourcecodemage in [#7](https://github.com/jasonacox/iCurlHTTP/issues/7)
- Declared `ITSAppUsesNonExemptEncryption=false` in `iCurlHTTP-Info.plist` for
  App Store export-compliance
- Removed unused sandbox/network-client entitlements
- `urls.plist` defaults switched to `https`
- Raised the Large File Warning threshold from 200KB to 2MB to match modern
  HTML page sizes ([#5](https://github.com/jasonacox/iCurlHTTP/issues/5))
- Added "Fixed Width Font" setting under Response Output ([#6](https://github.com/jasonacox/iCurlHTTP/issues/6)) -
  displays result output in a monospace font
- Added "Override System Proxy" setting under a new Proxy Settings section
  ([#3](https://github.com/jasonacox/iCurlHTTP/issues/3)) - manually set a
  custom proxy or force no proxy for testing, instead of always following the
  iOS system proxy setting
- Spacing/constraint refinements in `iCHViewController_iPhoneX_port.xib`
- Bug Fix - Notch / Dynamic Island detection now uses safe area insets instead
  of a hardcoded list of screen heights, fixing layout on newer iPhones
  (13 Pro+, 14 Pro, 15, 16, 17 series)

## v1.18

- OpenSSL 3.0.18 upgrade (from 1.1.1l)
- Updated libcurl and nghttp2 libraries
- Raised minimum deployment target to iOS 12.0

## v1.17 - 11/21/2021

- Support for new iPhone 13
- Updates - New libcurl (7.80.0), openssl (1.1.1l), nghttp2 (1.46.0) libraries

## v1.16 - 1/2/2021

- Support for new iPhone 12 (Redo)
- Added support for new iPhone 12 models (12, Pro, Pro Max, Mini) in v1.15
- Bug Fix - SSLv3 Added for Testing (Force SSLv3 Setting)
- Mac Catalyst Support Added

## v1.15 - 12/29/2020

- Support for new iPhone 12
- Added support for new iPhone 12 models (12, Pro, Pro Max, Mini)
- Updates - New libcurl (7.74.0), openssl (1.1.1i), nghttp2 (1.42.0) libraries

## v1.14 - 9/12/2020

- PUT Support for iPhone
- Bug Fix - SSLv3 Added for Testing (Force SSLv3 Setting)
- Updates - New libcurl (7.72.0), openssl (1.1.1g), nghttp2 (1.41.0) libraries

## v1.13 - 1/1/2020

- iOS 13 - Dark Mode Support
- Updates - New libcurl (7.67.0), openssl (1.1.1d), nghttp2 (1.40.0) libraries

## v1.12 - 4/4/2019

- OpenSSL 1.1.1 Upgrade
- Updates - New libcurl (7.64.1), openssl (1.1.1b), nghttp2 (1.37.0) libraries
- Updates - Supporting new iPhone Models (XR, XS, XS Max) and iOS 12.2

## v1.11 - 4/21/2018

- iOS 12 - iPhone X Support
- Updates - New libcurl (7.60.0), openssl (1.0.2o), nghttp2 (1.32.0) libraries
- Cleanup - Upgraded UIAlertView to UIAlertController
- Cleanup - Added userWait to stop download thread while a user dialog is open

## v1.10 - 11/11/2017

- Bug Fix to Address Compatability Issues with HTTP2
- Updates - New libcurl (7.56.1), openssl (1.0.2m), nghttp2 (1.27.0) libraries

## v1.9 - 12/23/2016

- Bug Fix to Address Compatability Issues with iOS 9
- Updates - New libcurl (7.52.1), openssl (1.0.1u), nghttp2 (1.17.0) libraries

## v1.8 - 10/31/2016

- Performance Improvements and Bug Fixes to Address User Interface Related Crashes
- Updated iCurlHTTP User Agent Default
- Added user defined DNS lookup & connection timeout setting (default 5s)

## v1.7 - 10/15/2016

- Added DNS Resolve Option for Manual Address Resolution (eg. HOST:PORT:ADDRESS)
- iOS 10 - iPhone7 and iPhone7 Plus Support
- Updates - New libcurl (7.50.3), openssl (1.0.1u), nghttp2 (1.15.0) libraries

## v1.6 - 9/5/2016

- Added HTTP2 Protocol Support via nghttp2 (1.14.0) library
- Added Certificate Chain Details for HTTPS Sessions (Detail Mode)
- Added Support for Authentication Credentials in URL (e.g. https://user:pass@jasonacox.com/gettest.php)
- Added Setting Toggles for IPv4 and IPv6 Address Resolution
- Updates - New libcurl (7.50.1) and openssl (1.0.1t) libraries

## v1.5 - 2/6/2016

- Added 301/302 redirect following option
- Updated User and Share buttons with icons instead of text
- Added Chrome to iPhone browser emulation options
- Updates - New libcurl (7.47.1) and openssl (1.0.1r) libraries

## v1.4 - 2/19/2015

- POST Requests added to iPhone
- URL history now includes POST and HEADER data
- URL history can be cleared in User settings menu
- Added user defined timeout setting (default 30s)
- iOS 8 - iPhone6 and iPhone6 Plus Support
- Updates - New libcurl (7.40.0) and openssl (1.0.1l) libraries (SSLv3 disabled by default)
- Security Options - User setting to allow Forced SSLv3 for testing

## v1.3 - 6/15/2014

- Share Feature - Send output to Clipboard, Printer and Email
- User Settings - Adjust User-Agent, Custom Headers, POST Data, Authentication and SSL Mode
- Updates - New libcurl (7.37.0) and openssl (1.0.1h) libraries
- Updated user-agents

## v1.2 - 9/5/2013

- Updated to use new iOS 7 SDK and fix Basic/Detail toggle button alignment in iOS 7
- Added HTTP timing details to View and Detail Output (Name Lookup, TCP Connect, SSL Handshake, First Byte and Total)

## v1.1 - 3/25/2013

- Added OpenSSL+libcurl library for enhanced SSL information (eg. cert expiration, verification)
- Increased libcurl buffer to 32k to accelerate transfer of large HTML documents
- Added warning and cancelation option for larger HTML downloads (>250k)
- Bug Fix: Corrected PUT method stickiness (incorrectly ran PUT http method even after switching)
- Bug Fix: Corrected URL dropdown table bug in landscape mode (adjusting for keyboard offset)

## v1.0 - 2/15/2013

- First Version
