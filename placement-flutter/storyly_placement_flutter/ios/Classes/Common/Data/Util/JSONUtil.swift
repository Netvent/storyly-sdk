import Foundation

internal func encodeToJson(_ dictionary: [String: Any?]) -> String? {
  let filtered = dictionary.compactMapValues { $0 }

  guard let jsonData = try? JSONSerialization.data(withJSONObject: filtered, options: []) else {
    print("[SPStorylyPlacement] SP bridge JSON encode error)")
    return nil
  }
  return String(data: jsonData, encoding: .utf8)
}


internal func decodeFromJson(_ json: String?) -> [String: Any]? {
  guard let json = json,
        let jsonData = json.data(using: .utf8) else {
    return nil
  }
  
  do {
    if let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
      return dictionary
    }
    print("[SPStorylyPlacement] SP bridge JSON decode error: Not a dictionary")
    return nil
  } catch {
    print("[SPStorylyPlacement] SP bridge JSON decode error: \(error.localizedDescription)")
    return nil
  }
}


internal extension UIColor {
    convenience init?(hexString: String?) {
        guard let hexString = hexString else { return nil }

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
    
    func toHexString() -> String {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let rgb = (Int)(alpha * 255) << 24 |
            (Int)(red * 255) << 16 |
            (Int)(green * 255) << 8 |
            (Int)(blue * 255) << 0
        return String(format: "#%08x", rgb)
    }
}

