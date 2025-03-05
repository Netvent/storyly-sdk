import UIKit


internal func getCustomFont(
    typeface: String,
    fontSize: CGFloat
) -> UIFont? {
    let fontName = (typeface as NSString).deletingPathExtension
    guard let font = UIFont(name: fontName, size: fontSize) else { return nil }
    return font
}


internal func getCustomFont(
    typeface: NSString?,
    fontSize: CGFloat,
    defaultWeight: UIFont.Weight = .regular
) -> UIFont {
    if let fontName = typeface?.deletingPathExtension,
       let font = UIFont(name: fontName, size: fontSize) { return font }
    return .systemFont(ofSize: fontSize, weight: defaultWeight)
}

extension UIViewController {
    internal func getPresentedViewController() -> UIViewController? {
        guard let vc = self.presentedViewController else {
            return self
        }
        return vc.getPresentedViewController()
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let start = hexString.index(hexString.startIndex, offsetBy: 1)
        let hexColor = String(hexString[start...])
        
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 1
        scanner.scanHexInt64(&hexNumber)
        
        let red, green, blue, alpha: CGFloat
        if hexString.count == 9 {
            alpha = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            red = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            green = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            blue = CGFloat(hexNumber & 0x000000ff) / 255
        } else {
            red = CGFloat((hexNumber & 0xff0000) >> 16) / 255
            green = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
            blue = CGFloat(hexNumber & 0x0000ff) / 255
            alpha = 1
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
