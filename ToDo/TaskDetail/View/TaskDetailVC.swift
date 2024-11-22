import UIKit
import SnapKit

protocol TaskDetailViewProtocol: AnyObject {
    func loadTaskInfo(task: CoreDataToDoTask)
    func taskDidUpdate()
}

class TaskDetailVC: UIViewController {
    var presenter: TaskDetailPresenterProtocol?
    var task: CoreDataToDoTask?
    
    private var titleTextViewHeightConstraint: Constraint?
    private var descriptionTextViewHeightConstraint: Constraint?

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back_icon"), for: .normal)
        button.layer.masksToBounds = false
        button.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        return button
    }()
    private lazy var backLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .update
        label.text = "Назад"
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBack)))
        return label
    }()

    private lazy var titleTextField: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = UIFont.boldSystemFont(ofSize: 34)
        textView.textColor = .white
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .white
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .searchGray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    private var originalTitle: String?
    private var originalDescription: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter?.viewDidLoaded()
        updateTitleTextViewHeight()
        updateDescTextViewHeight()
        hideKeyboardWhenTappedAround()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    private func setupViews() {
        view.backgroundColor = .black
        
        view.addSubviews(closeButton,backLabel, titleTextField, descriptionTextView, editButton, dateLabel)
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(65)
            make.left.equalToSuperview().offset(8)
            make.height.width.equalTo(22)
        }
        backLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(67)
            make.left.equalTo(closeButton.snp.right).offset(6)
        }

        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(backLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            self.titleTextViewHeightConstraint = make.height.equalTo(0).priority(UILayoutPriority(250)).constraint
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(24)
        }
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            self.descriptionTextViewHeightConstraint = make.height.equalTo(0).priority(UILayoutPriority(250)).constraint
        }
        
        editButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.width.equalTo(300)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
        }
    }
    
    @objc private func textDidChange() {
        guard let title = titleTextField.text, let description = descriptionTextView.text else { return }
        editButton.isHidden = (title == originalTitle && description == originalDescription)
    }
    
    private func updateTitleTextViewHeight() {
        let size = CGSize(width: titleTextField.frame.width, height: CGFloat.greatestFiniteMagnitude)
        let estimatedSize = titleTextField.sizeThatFits(size)
        titleTextViewHeightConstraint?.update(offset: estimatedSize.height)
        view.layoutIfNeeded()
    }
    private func updateDescTextViewHeight() {
        let size = CGSize(width: descriptionTextView.frame.width, height: CGFloat.greatestFiniteMagnitude)
        let estimatedSize = descriptionTextView.sizeThatFits(size)
        descriptionTextViewHeightConstraint?.update(offset: estimatedSize.height)
        view.layoutIfNeeded()
    }
    @objc private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func saveTask() {
        guard let title = titleTextField.text, let description = descriptionTextView.text else { return }
        presenter?.saveTaskChanges(title: title, description: description)
        editButton.isHidden = true
    }
}

extension TaskDetailVC: TaskDetailViewProtocol {
    func taskDidUpdate() {
        editButton.isHidden = true
    }
    
    func loadTaskInfo(task: CoreDataToDoTask) {
        self.task = task
        titleTextField.text = task.todo
        descriptionTextView.text = task.descrip
        updateTitleTextViewHeight()
        updateDescTextViewHeight()

        if let date = task.date {
            dateLabel.text = "\(date)"
        } else {
            dateLabel.text = "Дата создания: Неизвестно"
        }
        if task.completed {
            titleTextField.isUserInteractionEnabled = false
            descriptionTextView.isUserInteractionEnabled = false
        }

        originalTitle = task.todo
        originalDescription = task.descrip
        
    }
}

extension TaskDetailVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textDidChange()
        updateTitleTextViewHeight()
        updateDescTextViewHeight()
    }
}
