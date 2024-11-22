import UIKit
import SnapKit

class MainCell: UITableViewCell, UIContextMenuInteractionDelegate {
    
    //MARK: - Properties
    var tapAction: (()->())?
    var deleteAction: (()->())?
    var shareAction: (()->())?
    var editAction: (()->())?
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = false
        button.addTarget(self, action: #selector(tapFinish), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkWhite
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = .grayColour
        return view
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
        let interaction = UIContextMenuInteraction(delegate: self)
        contentView.addInteraction(interaction)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Prepare For Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
        titleLabel.text = nil
        titleLabel.textColor = .white
        descriptionLabel.textColor = .white
        dateLabel.text = nil
        checkButton.setImage(nil, for: .normal)
    }
    
    //MARK: - Setup Views
    private func setupViews() {
        contentView.isUserInteractionEnabled = true
        contentView.backgroundColor = .black
        backgroundColor = .black
        selectionStyle = .none
        
        contentView.addSubview(checkButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(line)
        
        checkButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(12)
            make.size.equalTo(24)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(checkButton.snp.right).offset(8)
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-16)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalToSuperview().offset(-16)
        }
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(78)
        }
        line.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: - ContextMenu
    
    @available(iOS 13.0, *)
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let editAction = UIAction(title: "Редактировать", image: UIImage(named: "edit_icon")) { action in
                self.tapEdit()
            }
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share_icon")) { action in
                self.tapShare()
            }
            let deleteAction = UIAction(title: "Удалить", image: UIImage(named: "delete_icon"), attributes: .destructive) { action in
                self.tapDelete()
            }
            return UIMenu(title: "", children: [editAction,shareAction, deleteAction])
        }
    }
    
    @available(iOS 13.0, *)
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willDisplayMenuFor configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        changeAppearanceForContextMenu()
    }
    
    @available(iOS 13.0, *)
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willEndFor configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        resetAppearance()
    }
    
    
    //MARK: - Actions
    
    func configure(model: CoreDataToDoTask) {
        titleLabel.text = model.todo
        descriptionLabel.text = model.descrip
        if let date = model.date {
            dateLabel.text = "\(date)"
        } else {
            dateLabel.text = "Дата создания: Неизвестно"
        }
        
        if model.completed {
            checkButton.setImage(UIImage(named: "check"), for: .normal)
            descriptionLabel.textColor = .grayColour
            
            let attributedString = NSAttributedString(
                string: titleLabel.text ?? "",
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.grayColour
                ]
            )
            titleLabel.attributedText = attributedString
            
        } else {
            checkButton.setImage(UIImage(named: "not_check"), for: .normal)
            titleLabel.textColor = .white
            descriptionLabel.textColor = .white
            
            titleLabel.attributedText = nil
            titleLabel.text = model.todo
        }
    }
    
    func changeAppearanceForContextMenu() {
        titleLabel.snp.updateConstraints { make in
            make.left.equalTo(checkButton.snp.right).offset(-20)
        }
        line.isHidden = true
        checkButton.isHidden = true
        contentView.backgroundColor = .searchGray
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func resetAppearance() {
        contentView.backgroundColor = .black
        
        titleLabel.snp.updateConstraints { make in
            make.left.equalTo(checkButton.snp.right).offset(8)
        }
        line.isHidden = false
        checkButton.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    //MARK: Actions of ContextMenu
    @objc private func tapFinish() {
        tapAction?()
    }
    private func tapDelete() {
        deleteAction?()
    }
    private func tapShare() {
        shareAction?()
    }
    private func tapEdit() {
        editAction?()
    }
}
