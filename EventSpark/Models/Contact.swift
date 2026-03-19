import Foundation
import SwiftData

@Model final class Contact {
    var name: String
    var email: String
    var notes: String
    var event: NetworkingEvent?

    init(
        name: String,
        email: String = "",
        notes: String = "",
        event: NetworkingEvent? = nil
    ) {
        self.name = name
        self.email = email
        self.notes = notes
        self.event = event
    }
}
