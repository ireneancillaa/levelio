#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"com.gmail.ireneancilla.Levelio";

/// The "primary" asset catalog color resource.
static NSString * const ACColorNamePrimary AC_SWIFT_PRIVATE = @"primary";

/// The "secondary" asset catalog color resource.
static NSString * const ACColorNameSecondary AC_SWIFT_PRIVATE = @"secondary";

/// The "tertiary" asset catalog color resource.
static NSString * const ACColorNameTertiary AC_SWIFT_PRIVATE = @"tertiary";

/// The "ava-1" asset catalog image resource.
static NSString * const ACImageNameAva1 AC_SWIFT_PRIVATE = @"ava-1";

/// The "background" asset catalog image resource.
static NSString * const ACImageNameBackground AC_SWIFT_PRIVATE = @"background";

/// The "dart" asset catalog image resource.
static NSString * const ACImageNameDart AC_SWIFT_PRIVATE = @"dart";

/// The "dino-adult-blue" asset catalog image resource.
static NSString * const ACImageNameDinoAdultBlue AC_SWIFT_PRIVATE = @"dino-adult-blue";

/// The "dino-baby-blue" asset catalog image resource.
static NSString * const ACImageNameDinoBabyBlue AC_SWIFT_PRIVATE = @"dino-baby-blue";

/// The "dino-book" asset catalog image resource.
static NSString * const ACImageNameDinoBook AC_SWIFT_PRIVATE = @"dino-book";

/// The "dino-car" asset catalog image resource.
static NSString * const ACImageNameDinoCar AC_SWIFT_PRIVATE = @"dino-car";

/// The "dino-curious" asset catalog image resource.
static NSString * const ACImageNameDinoCurious AC_SWIFT_PRIVATE = @"dino-curious";

/// The "dino-egg-blue" asset catalog image resource.
static NSString * const ACImageNameDinoEggBlue AC_SWIFT_PRIVATE = @"dino-egg-blue";

/// The "dino-hatch-blue" asset catalog image resource.
static NSString * const ACImageNameDinoHatchBlue AC_SWIFT_PRIVATE = @"dino-hatch-blue";

/// The "dino-mountain" asset catalog image resource.
static NSString * const ACImageNameDinoMountain AC_SWIFT_PRIVATE = @"dino-mountain";

/// The "dino-premium" asset catalog image resource.
static NSString * const ACImageNameDinoPremium AC_SWIFT_PRIVATE = @"dino-premium";

/// The "dino-selfies" asset catalog image resource.
static NSString * const ACImageNameDinoSelfies AC_SWIFT_PRIVATE = @"dino-selfies";

/// The "google-logo" asset catalog image resource.
static NSString * const ACImageNameGoogleLogo AC_SWIFT_PRIVATE = @"google-logo";

/// The "speech-bubble" asset catalog image resource.
static NSString * const ACImageNameSpeechBubble AC_SWIFT_PRIVATE = @"speech-bubble";

/// The "unlock" asset catalog image resource.
static NSString * const ACImageNameUnlock AC_SWIFT_PRIVATE = @"unlock";

#undef AC_SWIFT_PRIVATE
