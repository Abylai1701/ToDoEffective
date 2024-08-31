import Foundation
import UIKit
import SnapKit

protocol CreateTaskVCProtocol: AnyObject {
    func taskCreatedSuccessfully()
}

final class CreateTaskVC: UIViewController {
    
    //MARK: - Properties
    var presenter: CreateTaskPresenterProtocol?
    private var viewTranslation = CGPoint(x: 0, y: 0)
    private let maxCharacters = 150
    
    lazy var blurEffectMenu: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectMenu = UIVisualEffectView(effect: blurEffect)
        blurEffectMenu.frame = view.bounds
        blurEffectMenu.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectMenu.alpha = 0.85
        return blurEffectMenu
    }()
    
    private lazy var container: UIView = {
        let container = UIView()
        container.backgroundColor = .white
        container.clipsToBounds = true
        container.layer.cornerRadius = 20
        container.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        container.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleSwipeGesture)))
        return container
    }()
    
    private lazy var topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayColour4
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 6
        return view
    }()
    private lazy var yourEstimateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Новая задача"
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var aboutTextView = PlaceholderTextView(frame: .zero)
    private lazy var aboutTextView2 = PlaceholderTextView(frame: .zero)
    
    private lazy var characterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayColour
        label.text = "0/150"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.layer.cornerRadius = 16
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.titleLabel?.textColor = .white
        button.addTarget(self,
                         action: #selector(createTask),
                         for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = .clear
        view.addSubview(blurEffectMenu)
        blurEffectMenu.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        aboutTextView.placeholder = "Опишите задачу"
        aboutTextView2.placeholder = "Название задачи"
        
        view.addSubview(container)
        container.addSubviews(
            topLineView,
            yourEstimateLabel,
            aboutTextView2,
            aboutTextView,
            characterCountLabel,
            sendButton
        )
        container.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 0.5)
        }
        
        topLineView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalTo(36)
        }
        yourEstimateLabel.snp.makeConstraints { make in
            make.top.equalTo(topLineView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        aboutTextView2.snp.makeConstraints { make in
            make.top.equalTo(yourEstimateLabel.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(60)
        }
        aboutTextView.snp.makeConstraints { make in
            make.top.equalTo(aboutTextView2.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(60)
        }
        characterCountLabel.snp.makeConstraints { make in
            make.top.equalTo(aboutTextView.snp.bottom).offset(8)
            make.right.equalToSuperview().offset(-16)
        }
        aboutTextView.characterAction = { [weak self] in
            self?.updateCharacterCount()
        }
        sendButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(52)
        }
    }
    
    //MARK: - Actions
    private func updateCharacterCount() {
        let count = aboutTextView.text.count
        characterCountLabel.text = "\(count)/\(maxCharacters)"
    }
    
    @objc func createTask() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        let dateString = dateFormatter.string(from: today)

        guard !aboutTextView2.text.isEmpty else { return }
        
        let task = NewTodo(title: aboutTextView2.text ?? "", description: aboutTextView.text ?? "", completed: false, date: dateString)
        presenter?.createTask(task: task) { [weak self] in
            self?.presenter?.dismissCreateTask()
        }
    }
    
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    @objc func hiddenHomeVC() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: self.view.frame.height)
        }) { _ in
            self.blurEffectMenu.removeFromSuperview()
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
    @objc private func handleSwipeGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            let translation = sender.translation(in: container)
            if translation.y > 0 {
                viewTranslation = translation
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.container.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                }, completion: nil)
            }
        case .ended:
            if viewTranslation.y > 50 {
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.backgroundColor = .clear
                }, completion: { _ in
                    self.dismiss(animated: true, completion: nil)
                })
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.container.transform = .identity
                }, completion: nil)
            }
        default:
            break
        }
    }
}

extension CreateTaskVC: CreateTaskVCProtocol {
    func taskCreatedSuccessfully() {
        dismiss(animated: true)
    }
}
