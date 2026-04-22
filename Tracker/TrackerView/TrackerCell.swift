import UIKit

protocol TrackerCellDelegate: AnyObject {
    func trackerCellDidTapQuantityButton(_ cell: TrackerCell)
}

enum TrackerFont: String {
    case medium = "SFProDisplay-Medium"
    case bold = "SFProDisplay-Bold"
    case regular = "SFProRounded-Regular"
}

final class TrackerCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "TrackerCell"
    
    weak var delegate: TrackerCellDelegate?
    
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(resource: .borderColorView).cgColor
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .ypWhiteAndGrey
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emojiCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhiteAndGrey
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: TrackerFont.medium.rawValue, size: 12)
        label.textColor = UIColor(resource: .ypWhite)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quantityManagementView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: TrackerFont.medium.rawValue, size: 12)
        label.textColor = UIColor(resource: .ypBlack)
        label.text = "0 дней"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quantityButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(resource: .sectionColorGreen)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 17
        button.clipsToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        
        contentView.addSubview(colorView)
        contentView.addSubview(emojiCircleView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(quantityManagementView)
        emojiCircleView.addSubview(emojiLabel)
        
        quantityManagementView.addSubview(quantityLabel)
        quantityManagementView.addSubview(quantityButton)
        
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiCircleView.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            emojiCircleView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            emojiCircleView.heightAnchor.constraint(equalToConstant: 24),
            emojiCircleView.widthAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiCircleView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiCircleView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: colorView.bottomAnchor, constant: -12),
            
            quantityManagementView.topAnchor.constraint(equalTo: colorView.bottomAnchor),
            quantityManagementView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            quantityManagementView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            quantityManagementView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            quantityManagementView.heightAnchor.constraint(equalToConstant: 58),
            
            quantityLabel.centerYAnchor.constraint(equalTo: quantityManagementView.centerYAnchor),
            quantityLabel.leadingAnchor.constraint(equalTo: quantityManagementView.leadingAnchor, constant: 12),
            
            quantityButton.centerYAnchor.constraint(equalTo: quantityManagementView.centerYAnchor),
            quantityButton.trailingAnchor.constraint(equalTo: quantityManagementView.trailingAnchor, constant: -12),
            quantityButton.widthAnchor.constraint(equalToConstant: 34),
            quantityButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    func configure(with tracker: Tracker, countDays: Int, isCompleted: Bool) {
        titleLabel.text = tracker.name
        emojiLabel.text = tracker.emoji
        colorView.backgroundColor = tracker.color.uiColor
        quantityLabel.text = "\(countDays) дней"
        
        if isCompleted {
            quantityButton.setTitle("✓", for: .normal)
            quantityButton.backgroundColor = .completedCountButton
            quantityButton.setTitleColor(.ypWhite, for: .normal)
            quantityLabel.text = "\(countDays) день"
        } else {
            quantityButton.setTitle("+", for: .normal)
            quantityButton.backgroundColor = tracker.color.uiColor
            quantityButton.setTitleColor(.ypWhite, for: .normal)
        }
        
        quantityButton.addTarget(self, action: #selector(quantityButtonTapped), for: .touchUpInside)
    }
    
    @objc private func quantityButtonTapped() {
        delegate?.trackerCellDidTapQuantityButton(self)
    }
}

extension TrackerColor {
    var uiColor: UIColor {
        switch self {
        case .red: return .systemRed
        case .blue: return .systemBlue
        case .green: return .sectionColorGreen
        }
    }
}
