import SwiftUI
import SwiftData
import UIKit

struct ContactDetailView: View {
    @Bindable var contact: Contact
    @State private var showingEditSheet = false
    @State private var emailCopied = false

    var body: some View {
        List {
            if !contact.email.isEmpty {
                Section("Email") {
                    HStack {
                        Text(contact.email)
                        Spacer()
                        Button {
                            copyEmail()
                        } label: {
                            Image(systemName: emailCopied ? "checkmark" : "doc.on.doc")
                                .foregroundStyle(emailCopied ? .green : .accentColor)
                                .animation(.easeInOut(duration: 0.2), value: emailCopied)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            if let event = contact.event {
                Section("Event") {
                    LabeledContent("Name", value: event.name)
                    LabeledContent("Date", value: event.date.formatted(date: .long, time: .omitted))
                    if !event.location.isEmpty {
                        LabeledContent("Location", value: event.location)
                    }
                }
            }

            if !contact.notes.isEmpty {
                Section("Notes") {
                    Text(contact.notes)
                }
            }
        }
        .navigationTitle(contact.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditSheet = true
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            ContactFormView(contact: contact)
        }
    }

    private func copyEmail() {
        UIPasteboard.general.string = contact.email
        emailCopied = true
        // Reset icon after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            emailCopied = false
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: NetworkingEvent.self, Contact.self, configurations: config)
    let event = NetworkingEvent(name: "WWDC 2025", location: "San Jose")
    container.mainContext.insert(event)
    let contact = Contact(name: "Jane Doe", email: "jane@example.com", notes: "Works on SwiftUI team.", event: event)
    container.mainContext.insert(contact)
    return NavigationStack {
        ContactDetailView(contact: contact)
    }
    .modelContainer(container)
}
