# iCurlHTTP

![image](https://user-images.githubusercontent.com/836718/209584788-2eea8c00-4ff6-4225-ad42-6ef9d2a3a705.png)

iCurlHTTP is a simple, easy to use app for the iPhone, iPad and AppleTV that allows you to run MacOS/Linux terminal-like cURL tests against web URLs. It can simulate different web browsers (user-agents) to retrieve the raw HTTP headers and HTML response from web servers.

![image](https://user-images.githubusercontent.com/836718/209585825-c1b06ffd-baa8-4955-9861-f0a9cf1e6169.png)

## App Store Download

* iPhone, iPad and AppleTV - [Apple App Store](https://apps.apple.com/us/app/icurlhttp/id611943891)

## Features

* GET, HEAD, POST and PUT requests (DELETE, OPTIONS and TRACE also available on iPad)
* HTTPS/SSL support with certificate chain details, insecure mode, and forced SSLv3 for testing
* HTTP/2 support
* Browser emulation - curl, iPhone Safari, iPad Safari, Mac Safari, Windows IE, Chrome and Firefox user-agents
* Custom User-Agent, custom HTTP headers, POST data, and HTTP Authentication (Basic, Digest, NTLM, Negotiate)
* URL history dropdown (including POST and header data) for quick repeated testing
* Manual DNS resolve override and IPv4/IPv6 address resolution toggles
* Manual HTTP proxy override - set a custom proxy or force no proxy, independent of the iOS system proxy
* Configurable request and connect timeouts
* Detailed HTTP timing breakdown - DNS lookup, TCP connect, SSL handshake, first byte and total time
* Display Headers Only mode - discard the response body, like `curl -o /dev/null`
* Fixed Width Font option for the result output
* Large File Warning with cancelation option for big downloads
* Share output via Clipboard, Printer or Email
* Dark Mode support
* iPhone, iPad, AppleTV and Mac (Catalyst) support

## Source

This repo contains the complete source for iCurlHTTP. To build, use Xcode to load `iCurlHTTP.xcodeproj`. Issue reporting and contributions are welcome!

Requirements:

* Libraries for iOS: libcurl, openssl and nghttp2 which are built using the https://github.com/jasonacox/Build-OpenSSL-cURL project (using the xcframework).
* FXForms from https://github.com/nicklockwood/FXForms - included files

## Issues

Please report any issues or feature requests by opening an [Issue](https://github.com/jasonacox/iCurlHTTP/issues/new)
