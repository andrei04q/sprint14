import UIKit

final class HabitViewCell: UITableViewCell {

    static let reuseIdentifier = "HabitViewCell"

    // MARK: - UI

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .nameTrackerText
        label.numberOfLines = 1
        return label
    }()

    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .accessoryType)
        imageView.tintColor = .nameTrackerText
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ypBlack.withAlphaComponent(0.1)
        return view
    }()

    private let stack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 2
        s.alignment = .leading
        return s
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(stack)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(divider)

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)

        stack.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        divider.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            // stack
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            // arrow
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 24),
            arrowImageView.heightAnchor.constraint(equalToConstant: 24),

            stack.trailingAnchor.constraint(
                lessThanOrEqualTo: arrowImageView.leadingAnchor,
                constant: -8
            ),

            // divider
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    // MARK: - Configure

    func configure(title: String, subtitle: String?, showDivider: Bool) {
        titleLabel.text = title

        if let subtitle, !subtitle.isEmpty {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.isHidden = true
        }

        divider.isHidden = !showDivider
    }
}
