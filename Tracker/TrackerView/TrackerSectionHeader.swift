import UIKit

final class TrackerSectionHeader: UICollectionReusableView {
    static let reuseIdentifier = "TrackerSectionHeader"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: TrackerFont.bold.rawValue, size: 19)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 12),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withTitle title: String) {
        titleLabel.text = title
    }
}
