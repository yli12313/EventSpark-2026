import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            EventListView()
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }

            AllContactsView()
                .tabItem {
                    Label("Contacts", systemImage: "person.2")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [NetworkingEvent.self, Contact.self], inMemory: true)
}
