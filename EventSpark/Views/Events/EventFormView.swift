import SwiftUI
import SwiftData

struct EventFormView: View {
    // Pass an existing event to edit, or nil to create
    var event: NetworkingEvent? = nil

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var date = Date.now
    @State private var location = ""
    @State private var notes = ""

    private var isEditing: Bool { event != nil }
    private var formIsValid: Bool { !name.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        NavigationStack {
            Form {
                Section("Event") {
                    TextField("Name (required)", text: $name)
                    DatePicker("Date", selection: $date, displayedComponents: [.date])
                    TextField("Location", text: $location)
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle(isEditing ? "Edit Event" : "New Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(!formIsValid)
                }
            }
            .onAppear {
                if let event {
                    name = event.name
                    date = event.date
                    location = event.location
                    notes = event.notes
                }
            }
        }
    }

    private func save() {
        if let event {
            // Edit existing
            event.name = name
            event.date = date
            event.location = location
            event.notes = notes
        } else {
            // Create new
            let newEvent = NetworkingEvent(
                name: name,
                date: date,
                location: location,
                notes: notes
            )
            modelContext.insert(newEvent)
        }
        dismiss()
    }
}

#Preview("Create") {
    EventFormView()
        .modelContainer(for: [NetworkingEvent.self, Contact.self], inMemory: true)
}
