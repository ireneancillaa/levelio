import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

    /// The "primary" asset catalog color resource.
    static let primary = DeveloperToolsSupport.ColorResource(name: "primary", bundle: resourceBundle)

    /// The "secondary" asset catalog color resource.
    static let secondary = DeveloperToolsSupport.ColorResource(name: "secondary", bundle: resourceBundle)

    /// The "tertiary" asset catalog color resource.
    static let tertiary = DeveloperToolsSupport.ColorResource(name: "tertiary", bundle: resourceBundle)

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "ava-1" asset catalog image resource.
    static let ava1 = DeveloperToolsSupport.ImageResource(name: "ava-1", bundle: resourceBundle)

    /// The "background" asset catalog image resource.
    static let background = DeveloperToolsSupport.ImageResource(name: "background", bundle: resourceBundle)

    /// The "dart" asset catalog image resource.
    static let dart = DeveloperToolsSupport.ImageResource(name: "dart", bundle: resourceBundle)

    /// The "dino-adult-blue" asset catalog image resource.
    static let dinoAdultBlue = DeveloperToolsSupport.ImageResource(name: "dino-adult-blue", bundle: resourceBundle)

    /// The "dino-baby-blue" asset catalog image resource.
    static let dinoBabyBlue = DeveloperToolsSupport.ImageResource(name: "dino-baby-blue", bundle: resourceBundle)

    /// The "dino-book" asset catalog image resource.
    static let dinoBook = DeveloperToolsSupport.ImageResource(name: "dino-book", bundle: resourceBundle)

    /// The "dino-car" asset catalog image resource.
    static let dinoCar = DeveloperToolsSupport.ImageResource(name: "dino-car", bundle: resourceBundle)

    /// The "dino-curious" asset catalog image resource.
    static let dinoCurious = DeveloperToolsSupport.ImageResource(name: "dino-curious", bundle: resourceBundle)

    /// The "dino-egg-blue" asset catalog image resource.
    static let dinoEggBlue = DeveloperToolsSupport.ImageResource(name: "dino-egg-blue", bundle: resourceBundle)

    /// The "dino-hatch-blue" asset catalog image resource.
    static let dinoHatchBlue = DeveloperToolsSupport.ImageResource(name: "dino-hatch-blue", bundle: resourceBundle)

    /// The "dino-mountain" asset catalog image resource.
    static let dinoMountain = DeveloperToolsSupport.ImageResource(name: "dino-mountain", bundle: resourceBundle)

    /// The "dino-premium" asset catalog image resource.
    static let dinoPremium = DeveloperToolsSupport.ImageResource(name: "dino-premium", bundle: resourceBundle)

    /// The "dino-selfies" asset catalog image resource.
    static let dinoSelfies = DeveloperToolsSupport.ImageResource(name: "dino-selfies", bundle: resourceBundle)

    /// The "google-logo" asset catalog image resource.
    static let googleLogo = DeveloperToolsSupport.ImageResource(name: "google-logo", bundle: resourceBundle)

    /// The "speech-bubble" asset catalog image resource.
    static let speechBubble = DeveloperToolsSupport.ImageResource(name: "speech-bubble", bundle: resourceBundle)

    /// The "unlock" asset catalog image resource.
    static let unlock = DeveloperToolsSupport.ImageResource(name: "unlock", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// The "primary" asset catalog color.
    static var primary: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .primary)
#else
        .init()
#endif
    }

    /// The "secondary" asset catalog color.
    static var secondary: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .secondary)
#else
        .init()
#endif
    }

    /// The "tertiary" asset catalog color.
    static var tertiary: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tertiary)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// The "primary" asset catalog color.
    static var primary: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .primary)
#else
        .init()
#endif
    }

    /// The "secondary" asset catalog color.
    static var secondary: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .secondary)
#else
        .init()
#endif
    }

    /// The "tertiary" asset catalog color.
    static var tertiary: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .tertiary)
#else
        .init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    #warning("The \"primary\" color asset name resolves to a conflicting Color symbol \"primary\". Try renaming the asset.")

    #warning("The \"secondary\" color asset name resolves to a conflicting Color symbol \"secondary\". Try renaming the asset.")

    /// The "tertiary" asset catalog color.
    static var tertiary: SwiftUI.Color { .init(.tertiary) }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    /// The "tertiary" asset catalog color.
    static var tertiary: SwiftUI.Color { .init(.tertiary) }

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "ava-1" asset catalog image.
    static var ava1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ava1)
