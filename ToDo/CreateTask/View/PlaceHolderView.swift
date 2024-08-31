import UIKit

class PlaceholderTextView: UITextView, UITextViewDelegate{
    
    var characterAction: (() -> ())?
    
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            placeholderLabel.sizeToFit()
        }
    }
    private let maxCharacters = 150
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayColour
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.isHidden = false
        return label
    }()
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = "0/150"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupPlaceholder()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlaceholder()
    }
    
    private func setupPlaceholder() {
        backgroundColor = .grayColour1
        layer.cornerRadius = 16
        addSubview(placeholderLabel)
        
        placeholderLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
        }
        
        textContainerInset = UIEdgeInsets(top: 30, left: 10, bottom: 10, right: 10)
        font = UIFont.systemFont(ofSize: 16)
        textColor = .black
        textAlignment = .left
        delegate = self
        returnKeyType = .done
        isScrollEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc private func textDidChange() {
        checkForSizeAdjustment()
        characterAction?()
    }
    
    private func checkForSizeAdjustment() {
        let size = sizeThatFits(CGSize(width: frame.width, height: CGFloat.infinity))
        if frame.height != size.height {
            UIView.animate(withDuration: 0.2) {
                self.snp.updateConstraints { make in
                    make.height.equalTo(size.height)
                }
                self.superview?.layoutIfNeeded()
            }
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        animatePlaceholder(up: true)
        return result
    }
    
    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        animatePlaceholder(up: false)
        return result
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= maxCharacters
    }
    private func animatePlaceholder(up: Bool) {
        UIView.animate(withDuration: 0.3) {
            if up {
                if self.text.isEmpty {
                    self.placeholderLabel.transform = CGAffineTransform(translationX: 0, y: -self.bounds.height / 2 + self.placeholderLabel.frame.height)
                    self.placeholderLabel.font = UIFont.systemFont(ofSize: 14)
                }
            } else {
                if self.text.isEmpty {
                    self.placeholderLabel.transform = .identity
                    self.placeholderLabel.font = UIFont.systemFont(ofSize: 14)
                }
            }
            self.placeholderLabel.textColor = .grayColour
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
