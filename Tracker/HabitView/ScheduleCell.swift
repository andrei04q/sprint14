import UIKit

final class ScheduleCell: UITableViewCell {
    
    static let reuseIdentifier: String = "ScheduleCell"
    
    var onSwitchChanged: ((Bool) -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: TrackerFont.medium.rawValue, size: 17)
        label.textColor = .ypBlack
        return label
    }()
    
    private let switchControl: UISwitch = {
       let switchView = UISwitch()
        switchView.onTintColor = .launchScreen
        return switchView
    }()
    
    private let bottomDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .nameTrackerText
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addTableViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func switchChanged() {
        onSwitchChanged?(switchControl.isOn)
    }

    
    private func addTableViewCell() {
        
        switchControl.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        backgroundColor = .clear
        contentView.layer.masksToBounds = true

        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(bottomDivider)
        contentView.addSubview(switchControl)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomDivider.translatesAutoresizingMaskIntoConstraints = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            switchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            bottomDivider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bottomDivider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bottomDivider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomDivider.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    func configure(title: String, isOn: Bool, showDivider: Bool) {
        titleLabel.text = title
        bottomDivider.isHidden = !showDivider
        switchControl.isOn = isOn
    }
}