#else
        .init()
#endif
    }

    /// The "background" asset catalog image.
    static var background: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .background)
#else
        .init()
#endif
    }

    /// The "dart" asset catalog image.
    static var dart: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dart)
#else
        .init()
#endif
    }

    /// The "dino-adult-blue" asset catalog image.
    static var dinoAdultBlue: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dinoAdultBlue)
#else
        .init()
#endif
    }

    /// The "dino-baby-blue" asset catalog image.
    static var dinoBabyBlue: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dinoBabyBlue)
#else
        .init()
#endif
    }

    /// The "dino-book" asset catalog image.
    static var dinoBook: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dinoBook)
#else
        .init()
#endif
    }

    /// The "dino-car" asset catalog image.
    static var dinoCar: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dinoCar)
#else
        .init()
#endif
    }

    /// The "dino-curious" asset catalog image.
    static var dinoCurious: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dinoCurious)
#else
        .init()
#endif
    }

    /// The "dino-egg-blue" asset catalog image.
    static var dinoEggBlue: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dinoEggBlue)
#else
        .init()
#endif
    }

    /// The "dino-hatch-blue" asset catalog image.
    static var dinoHatchBlue: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dinoHatchBlue)
#else
        .init()
#endif
    }

    /// The "dino-mountain" asset catalog image.
    static var dinoMountain: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dinoMountain)
#else
        .init()
#endif
    }

    /// The "dino-premium" asset catalog image.
    static var dinoPremium: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dinoPremium)
#else
        .init()
#endif
    }

    /// The "dino-selfies" asset catalog image.
    static var dinoSelfies: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dinoSelfies)
#else
        .init()
#endif
    }

    /// The "google-logo" asset catalog image.
    static var googleLogo: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .googleLogo)
#else
        .init()
#endif
    }

    /// The "speech-bubble" asset catalog image.
    static var speechBubble: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .speechBubble)
#else
        .init()
#endif
    }

    /// The "unlock" asset catalog image.
    static var unlock: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .unlock)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "ava-1" asset catalog image.
    static var ava1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ava1)
#else
        .init()
#endif
    }

    /// The "background" asset catalog image.
    static var background: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .background)
#else
        .init()
#endif
    }

    /// The "dart" asset catalog image.
    static var dart: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dart)
#else
        .init()
#endif
    }

    /// The "dino-adult-blue" asset catalog image.
    static var dinoAdultBlue: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dinoAdultBlue)
#else
        .init()
#endif
    }

    /// The "dino-baby-blue" asset catalog image.
    static var dinoBabyBlue: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dinoBabyBlue)
#else
        .init()
#endif
    }

    /// The "dino-book" asset catalog image.
    static var dinoBook: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dinoBook)
#else
        .init()
#endif
    }

    /// The "dino-car" asset catalog image.
    static var dinoCar: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dinoCar)
#else
        .init()
#endif
    }

    /// The "dino-curious" asset catalog image.
    static var dinoCurious: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dinoCurious)
#else
        .init()
#endif
    }

    /// The "dino-egg-blue" asset catalog image.
    static var dinoEggBlue: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dinoEggBlue)
#else
        .init()
#endif
    }

    /// The "dino-hatch-blue" asset catalog image.
    static var dinoHatchBlue: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dinoHatchBlue)
#else
        .init()
#endif
    }

    /// The "dino-mountain" asset catalog image.
    static var dinoMountain: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dinoMountain)
#else
        .init()
#endif
    }

    /// The "dino-premium" asset catalog image.
    static var dinoPremium: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dinoPremium)
#else
        .init()
#endif
    }

    /// The "dino-selfies" asset catalog image.
    static var dinoSelfies: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dinoSelfies)
#else
        .init()
#endif
    }

    /// The "google-logo" asset catalog image.
    static var googleLogo: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .googleLogo)
#else
        .init()
#endif
    }

    /// The "speech-bubble" asset catalog image.
    static var speechBubble: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .speechBubble)
#else
        .init()
#endif
    }

    /// The "unlock" asset catalog image.
    static var unlock: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .unlock)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ColorResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ImageResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

