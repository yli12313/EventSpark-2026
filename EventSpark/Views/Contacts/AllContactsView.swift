import SwiftUI
import SwiftData

struct AllContactsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Contact.name) private var allContacts: [Contact]
    @State private var searchText = ""

    private var filteredContacts: [Contact] {
        guard !searchText.isEmpty else { return allContacts }
        let query = searchText.lowercased()
        return allContacts.filter {
            $0.name.lowercased().contains(query) ||
            $0.email.lowercased().contains(query) ||
            ($0.event?.name.lowercased().contains(query) ?? false)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if allContacts.isEmpty {
                    ContentUnavailableView(
                        "No Contacts Yet",
                        systemImage: "person.badge.plus",
                        description: Text("Add contacts from an event in the Events tab.")
                    )
                } else if filteredContacts.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                } else {
                    List {
                        ForEach(filteredContacts) { contact in
                            NavigationLink(destination: ContactDetailView(contact: contact)) {
                                ContactRowView(contact: contact)
                            }
                        }
                        .onDelete(perform: deleteContacts)
                    }
                }
            }
            .navigationTitle("Contacts")
            .searchable(text: $searchText, prompt: "Search by name, email, or event")
            .toolbar {
                if !allContacts.isEmpty {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
            }
        }
    }

    private func deleteContacts(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredContacts[index])
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: NetworkingEvent.self, Contact.self, configurations: config)
    let event = NetworkingEvent(name: "WWDC 2025", location: "San Jose")
    container.mainContext.insert(event)
    let contacts = [
        Contact(name: "Jane Doe", email: "jane@example.com", event: event),
        Contact(name: "Bob Smith", email: "bob@example.com", event: event),
        Contact(name: "Alice Johnson", email: "alice@example.com", event: event),
    ]
    contacts.forEach { container.mainContext.insert($0) }
    return AllContactsView()
        .modelContainer(container)
}
