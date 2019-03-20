
import UIKit

@IBDesignable class RoundedButton: UIButton {

    @IBInspectable var cornerRadius:CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defer {
            cornerRadius = 10.0
        }
    }
    
    override func prepareForInterfaceBuilder() {
        cornerRadius = 10.0
    }

}
