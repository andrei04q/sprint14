import Foundation

enum TrackerColor: String {
    case red
    case blue
    case green = "SectionColorGreen"
}

enum Weekday: Int, CaseIterable {
    case monday, tuesdays, wednesday, thursday, friday, saturday, sunday
}

struct Tracker {
    let id: UUID
    let name: String
    let color: TrackerColor
    let emoji: String
    let schedule: Set<Weekday>
}

