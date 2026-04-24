import UIKit

protocol HabitViewControllerDelegate: AnyObject {
    func didCreateTracker(_ tracker: Tracker, categoryName: String)
}

final class HabitViewController: UIViewController {

    private let rows = ["Категория", "Расписание"]
    private var selectedWeekdays: [WeekdaySchedule] = []

    weak var delegate: HabitViewControllerDelegate?

    private let maxLength = 38

    // MARK: - UI

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        return label
    }()

    private let nameTrackerTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textColor = .ypBlack
        textField.backgroundColor = .nameTrackerTextField
        textField.layer.cornerRadius = 16
        textField.clearButtonMode = .whileEditing

        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always

        return textField
    }()

    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textColor = .cancelButton
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private let tableContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .nameTrackerTextField
        view.layer.cornerRadius = 16
        return view
    }()

    private let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.isScrollEnabled = false
        return table
    }()

    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.cancelButton, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.cancelButton.cgColor
        return button
    }()

    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .nameTrackerText
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypWhite

        tableView.register(HabitViewCell.self, forCellReuseIdentifier: HabitViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self

        // 🔥 FIX Figma
        tableView.rowHeight = 75
        tableView.estimatedRowHeight = 75

        nameTrackerTextField.delegate = self
        nameTrackerTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        setupButtons()
        layout()
        updateSaveButtonState()
    }

    @objc private func textDidChange() {
        let text = nameTrackerTextField.text ?? ""
        warningLabel.isHidden = text.count < maxLength
        updateSaveButtonState()
    }

    private func setupButtons() {
        cancelButton.addTarget(self, action: #selector(addCancelAction), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }

    @objc private func saveTapped() {
        let schedule = Set(selectedWeekdays.compactMap { Weekday(rawValue: $0.rawValue) })

        let tracker = Tracker(
            id: UUID(),
            name: nameTrackerTextField.text ?? "",
            color: .green,
            emoji: "😪",
            schedule: schedule
        )

        delegate?.didCreateTracker(tracker, categoryName: "Дом")
        dismiss(animated: true)
    }

    @objc private func addCancelAction() {
        dismiss(animated: true)
    }

    private func updateSaveButtonState() {
        let isEnabled = !(nameTrackerTextField.text?.isEmpty ?? true) && !selectedWeekdays.isEmpty

        saveButton.isEnabled = isEnabled
        saveButton.backgroundColor = isEnabled ? .ypBlack : .nameTrackerText
    }

    private func layout() {
        view.addSubview(titleLabel)
        view.addSubview(nameTrackerTextField)
        view.addSubview(warningLabel)
        view.addSubview(tableContainerView)
        view.addSubview(cancelButton)
        view.addSubview(saveButton)

        tableContainerView.addSubview(tableView)

        [titleLabel, nameTrackerTextField, warningLabel,
         tableContainerView, tableView,
         cancelButton, saveButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nameTrackerTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),

            warningLabel.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 8),
            warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tableContainerView.topAnchor.constraint(equalTo: warningLabel.bottomAnchor, constant: 16),
            tableContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableContainerView.heightAnchor.constraint(equalToConstant: 150),

            tableView.topAnchor.constraint(equalTo: tableContainerView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor),

            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),

            saveButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor)
        ])
    }
}
extension HabitViewController: UITableViewDataSource,
                               UITableViewDelegate,
                               UITextFieldDelegate,
                               ScheduleViewControllerDelegate {
    
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: HabitViewCell.reuseIdentifier,
            for: indexPath
        ) as! HabitViewCell

        if indexPath.row == 1 {

            let text = selectedWeekdays.count == 7
                ? "Каждый день"
                : selectedWeekdays.map { $0.shortTitle }.joined(separator: ", ")

            cell.configure(title: "Расписание", subtitle: text, showDivider: false)

        } else {
            cell.configure(title: "Категория", subtitle: nil, showDivider: true)
        }

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let vc = ScheduleViewController()
            vc.delegate = self
            present(vc, animated: true)
        }
    }

    // MARK: - UITextFieldDelegate

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        let current = textField.text ?? ""
        let newText = (current as NSString).replacingCharacters(in: range, with: string)

        warningLabel.isHidden = newText.count < maxLength
        updateSaveButtonState()

        return newText.count <= maxLength
    }

    // MARK: - ScheduleViewControllerDelegate

    func didSelectWeekdays(_ days: [WeekdaySchedule]) {
        selectedWeekdays = days.sorted { $0.rawValue < $1.rawValue }
        tableView.reloadData()
        updateSaveButtonState()
    }
}
