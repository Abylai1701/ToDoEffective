import UIKit

protocol TaskDetailViewProtocol: AnyObject {
    func loadTaskInfo(task: CoreDataToDoTask)
    func updateDoneButton()
}

class TaskDetailVC: UIViewController {
    var presenter: TaskDetailPresenterProtocol?
    var task: CoreDataToDoTask?
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "exit_icon"), for: .normal)
        button.layer.masksToBounds = false
        button.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "delete_icon"), for: .normal)
        button.layer.masksToBounds = false
        button.addTarget(self, action: #selector(tapDelete), for: .touchUpInside)
        return button
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
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(tapDone), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Title"
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5.0
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.delegate = self
        return textView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()    
    
    private var originalTitle: String?
    private var originalDescription: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoaded()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubviews(closeButton, deleteButton, titleTextField, descriptionTextView, doneButton, editButton, dateLabel)
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.left.equalToSuperview().offset(24)
            make.height.width.equalTo(22)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(68)
            make.right.equalToSuperview().offset(-24)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(deleteButton.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(40)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(150)
        }
        
        editButton.snp.makeConstraints { make in
            make.bottom.equalTo(doneButton.snp.top).offset(-24)
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
        }
        
        doneButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.width.equalTo(250)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(24)
        }
        guard let task = task else { return }
        if let date = task.date {
            dateLabel.text = "Дата создания: \(date)"
        } else {
            dateLabel.text = "Дата создания: Неизвестно"
        }
        if task.completed {
            doneButton.isHidden = true
            titleTextField.isUserInteractionEnabled = false
            descriptionTextView.isUserInteractionEnabled = false
        } else {
            doneButton.setTitle("Отметить как завершено", for: .normal)
            doneButton.isHidden = false
        }
        
        titleTextField.text = task.todo
        descriptionTextView.text = task.descrip
        
        originalTitle = task.todo
        originalDescription = task.descrip
    }
    
    @objc private func textDidChange() {
        guard let title = titleTextField.text, let description = descriptionTextView.text else { return }
        editButton.isHidden = (title == originalTitle && description == originalDescription)
    }
    
    @objc private func tapBack() {
        dismiss(animated: true)
    }
    
    @objc private func tapDelete() {
        presenter?.taskWillDelete()
    }
    
    @objc private func tapDone() {
        presenter?.taskWillDone()
    }
    
    @objc private func saveTask() {
        guard let title = titleTextField.text, let description = descriptionTextView.text else { return }
        presenter?.saveTaskChanges(title: title, description: description)
        editButton.isHidden = true
    }
}

extension TaskDetailVC: TaskDetailViewProtocol {
    func updateDoneButton() {
        dismiss(animated: true)
    }
    
    func loadTaskInfo(task: CoreDataToDoTask) {
        self.task = task
        titleTextField.text = task.todo
        descriptionTextView.text = task.descrip
    }
}

extension TaskDetailVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textDidChange()
    }
}
