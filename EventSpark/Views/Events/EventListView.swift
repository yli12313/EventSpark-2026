import SwiftUI
import SwiftData

struct EventListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \NetworkingEvent.date, order: .reverse) private var events: [NetworkingEvent]
    @State private var showingCreateSheet = false

    var body: some View {
        NavigationStack {
            Group {
                if events.isEmpty {
                    ContentUnavailableView(
                        "No Events Yet",
                        systemImage: "calendar.badge.plus",
                        description: Text("Tap + to add your first networking event.")
                    )
                } else {
                    List {
                        ForEach(events) { event in
                            NavigationLink(destination: EventDetailView(event: event)) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(event.name)
                                        .font(.headline)
                                    HStack {
                                        Text(event.date, style: .date)
                                        if !event.location.isEmpty {
                                            Text("·")
                                            Text(event.location)
                                        }
                                    }
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    let count = event.contacts.count
                                    if count > 0 {
                                        Text("\(count) contact\(count == 1 ? "" : "s")")
                                            .font(.caption2)
                                            .foregroundStyle(.tertiary)
                                    }
                                }
                                .padding(.vertical, 2)
                            }
                        }
                        .onDelete(perform: deleteEvents)
                    }
                }
            }
            .navigationTitle("Events")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingCreateSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                if !events.isEmpty {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
            }
            .sheet(isPresented: $showingCreateSheet) {
                EventFormView()
            }
        }
    }

    private func deleteEvents(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(events[index])
        }
    }
}

#Preview {
    EventListView()
        .modelContainer(for: [NetworkingEvent.self, Contact.self], inMemory: true)
}
