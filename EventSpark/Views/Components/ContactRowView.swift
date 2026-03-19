import SwiftUI

struct ContactRowView: View {
    let contact: Contact

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(contact.name)
                .font(.headline)
            if !contact.email.isEmpty {
                Text(contact.email)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            if let eventName = contact.event?.name {
                Text(eventName)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 2)
    }
}
