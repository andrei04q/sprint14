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
        label.font = UIFont(name: TrackerFont.medium.rawValue, size: 16)
        label.textColor = .ypBlack
        return label
    }()

    private let nameTrackerTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.font = UIFont(name: TrackerFont.medium.rawValue, size: 17)
        textField.textColor = .ypBlack
        textField.backgroundColor = .nameTrackerTextField
        textField.layer.cornerRadius = 16

        textField.clearButtonMode = .whileEditing

        textField.returnKeyType = .done
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always

        return textField
    }()

    // MARK: - Warning label (FIXED)

    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textColor = .cancelButton
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private let tableView = UITableView()
    private let cancelButton = UIButton()
    private let saveButton = UIButton()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypWhite

        tableView.register(HabitViewCell.self, forCellReuseIdentifier: HabitViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self

        nameTrackerTextField.delegate = self

        setupButtons()
        layout()
        updateSaveButtonState()
    }

    // MARK: - Buttons

    private func setupButtons() {
        cancelButton.setTitle("Отмена", for: .normal)
        cancelButton.setTitleColor(.cancelButton, for: .normal)

        saveButton.setTitle("Создать", for: .normal)
        saveButton.setTitleColor(.ypWhite, for: .normal)

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

    // MARK: - Logic

    private func updateSaveButtonState() {
        let isEnabled = !(nameTrackerTextField.text?.isEmpty ?? true) && !selectedWeekdays.isEmpty
        saveButton.isEnabled = isEnabled
        saveButton.backgroundColor = isEnabled ? .ypBlack : .nameTrackerText
    }

    // MARK: - Layout (FIXED warning center)

    private func layout() {
        view.addSubview(titleLabel)
        view.addSubview(nameTrackerTextField)
        view.addSubview(warningLabel)
        view.addSubview(tableView)
        view.addSubview(cancelButton)
        view.addSubview(saveButton)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTrackerTextField.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nameTrackerTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),

            warningLabel.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 4),
            warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: warningLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 150),

            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),

            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

// MARK: - TableView

extension HabitViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let vc = ScheduleViewController()
            vc.delegate = self
            present(vc, animated: true)
        }
    }
}

// MARK: - Schedule

extension HabitViewController: ScheduleViewControllerDelegate {

    func didSelectWeekdays(_ days: [WeekdaySchedule]) {
        selectedWeekdays = days.sorted { $0.rawValue < $1.rawValue }
        tableView.reloadData()
        updateSaveButtonState()
    }
}

// MARK: - TextField

extension HabitViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        let current = textField.text ?? ""
        let newText = (current as NSString).replacingCharacters(in: range, with: string)

        warningLabel.isHidden = newText.count <= maxLength
        updateSaveButtonState()

        return newText.count <= maxLength
    }
}
