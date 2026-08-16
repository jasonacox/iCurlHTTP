# iCurlHTTP - Architecture Design Document

## Overview

iCurlHTTP is an iOS application that provides HTTP server response diagnostics similar to cURL. It allows users to execute HTTP requests (GET, HEAD, POST, PUT, DELETE, OPTIONS, TRACE) against web servers and view detailed response information including headers, SSL/TLS details, timing metrics, and certificate chains.

**Current Version:** v1.19  
**Platform:** iOS 13.0+ (iPhone, iPad, Mac Catalyst)  
**Primary Language:** Objective-C  
**Key Dependencies:** libcurl 8.17.0, OpenSSL 3.0.18, nghttp2 1.68.0, FXForms

---

## Application Architecture

### Architecture Pattern

The application follows a **Model-View-Controller (MVC)** pattern with some procedural elements:

- **Model:** Data persistence via Property Lists (`.plist` files)
- **View:** XIB files for UI layout (device-specific)
- **Controller:** View controllers managing UI and business logic

```mermaid
graph TB
    subgraph "Application Layer"
        AppDelegate[iCHAppDelegate]
        SceneDelegate[iCHSceneDelegate]
    end
    
    subgraph "View Controllers"
        MainVC[iCHViewController]
        SettingsVC[iCHSettingsViewController]
    end
    
    subgraph "Models & Forms"
        SettingsForm[iCHSettingsForm]
        FXForms[FXForms Library]
    end
    
    subgraph "Data Layer"
        URLs[urls.plist]
        POST[urlspost.plist]
        HEADER[urlsheader.plist]
        Settings[Settings.plist]
    end
    
    subgraph "Native Libraries"
        libcurl[libcurl]
        OpenSSL[OpenSSL]
        nghttp2[nghttp2]
    end
    
    AppDelegate -->|Configures scene, curl init| SceneDelegate
    SceneDelegate -->|Creates window/root VC| MainVC
    MainVC -->|Presents| SettingsVC
    SettingsVC -->|Uses| SettingsForm
    SettingsForm -->|Extends| FXForms
    
    MainVC -->|Reads/Writes| URLs
    MainVC -->|Reads/Writes| POST
    MainVC -->|Reads/Writes| HEADER
    SettingsVC -->|Reads/Writes| Settings
    
    MainVC -->|HTTP Requests| libcurl
    libcurl -->|SSL/TLS| OpenSSL
    libcurl -->|HTTP/2| nghttp2
```

---

## Core Components

### 1. Application & Scene Delegates (`iCHAppDelegate`, `iCHSceneDelegate`)

**Files:** `iCHAppDelegate.h/m`, `iCHSceneDelegate.h/m`

**Responsibilities:**
- `iCHAppDelegate`: app-level lifecycle, libcurl/OpenSSL global initialization,
  and handing off scene configuration to `iCHSceneDelegate`
