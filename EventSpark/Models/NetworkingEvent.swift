import Foundation
import SwiftData

@Model final class NetworkingEvent {
    var name: String
    var date: Date
    var location: String
    var notes: String
    @Relationship(deleteRule: .cascade, inverse: \Contact.event)
    var contacts: [Contact]

    init(
        name: String,
        date: Date = .now,
        location: String = "",
        notes: String = ""
    ) {
        self.name = name
        self.date = date
        self.location = location
        self.notes = notes
        self.contacts = []
    }
}
