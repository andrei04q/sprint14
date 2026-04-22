import UIKit

enum WeekdaySchedule: Int, CaseIterable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var title: String {
        switch self {
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thursday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        case .sunday: return "Воскресенье"
        }
    }
    
    var shortTitle: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
}
    
protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectWeekdays(_ days: [WeekdaySchedule])
}

final class ScheduleViewController: UIViewController {
    
    weak var delegate: ScheduleViewControllerDelegate?
    
    private var selectedWeekdays: Set<WeekdaySchedule> = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = UIFont(name: TrackerFont.medium.rawValue, size: 16)
        label.textColor = .ypBlack
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .nameTrackerTextField
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let saveScheduleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont(name: TrackerFont.medium.rawValue, size: 16)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        saveScheduleButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        addTitleLabelOnView()
        addTableViewOnView()
        addSaveScheduleButtonOnView()
    }
    
    @objc private func saveTapped() {
        delegate?.didSelectWeekdays(Array(selectedWeekdays))
        dismiss(animated: true)
    }
    
    private func addTitleLabelOnView() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 37)
        ])
    }
    
    private func addTableViewOnView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 525)
        ])
    }
    
    private func addSaveScheduleButtonOnView() {
        view.addSubview(saveScheduleButton)
        saveScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveScheduleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveScheduleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveScheduleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveScheduleButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WeekdaySchedule.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ScheduleCell.reuseIdentifier,
            for: indexPath) as? ScheduleCell
        else {
            return UITableViewCell()
        }
        
        let day = WeekdaySchedule.allCases[indexPath.row]
        
        cell.configure(
            title: day.title,
            isOn: selectedWeekdays.contains(day),
            showDivider: indexPath.row != WeekdaySchedule.allCases.count - 1
        )
        
        cell.onSwitchChanged = { [weak self] isOn in
            guard let self else { return }
            
            if isOn {
                self.selectedWeekdays.insert(day)
            } else {
                self.selectedWeekdays.remove(day)
            }
        }
        
        return cell
    }
}
