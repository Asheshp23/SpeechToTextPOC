import Foundation

struct InterviewQuestionModel {
    var id: String {
        UUID().uuidString
    }
    let questionText: String
    let initialHints: [String]?
    let aiResponse: String?
    let improvementHints: [String]?
    var rating: Double?
}

extension InterviewQuestionModel: Identifiable {}

extension InterviewQuestionModel {
    static var previewData: [InterviewQuestionModel] {
        [
            InterviewQuestionModel(
                questionText: "Can you tell me about yourself?",
                initialHints: [
                    "Focus on key achievements in your career.",
                    "Highlight relevant skills and experiences.",
                    "Keep it concise and tailored to the job."
                ],
                aiResponse: "I am a motivated and detail-oriented professional with a background in computer science...",
                improvementHints: [
                    "Quantify your achievements with measurable results.",
                    "Demonstrate leadership and teamwork.",
                    "Discuss the impact of your accomplishment."
                ],
                rating: 4.5
            ),
            InterviewQuestionModel(
                questionText: "How do you handle challenges in the workplace?",
                initialHints: [
                    "Provide specific examples of challenges you've overcome.",
                    "Highlight your problem-solving skills.",
                    "Emphasize collaboration and teamwork."
                ],
                aiResponse: "I approach challenges with a positive mindset, breaking them down into manageable steps...",
                improvementHints: [
                    "Share a real-life scenario where you successfully navigated a challenge.",
                    "Discuss the lessons learned and your growth.",
                    "Highlight the positive outcomes of overcoming challenges."
                ],
                rating: 4.2
            )
        ]
    }
}
