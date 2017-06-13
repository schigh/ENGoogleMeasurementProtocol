ENGoogleMeasurementProtocol is a simple utility to assist you in gathering metrics from within your applications.  It works for iOS and Mac OSX.

#### To Use:
Add the following files to your project:

* `ENGoogleMeasurementProtocol.h`
* `ENGAManager.h`
* `ENGAManager.m`
* `ENGAOperation.h`
* `ENGAOperation.m`

Import `ENGoogleMeasurementProtocol.h` anywhere you want to use the tool.  I recommend just importing it in your `[PROJECTNAME]-Prefix.pch` file

In your application delegate (`applicationDidFinishLaunching`), do the following:

    ENGAManager *gaMgr = [ENGAManager sharedManager];
    gaMgr.userAgent = @"myApp v1.0";
    NSString *clientID = [gaMgr clientToken];
    [gaMgr registerDefaults:@{
          @(kVersionKey): @"1",
          @(kTrackingIDKey): @"UA-XXXX-Y",
          @(kClientIDKey): clientID,
          @(kAppNameKey): @"myApp"
    }];

This will set the default values that are sent to Google on every request.  For all requests to the measurement protocol servers, the following parameters must ALWAYS be set:

* `kVersionKey` (always 1)
* `kTrackingIDKey` (Your GA tracking ID)
* `kClientIDKey` (Unique identifier assigned to the user.  See below)
* `kHitTypeKey` (Hit Type.  You don't set this directly)

Depending on the context of usage, you will find that analytics events will not show up in your GA dashboard unless you define a value for the `kAppNameKey` as well.

A complete explanation of the Management Protocol and all associated parameters can be found in the [developer guide][devguide] and [parameters guide][paramguide] provided by Google.

The enumeration of possible keys is defined in `ENGoogleMeasurementProtocol.h`.

----
#### ENGAManager
The `ENGAManager` interface lives as a Singleton within your application.  You can obtain the instance object by calling

    [ENGAManager sharedManager]
    
Requests to the Measurement Protocol service require a client id parameter, and it should be unique for each user in your application.  The toolkit provides a simple UUID method in the form of:

    ENGAManager *gaMgr = [ENGAManager sharedManager];
    NSString *clientID = [gaMgr clientToken];
    
When this is called the first time, it will store the generated UUID in your application's user defaults (with the key named `ENGAV...USERTOKEN`)

Of course you can use any client id scheme you like.

----

##### Usage
There are convenience methods to simplify making requests to the measurement protocol endpoint.

- `- (void) pageView:(NSDictionary *)params;`
   - Page View event. &nbsp;[Param List][pageviewparams]<br /><br />
- `- (void) event:(NSDictionary *)params;`
   - Event event. &nbsp;[Param List][eventparams]<br /><br />
- `- (void) appView:(NSDictionary *)params;`
   - App Tracking. &nbsp;[Param List][apptrackingparams]<br /><br />
- `- (void) transaction:(NSDictionary *)params;`
   - Ecommerce Tracking. &nbsp;[Param List][ecomparams]<br /><br />
- `- (void) item:(NSDictionary *)params;`
   - Ecommerce Tracking (item-specific). &nbsp;[Param List][ecomparams]<br /><br />
- `- (void) social:(NSDictionary *)params;`
   - Social Network Tracking.  [Param List][socialparams]<br /><br />
- `- (void) exception:(NSDictionary *)params;`
   - Exception Tracking.  [Param List][exceptionparams]<br /><br />
- `- (void) timing:(NSDictionary *)params;`
   - User Timing Tracking.  [Param List][timingparams]<br /><br />

###### Example
Track a click event:

    [[ENGAManager sharedManager] event:@{
        @(kEventCategoryKey): @"clicks",
        @(kEventActionKey): @"usersettings",
        @(kEventLabelKey): @"usertheme",
        @(kEventValueKey): @"midnight"
    }];
    
This will track that a user selected the "midnight" theme within the settings of an application.  Again, all params are based on the context of what you're trying to do, so refer to `ENGoogleMeasurementProtocol.h` and both the [developer][devguide] and [parameter][paramguide] guides.

#### Macros
There are a few macros you can set in your application that will alter certain properties within the ENGoogleMeasurementProtocol library.
<br /><br />
###### `ENGA_NO_SSL`
By default, all requests with the measurement protocol are made over SSL.  Defining this macro will make requests transmit in the clear.
<br /><br />
###### `ENGA_NO_POST`
The recommended method for sending requests is via HTTP POST.  If your application does not support POST, define this macro and all requests will be sent via HTTP GET.  All requests sent ove HTTP GET will have a cache-busting parameter added to the tail of the query string (e.g. `&z=123456789`, so you need not implement your own)
<br /><br />
###### `ENGA_DEFAULT_QUEUE_PRIORITY`
The default NSOperationQueue priority is `NSOperationQueuePriorityVeryLow`.  Define and set this macro to any other operation queue priority if you want to change that.  

[NSOperation queue priority reference][queuepriorities]
<br /><br />
###### `ENGA_DEFAULT_THREAD_PRIORITY`
The thread priority for requests.  Can be any floating point number between `0.0` and `1.0`.  The default is `0.1`.
<br /><br />
###### `ENGA_USER_PROVIDED_OPQUEUE`
The default implementation runs each `ENGAOperation` (NSOperation) as a concurrent process inside the main operation queue (`NSOperationQueue mainQueue]`).  More often than not, these operations will occur on the main thread of your application, depending on the application's current state.

If you wish to manage your own operation queue, you can define this macro.  Note that if you do define this macro, you will need to provide the `ENGAManager` with an operation queue via the `opQueue` property.

----
[devguide]: https://developers.google.com/analytics/devguides/collection/protocol/v1/devguide
[paramguide]: https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters
[pageviewparams]: https://developers.google.com/analytics/devguides/collection/protocol/v1/devguide#page
[eventparams]: https://developers.google.com/analytics/devguides/collection/protocol/v1/devguide#event
[apptrackingparams]: https://developers.google.com/analytics/devguides/collection/protocol/v1/devguide#apptracking
[ecomparams]: https://developers.google.com/analytics/devguides/collection/protocol/v1/devguide#ecom
[socialparams]: https://developers.google.com/analytics/devguides/collection/protocol/v1/devguide#social
[exceptionparams]: https://developers.google.com/analytics/devguides/collection/protocol/v1/devguide#exception
[timingparams]: https://developers.google.com/analytics/devguides/collection/protocol/v1/devguide#usertiming
[queuepriorities]: https://developer.apple.com/library/mac/documentation/cocoa/reference/NSOperation_class/Reference/Reference.html#//apple_ref/doc/constant_group/Operation_Priorities