- `iCHSceneDelegate`: `UIScene` lifecycle window/root view controller creation
  (required as of iOS 13; the app's minimum deployment target)
- Shared `+[iCHAppDelegate nibNameForWindow:]` picks the right nib for the
  device idiom, notch/Dynamic Island, or Mac Catalyst

**Key Logic:**
```objectivec
- Notch/Dynamic Island detection via window.safeAreaInsets.bottom > 0
  (not a hardcoded list of screen heights - works on any future device)
- Mac Catalyst detection via TARGET_OS_MACCATALYST
- OpenSSL and libcurl global initialization
```

---

### 2. Main View Controller (`iCHViewController`)

**Files:** `iCHViewController.h/m`

**Responsibilities:**
- Primary UI management
- HTTP request execution via libcurl
- Result display and formatting
- URL history management
- Progress tracking and user feedback

**Key Properties:**

| Property | Type | Purpose |
|----------|------|---------|
| `_urlText` | UITextField | URL input field |
| `_resultText` | UITextView | Response output display |
| `_httpReq` | UISegmentedControl | HTTP method selector |
| `_browserType` | UISegmentedControl | User-Agent selector |
| `_verbose` | UISegmentedControl | Output mode toggle |
| `_progress` | UIProgressView | Download progress indicator |
| `_curl` | CURL* | libcurl handle |
| `favoriteURLs` | NSMutableArray | URL history |
| `favoritePOST` | NSMutableArray | POST data history |
| `favoriteHEADER` | NSMutableArray | Header history |

**Key Methods:**

```objectivec
- (IBAction)Go:(id)sender              // Execute HTTP request
- (IBAction)DropDown:(id)sender        // Show URL history
- (IBAction)Share:(id)sender           // Share/export results
- (IBAction)User:(id)sender            // Open settings
- (IBAction)Reset:(id)sender           // Reset/cancel request
- (void)initLibcurl                    // Initialize libcurl
- (void)loadSettings                   // Load user settings
- (void)saveSettings                   // Persist settings
```

**libcurl Integration:**

The view controller manages libcurl through callback functions:

```mermaid
sequenceDiagram
    participant User
    participant ViewController
    participant libcurl
    participant Callbacks
    
    User->>ViewController: Tap Go Button
    ViewController->>ViewController: Configure libcurl options
    ViewController->>libcurl: curl_easy_perform()
    
    loop During Transfer
        libcurl->>Callbacks: iCHCurlDebugCallback
        Callbacks->>ViewController: insertText/insertTextv
        libcurl->>Callbacks: iCHCurlProgressCallback
        Callbacks->>ViewController: updateProgress
        libcurl->>Callbacks: iCHCurlWriteCallback
        Callbacks->>ViewController: Check globalReset
    end
    
    libcurl->>ViewController: Return result code
    ViewController->>ViewController: Process timing metrics
    ViewController->>User: Display results
```

**Callback Functions:**

| Function | Purpose |
|----------|---------|
| `iCHCurlDebugCallback` | Captures verbose debug output (headers, data) |
| `iCHCurlWriteCallback` | Handles response body data |
| `iCHCurlProgressCallback` | Reports download progress |
| `iCHCurlIoctlCallback` | Handles data rewind for retries |
| `iCHCurlReadCallback` | Provides upload data (POST/PUT) |

---

### 3. Settings Controller (`iCHSettingsViewController`)

**Files:** `iCHSettingsViewController.h/m`

**Responsibilities:**
- Settings form presentation
- User preference persistence
- Integration with FXForms library

**Key Features:**
- Modal presentation
- Form-based settings using FXForms
- Settings.plist management

---

### 4. Settings Form Model (`iCHSettingsForm`)

**Files:** `iCHSettingsForm.h/m`

**Responsibilities:**
- Settings data model conforming to `FXForm` protocol
- Field definitions and layout
- Form validation

**Settings Categories:**

```mermaid
graph LR
    A[Settings] --> B[User Agent]
    A --> C[HTTP Headers]
    A --> D[POST Data]
    A --> E[SSL/TLS Options]
    A --> F[HTTP/2]
    A --> G[Timeouts]
    A --> H[DNS Resolution]
    A --> I[Authentication]
    A --> J[Proxy Settings]
    A --> K[Response Output]
    
    E --> E1[Insecure Mode]
    E --> E2[Cert Chain Details]
    E --> E3[Force SSLv3]
    
    H --> H1[IPv4/IPv6]
    H --> H2[Manual Resolve]
    
    I --> I1[Username/Password]
    I --> I2[Auth Methods]
    
    J --> J1[Override System Proxy]
    J --> J2[Custom Proxy host:port]
    
    K --> K1[Display Headers Only]
    K --> K2[Fixed Width Font]
```

**Settings Properties:**

| Property | Type | Purpose |
|----------|------|---------|
| `userAgent` | NSString | Custom User-Agent string |
| `userHeaders` | NSString | Additional HTTP headers |
| `userPost` | NSString | POST data payload |
| `userInsecure` | BOOL | Skip SSL verification |
| `userSSLv3` | BOOL | Force SSLv3 protocol |
| `userCertDetail` | BOOL | Show certificate chain |
| `userHTTP2` | BOOL | Enable HTTP/2 support |
| `userTimeout` | NSNumber | Request timeout (seconds) |
| `userConnectTimeout` | NSNumber | Connection timeout (seconds) |
| `userIPv4/userIPv6` | BOOL | IP version preferences |
| `userResolve` | NSString | Manual DNS resolution |
| `userProxyOverride` | BOOL | Manually override the iOS system proxy |
| `userProxy` | NSString | Proxy override `[host]:[port]`, blank forces no proxy |
| `userHeadersOnly` | BOOL | Discard response body (like `curl -o /dev/null`) |
| `userFixedFont` | BOOL | Display result output in a monospace font |
| `userName/userPass` | NSString | Authentication credentials |
| `userAuth*` | BOOL | Authentication method flags |

---

### 5. Utility Extensions

#### `iCHColors.h`

**Purpose:** Centralized color definitions for light/dark mode support

**Key Definitions:**
- Light mode colors (`UITEXTLIGHT`, `UITEXTBGLIGHT`)
- Dark mode colors (`UITEXTDARK`, `UITEXTBGDARK`)
- Border and status colors

#### `iCHSegmentedOverride.h`

**Purpose:** UISegmentedControl category for iOS 13+ styling

**Features:**
- Custom text color handling for iOS 13+
- Maintains consistent appearance across iOS versions

#### `iCHStringTrunc.h`

**Purpose:** NSString category for text truncation

**Features:**
- Truncate strings to fit width with ellipsis
- Font-aware sizing

---

## Data Persistence

### Property List Files

The application uses `.plist` files stored in the Documents directory:

```mermaid
graph TD
    A[Data Persistence] --> B[urls.plist]
    A --> C[urlspost.plist]
    A --> D[urlsheader.plist]
    A --> E[Settings.plist]
    
    B --> B1[URL History Array]
    C --> C1[POST Data History]
    D --> D1[Header History]
    E --> E1[User Preferences Dictionary]
    
    style B fill:#e1f5ff
    style C fill:#e1f5ff
    style D fill:#e1f5ff
    style E fill:#fff4e1
```

### Data Flow

```mermaid
sequenceDiagram
    participant App as Application
    participant Bundle as App Bundle
    participant Docs as Documents Directory
    
    Note over App,Docs: First Launch
    App->>Bundle: Check for plist in bundle
    Bundle->>App: Return template plist
    App->>Docs: Copy to Documents
    
    Note over App,Docs: Subsequent Launches
    App->>Docs: Check for plist
    Docs->>App: Return user data
    
    Note over App,Docs: User Makes Changes
    App->>App: Modify data in memory
    App->>Docs: Write updated plist
```

---

## Network Architecture

### libcurl Configuration

The application configures libcurl with extensive options:

**Base Configuration:**
```objectivec
CURLOPT_HTTPAUTH        → CURLAUTH_BASIC
CURLOPT_NOSIGNAL        → 0L
CURLOPT_VERBOSE         → 1L
CURLOPT_CAINFO          → cacert.pem path
CURLOPT_TIMEOUT         → User configurable (default: 60s)
CURLOPT_CONNECTTIMEOUT  → User configurable (default: 10s)
```

**SSL/TLS Configuration:**
```objectivec
CURLOPT_SSLVERSION      → CURL_SSLVERSION_DEFAULT or SSLv3
CURLOPT_SSL_CIPHER_LIST → "ALL" (permits all cipher suites)
CURLOPT_CERTINFO        → 1L (collect certificate chain)
CURLOPT_SSL_VERIFYPEER  → Conditional (based on userInsecure)
```

**HTTP/2 Configuration:**
```objectivec
CURLOPT_HTTP_VERSION → CURL_HTTP_VERSION_2_0 (if userHTTP2 enabled)
```

### Request Flow

```mermaid
flowchart TD
    Start([User Taps Go]) --> LoadSettings[Load User Settings]
    LoadSettings --> ValidateURL{Valid URL?}
    ValidateURL -->|No| UseDefault[Use Default/History]
    ValidateURL -->|Yes| ConfigCurl[Configure libcurl]
    UseDefault --> ConfigCurl
    
    ConfigCurl --> SetMethod[Set HTTP Method]
    SetMethod --> SetHeaders[Configure Headers]
    SetHeaders --> SetUserAgent[Set User-Agent]
    SetUserAgent --> SetSSL{HTTPS?}
    
    SetSSL -->|Yes| ConfigSSL[Configure SSL/TLS]
    SetSSL -->|No| SetData
    ConfigSSL --> SetData[Set POST/PUT Data]
    
    SetData --> Execute[curl_easy_perform]
    
    Execute --> Callbacks{Callbacks}
    Callbacks -->|Debug| DisplayHeaders[Display Headers/Debug]
    Callbacks -->|Progress| UpdateProgress[Update Progress Bar]
    Callbacks -->|Write| HandleData[Handle Response Data]
    
    HandleData --> Complete{Complete?}
    Complete -->|No| Callbacks
    Complete -->|Yes| GetMetrics[Extract Metrics]
    
    GetMetrics --> Timing[Display Timing Data]
    Timing --> Certs{Show Certs?}
    Certs -->|Yes| DisplayCerts[Display Certificate Chain]
    Certs -->|No| CheckRedirect
    DisplayCerts --> CheckRedirect{301/302?}
    
    CheckRedirect -->|Yes| PromptRedirect[Prompt to Follow]
    CheckRedirect -->|No| SaveHistory
    PromptRedirect --> SaveHistory[Save to History]
    
    SaveHistory --> End([Display Complete])
```

---

## User Interface

### Device-Specific Views

The application uses different XIB files based on device:

| Device Type | XIB File | Notes |
|-------------|----------|-------|
| iPhone (standard) | `iCHViewController_iPhone_port.xib` | iPhone 6/7/8, SE |
| iPhone (notched) | `iCHViewController_iPhoneX_port.xib` | iPhone X and newer |
| iPad | `iCHViewController_iPad_port.xib` | All iPad models |
| Mac Catalyst | `iCHViewController_Mac.xib` | macOS version |

**Device Detection Logic:**
```objectivec
userInterfaceIdiom == Phone:
  window.safeAreaInsets.bottom > 0 → Notched/Dynamic Island iPhone (X and newer)
  otherwise → Standard iPhone (home button)
userInterfaceIdiom == Pad → Use iPad layout
TARGET_OS_MACCATALYST → Use Mac layout
```
Using the safe area insets (rather than a hardcoded list of native screen
heights) means new device sizes are handled automatically without a code
update - the original height-list approach broke on iPhone 13 Pro+/14 Pro/15/16
series since they weren't in the list.

### Dark Mode Support

iOS 13+ dark mode support:

```mermaid
graph TD
    A[Trait Collection Change] --> B{Dark Mode?}
    B -->|Yes| C[Apply Dark Colors]
    B -->|No| D[Apply Light Colors]
    
    C --> C1[UITEXTDARK]
    C --> C2[UITEXTBGDARK]
    C --> C3[UIDARKBACKGROUND]
    
    D --> D1[UITEXTLIGHT]
    D --> D2[UITEXTBGLIGHT]
    D --> D3[UILIGHTBACKGROUND]
```

---

## Threading Model

### Concurrency Approach

The application uses a simple threading model:

1. **Main Thread:** UI operations, user interaction
2. **Background Thread:** HTTP requests (implicit in libcurl callbacks)
3. **Synchronization:** `globalReset` flag for cancellation

**Global Reset States:**
- `0` - Idle, ready for new request
- `1` - Request in progress
- `2` - Cancellation requested

**Thread Safety Mechanisms:**
```objectivec
waitForUser flag → Blocks download thread during user dialogs
globalReset flag → Signals cancellation to libcurl callbacks
Main run loop pumping → Ensures UI updates during long operations
```

**Result View Performance (v1.19):** the result `UITextView` is updated via
`appendResultText:`/`setResultText:` helpers that mutate its `NSTextStorage`
incrementally instead of reassigning the whole `.text` (which forced a full
relayout of everything received so far). `NSLayoutManager.allowsNonContiguousLayout`
is enabled so scrolling large, heavily-wrapped responses doesn't require
laying out everything before the visible range. The run-loop pump used to keep
the UI responsive during a transfer now also services `UITrackingRunLoopMode`,
not just the default mode, so scroll/drag gestures started mid-transfer are
more likely to get serviced.

**Known limitation:** `curl_easy_perform()` still runs synchronously on the
main thread; responsiveness during a transfer depends on curl invoking the
debug callback often enough to pump the run loop. See
[issue #10](https://github.com/jasonacox/iCurlHTTP/issues/10) for the plan to
move the transfer to a background thread and remove this pattern entirely.

---

## Feature Capabilities

### HTTP Methods Supported

| Method | iPhone | iPad |
|--------|--------|------|
| GET | ✓ | ✓ |
| HEAD | ✓ | ✓ |
| POST | ✓ | ✓ |
| PUT | ✓ (newer models) | ✓ |
| DELETE | - | ✓ |
| OPTIONS | - | ✓ |
| TRACE | - | ✓ |

### Browser Emulation

User-Agent presets for:
- cURL (default)
- iPhone Safari
- iPad Safari
- Chrome
- Firefox (iPad)
- Internet Explorer

### Output Modes

1. **Basic Mode:** Clean response output
2. **Detail Mode:** Verbose headers, timing, SSL details

### Share Capabilities

```mermaid
graph LR
    A[Share Button] --> B[Print]
    A --> C[Email]
    A --> D[Clipboard]
    
    B --> B1[Generate Formatted Report]
    C --> C1[MFMailComposeViewController]
    D --> D1[UIPasteboard]
```

---

## External Dependencies

### libcurl (v8.17.0)

**Purpose:** HTTP/HTTPS request handling

**Configuration:**
- Custom callbacks for debugging
- Progress tracking
- SSL certificate handling
- HTTP/2 support via nghttp2

**Include Path:** `include/curl/`

### OpenSSL (v3.0.18)

**Purpose:** SSL/TLS encryption and certificate handling

**Features Used:**
- Certificate verification
- Certificate chain inspection
- Multiple cipher suite support
- SSLv3/TLS protocol selection

**Include Path:** `include/openssl/`

### nghttp2 (v1.68.0)

**Purpose:** HTTP/2 protocol support

**Integration:** Compiled into libcurl

The compiled `lib/*.xcframework` binaries are intentionally **not** committed
(`.gitignore`'d) - only `Info.plist` structure stubs are tracked. Build them
locally via [Build-OpenSSL-cURL](https://github.com/jasonacox/Build-OpenSSL-cURL)
and drop the output into `lib/`. The `.github/workflows/ios-build.yml` CI
workflow downloads a matching prebuilt release for automated builds.

### FXForms (v1.2 beta)

**Purpose:** Dynamic form generation for settings

**Features Used:**
- Declarative form definitions
- Automatic UITableView population
- Field type handling (text, boolean, integer)
- Section headers/footers

**Files:** `FXForms/FXForms.h/m`

---

## Build Configuration

### Project Structure

```
iCurlHTTP.xcodeproj/
├── project.pbxproj          # Xcode project configuration
└── xcuserdata/              # User-specific settings (gitignored)

include/                      # C library headers
├── curl/                    # libcurl headers
└── openssl/                 # OpenSSL headers

lib/                          # xcframework structure stubs (Info.plist only)
├── libcrypto.xcframework/    # Compiled binaries are gitignored - build
├── libssl.xcframework/       # locally via Build-OpenSSL-cURL or let CI
├── libcurl.xcframework/      # fetch them (.github/workflows/ios-build.yml)
└── libnghttp2.xcframework/

iCurlHTTP/                   # Application source
├── *.h, *.m                 # Implementation files
├── *.xib                    # Interface files
├── *.plist                  # Data files
└── Images.xcassets/         # Image resources

test/                        # Dev tooling (not part of the Xcode project)
├── proxy_server.py          # IPv4/IPv6 HTTP(S) forward proxy for testing
└── README.md                # the proxy override setting

.github/workflows/           # CI
└── ios-build.yml            # Builds for iOS Simulator on push/PR

RELEASE.md                   # Per-version release notes
```

### Compiler Settings

**Language:** Objective-C  
**Deployment Target:** iOS 13.0+ (required once `UIScene` lifecycle was adopted)  
**Architectures:** arm64, arm64e (iOS), x86_64/arm64 (Simulator), x86_64 (Catalyst)

---

## Next Steps & Areas for Improvement

### High Priority

1. **Code Modernization**
   - Migrate to Swift for better type safety and modern syntax
   - Replace manual memory management with ARC (if not already enabled)
   - Adopt Swift Concurrency (async/await) for network operations
   
2. **Architecture Improvements**
   - Separate network logic into dedicated service layer
   - Implement MVVM pattern for better testability
   - Create reusable networking component
   
   ```mermaid
   graph TD
       A[View Controller] --> B[View Model]
       B --> C[HTTP Service]
       C --> D[libcurl Wrapper]
   ```

3. **Threading Enhancement**
   - Move `curl_easy_perform()` off the main thread and dispatch UI updates
     back via GCD, removing the `waitForUser`/run-loop-pumping pattern
     entirely - tracked in [issue #10](https://github.com/jasonacox/iCurlHTTP/issues/10)
   - Replace `globalReset` flag with modern cancellation tokens

4. **User Interface**
   - Consolidate XIB files using Auto Layout and size classes
   - Migrate to SwiftUI for modern declarative UI
   - Improve iPad multitasking support

### Medium Priority

5. **Feature Additions**
   - **Search/Filter:** Add search functionality for response text (regex support)
   - **Formatted Output:** JSON/XML syntax highlighting and pretty-printing
   - **Request Collections:** Save and organize multiple request configurations
   - **Export Formats:** Support exporting to HAR, Postman, or cURL command
   - **HTTP/3 Support:** Integrate QUIC protocol when libcurl supports it
   - **WebSocket Support:** Add WebSocket debugging capabilities
   
6. **Testing**
   - CI now builds the app for iOS Simulator on every push/PR
     (`.github/workflows/ios-build.yml`) - still no unit/UI test target
   - Add unit tests for network logic
   - Implement UI tests for critical workflows
   - Mock libcurl for testing without network
   
7. **Settings Enhancement**
   - Multiple profiles/workspaces
   - Import/export settings
   - Request templates
   - Environment variables support

8. **Response Handling**
   - Image preview for image responses
   - HTML rendering option
   - Binary data visualization (hex viewer)
   - Response diff comparison

### Low Priority

9. **Code Quality**
   - Extract magic numbers to constants
   - Improve error handling and user feedback
   - Add code documentation (HeaderDoc/Jazzy)

10. **Performance**
    - Lazy loading for large responses
    - Streaming for large downloads
    - Background download support
    - Response caching options

11. **Accessibility**
    - VoiceOver support improvements
    - Dynamic Type support
    - Accessibility labels for all controls

12. **Security**
    - Keychain storage for credentials
    - Certificate pinning option
    - Secure storage for sensitive data

### Technical Debt

13. **Legacy Code**
    - Remove commented-out code (old UIAlertView code paths, superseded
      UIAlertController flows, stale iOS version checks)
    - Consolidate duplicate XIB files

14. **Build System**
    - Consider Swift Package Manager for dependencies
    - Add SwiftLint or similar linting tools

15. **Documentation**
    - Add inline code documentation
    - Create user manual
    - Document libcurl configuration patterns
    - API documentation for public methods

---

## Version History Summary

| Version | Release Date | Key Features |
|---------|--------------|--------------|
| v1.0 | 2/15/2013 | Initial release |
| v1.1 | 3/25/2013 | OpenSSL integration, SSL cert info |
| v1.2 | 9/5/2013 | iOS 7, timing details |
| v1.3 | 6/15/2014 | Share feature, user settings |
| v1.4 | 2/19/2015 | iPhone POST, history, iOS 8 |
| v1.5 | 2/6/2016 | Redirect following, Chrome UA |
| v1.6 | 9/5/2016 | HTTP/2, cert chain, IPv4/IPv6 |
| v1.7 | 10/15/2016 | DNS resolve, iPhone 7 |
| v1.8 | 10/31/2016 | Performance fixes |
| v1.9 | 12/23/2016 | iOS 9 compatibility |
| v1.10 | 11/11/2017 | HTTP/2 fixes |
| v1.11 | 4/21/2018 | iPhone X, iOS 12 |
| v1.12 | 4/4/2019 | OpenSSL 1.1.1 |
| v1.13 | 1/1/2020 | Dark mode, iOS 13 |
| v1.14 | 9/12/2020 | iPhone PUT support |
| v1.15 | 12/29/2020 | iPhone 12 support |
| v1.16 | 1/2/2021 | Mac Catalyst |
| v1.17 | 11/21/2021 | iPhone 13, latest libraries |
| v1.18 | 1/4/2026 | OpenSSL 3.0.18 upgrade, updated libcurl/nghttp2, iOS 12.0 minimum |
| v1.19 | 1/5/2026 | iOS 13.0 minimum, `UIScene` lifecycle, Display Headers Only, Fixed Width Font, manual proxy override, large-file threshold raised to 2MB, notch detection fixed for newer iPhones, result-view performance overhaul, deprecation/warning cleanup |

---

## Conclusion

iCurlHTTP is a well-established iOS application with a long history of updates and improvements. The architecture follows classic iOS MVC patterns with direct integration to native C libraries (libcurl, OpenSSL). While the codebase is mature and functional, there are significant opportunities for modernization including Swift migration, architectural refactoring, and enhanced testing coverage.

The application demonstrates good practices in:
- Multi-device support, with notch/Dynamic Island detection that adapts to
  new hardware automatically
- Persistent data management
- Dark mode adaptation
- Native library integration
- CI that builds the app on every push/PR

Areas requiring attention include moving network I/O off the main thread (see
[issue #10](https://github.com/jasonacox/iCurlHTTP/issues/10)), UI
consolidation, adding automated tests, and broader code modernization to
leverage recent iOS platform capabilities.
