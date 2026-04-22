import UIKit

final class HabitViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "HabitViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: TrackerFont.regular.rawValue, size: 17)
        label.textColor = .ypBlack
        return label
    }()
    
    private let bottomDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .nameTrackerText
        return view
    }()
    
    private let customAccessoryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .accessoryType)
        imageView.tintColor = .nameTrackerText
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: TrackerFont.regular.rawValue, size: 17)
        label.textColor = .nameTrackerText
        label.numberOfLines = 2
        return label
    }()
    
    private let verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 2
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addTableViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTableViewCell() {
        
        backgroundColor = .clear
        contentView.layer.masksToBounds = true

        selectionStyle = .none
        
        contentView.addSubview(bottomDivider)
        contentView.addSubview(customAccessoryImage)
        
        contentView.addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(subtitleLabel)
        
        bottomDivider.translatesAutoresizingMaskIntoConstraints = false
        customAccessoryImage.translatesAutoresizingMaskIntoConstraints = false
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customAccessoryImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            customAccessoryImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            customAccessoryImage.widthAnchor.constraint(equalToConstant: 24),
            customAccessoryImage.heightAnchor.constraint(equalToConstant: 24),
            
            bottomDivider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bottomDivider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bottomDivider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomDivider.heightAnchor.constraint(equalToConstant: 0.5),
            
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            verticalStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            verticalStackView.trailingAnchor.constraint(
                lessThanOrEqualTo: customAccessoryImage.leadingAnchor,
                constant: -8),
        ])
    }
    
    func configure(title: String, subtitle: String?, showDivider: Bool) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle == nil
        bottomDivider.isHidden = !showDivider
    }
}

