import SwiftUI
import SwiftData

struct EventDetailView: View {
    @Bindable var event: NetworkingEvent
    @State private var showingEditSheet = false
    @State private var showingAddContactSheet = false

    private var sortedContacts: [Contact] {
        event.contacts.sorted { $0.name < $1.name }
    }

    var body: some View {
        List {
            // Event info section
            Section("Event Details") {
                LabeledContent("Date", value: event.date.formatted(date: .long, time: .omitted))
                if !event.location.isEmpty {
                    LabeledContent("Location", value: event.location)
                }
            }

            if !event.notes.isEmpty {
                Section("Notes") {
                    Text(event.notes)
                        .foregroundStyle(.primary)
                }
            }

            // Contacts section
            Section {
                if sortedContacts.isEmpty {
                    Text("No contacts yet — tap Add Contact to capture someone.")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                } else {
                    ForEach(sortedContacts) { contact in
                        NavigationLink(destination: ContactDetailView(contact: contact)) {
                            ContactRowView(contact: contact)
                        }
                    }
                    .onDelete(perform: deleteContacts)
                }
            } header: {
                HStack {
                    Text("Contacts")
                    Spacer()
                    Button {
                        showingAddContactSheet = true
                    } label: {
                        Image(systemName: "person.badge.plus")
                    }
                    .font(.body)
                }
            }
        }
        .navigationTitle(event.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditSheet = true
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EventFormView(event: event)
        }
        .sheet(isPresented: $showingAddContactSheet) {
            ContactFormView(event: event)
        }
    }

    @Environment(\.modelContext) private var modelContext

    private func deleteContacts(at offsets: IndexSet) {
        let sorted = sortedContacts
        for index in offsets {
            modelContext.delete(sorted[index])
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: NetworkingEvent.self, Contact.self, configurations: config)
    let event = NetworkingEvent(name: "WWDC 2025", location: "San Jose")
    container.mainContext.insert(event)
    let contact = Contact(name: "Jane Doe", email: "jane@example.com", event: event)
    container.mainContext.insert(contact)
    return NavigationStack {
        EventDetailView(event: event)
    }
    .modelContainer(container)
}
