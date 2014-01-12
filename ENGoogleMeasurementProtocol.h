//
//  ENGoogleMeasurementProtocol.h
//  ENGoogleMeasurementProtocol
//
//  Created by Steve High on 1/7/14.
//  Copyright (c) 2014 Evilnode Software. All rights reserved.
//

#ifndef ENGoogleMeasurementProtocol_ENGoogleMeasurementProtocol_h
#define ENGoogleMeasurementProtocol_ENGoogleMeasurementProtocol_h

#define ENGA_VERSION @"0.0.1"
#define ENGA_USERAGENT_STRING @"Evilnode GMP Lib"
#define ENGA_CID_NAME @"ENGAV0.0.1USERTOKEN"
#define ENGA_ENDPOINT_SSL @"https://ssl.google-analytics.com/collect"
#define ENGA_ENDPOINT_NO_SSL @"http://www.google-analytics.com/collect"

typedef enum {
    kVersionKey,
    kHitTypeKey,
    kTrackingIDKey,
    kClientIDKey,
    kCampaignNameKey,
    kCampaignSourceKey,
    kCampaignMediumKey,
    kCampaignKeywordKey,
    kCampaignContentKey,
    kCampaignIDKey,
    kAdwordsIDKey,
    kDisplayAdsIDKey,
    kShouldAnonymizeIPKey,
    kShouldUseSessionControlKey,
    kScreenResolutionKey,
    kViewportSizeKey,
    kDocumentEncodingKey,
    kScreenColorsKey,
    kUserLanguageKey,
    kAppNameKey,
    kAppVersionKey,
    kTransactionIDKey,
    kTransactionAffiliationKey,
    kTransactionRevenueKey,
    kTransactionShippingKey,
    kTransactionTaxKey,
    kNonInteractiveHitKey,
    kContentDescriptionKey,
    kLinkIDKey,
    kEventCategoryKey,
    kEventActionKey,
    kEventLabelKey,
    kEventValueKey,
    kItemNameKey,
    kItemPriceKey,
    kItemQuantityKey,
    kItemCodeKey,
    kItemCategoryKey,
    kCurrencyCodeKey,
    kSocialNetworkKey,
    kSocialActionKey,
    kSocialActionTargetKey,
    kUserTimingCategoryKey,
    kUserTimingVariableNameKey,
    kUserTimingTimeKey,
    kUserTimingLabelKey,
    kPageLoadTimeKey,
    kDNSTimeKey,
    kPageDownloadTimeKey,
    kRedirectResponseTimeKey,
    kTCPConnectTimeKey,
    kServerResponseTimeKey,
    kExceptionDescriptionKey,
    kExceptionFatalKey,
    kExperimentIDKey,
    kExperimentVariantKey,
    kReservedUserAgentKey,
    kReservedUserDefinedHeaderKey
} ENGAParamKey;

typedef enum {
    kHitTypePageView,
    kHitTypeAppView,
    kHitTypeEvent,
    kHitTypeTransaction,
    kHitTypeItem,
    kHitTypeSocial,
    kHitTypeException,
    kHitTypeTiming
} ENGAHitType;

#import "ENGAManager.h"

#endif
