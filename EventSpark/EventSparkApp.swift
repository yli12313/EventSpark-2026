import SwiftUI
import SwiftData

@main
struct EventSparkApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [NetworkingEvent.self, Contact.self])
    }
}
