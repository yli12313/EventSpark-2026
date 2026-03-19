import SwiftUI
import SwiftData

struct ContactFormView: View {
    // Pass an event to associate the new contact, or an existing contact to edit
    var event: NetworkingEvent? = nil
    var contact: Contact? = nil

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var email = ""
    @State private var notes = ""

    @FocusState private var nameFieldFocused: Bool

    private var isEditing: Bool { contact != nil }
    private var formIsValid: Bool { !name.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        NavigationStack {
            Form {
                Section("Contact") {
                    TextField("Name (required)", text: $name)
                        .focused($nameFieldFocused)
                        .textContentType(.name)
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
                }
            }
            .navigationTitle(isEditing ? "Edit Contact" : "New Contact")
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
                if let contact {
                    name = contact.name
                    email = contact.email
                    notes = contact.notes
                } else {
                    // Auto-open keyboard on Name field for quick-add
                    nameFieldFocused = true
                }
            }
        }
    }

    private func save() {
        if let contact {
            // Edit existing
            contact.name = name
            contact.email = email
            contact.notes = notes
        } else {
            // Create new, linked to event
            let newContact = Contact(
                name: name,
                email: email,
                notes: notes,
                event: event
            )
            modelContext.insert(newContact)
        }
        dismiss()
    }
}

#Preview("Create for Event") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: NetworkingEvent.self, Contact.self, configurations: config)
    let event = NetworkingEvent(name: "WWDC 2025")
    container.mainContext.insert(event)
    return ContactFormView(event: event)
        .modelContainer(container)
}
