import Foundation

struct ProjectionScenario: Identifiable {
    let id = UUID()
    let title: String
    let input: ProjectionInput
}
