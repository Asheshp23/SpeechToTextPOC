import SwiftUI
import Speech
import AVFoundation
import AudioKitUI
import Waveform

struct QuestionAndAnswerView: View {
    var question: InterviewQuestionModel
    
    @State private var openAnswerTextBox: Bool = false
    @State private var fullTranscript: String = ""
    
    @StateObject var speechTranscriber: SpeechTranscriber = SpeechTranscriber()
    
    var sampleBuffer: SampleBuffer {
        SampleBuffer(samples: speechTranscriber.channelDataValueArray)
    }
    
    var recordingButtonView: some View {
        Circle()
            .stroke(Color.clear, lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
            .padding(.all)
            .frame(width: 100, height: 100)
            .overlay(alignment: .center) {
                Circle()
                    .foregroundColor(Color.red.opacity(0.5))
                Image(systemName: speechTranscriber.isRecording ? "square.fill" : "mic.fill")
                    .font(.title)
                    .accessibilityLabel(speechTranscriber.isRecording ? "Recording" : "Not Recording")
                    .foregroundColor(.red)
                    .bold()
            }
    }
    
    var answerView: some View {
        VStack(alignment: .leading) {
            Text("Answer:")
            if openAnswerTextBox {
                if speechTranscriber.isRecording {
                    ScrollView {
                        ScrollViewReader { proxy in
                            Text(computeFullTranscript())
                                .font(.system(size: 16))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                                .id(1)
                                .onChange(of: speechTranscriber.transcript) { oldValue, newValue in
                                    withAnimation(.easeInOut) {
                                        proxy.scrollTo(1, anchor: .bottom)
                                    }
                                }
                        }
                    }
                    .scrollIndicators(.visible, axes: .vertical)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity ,maxHeight: 50.0)
                    .padding(.all)
                    
                    if speechTranscriber.showWaveForms {
                        Spacer()
                        Waveform(samples: sampleBuffer)
                    }
                } else {
                    TextEditor(text: $fullTranscript)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding()
                }
                Spacer()
                if speechTranscriber.isRecording {
                    HStack {
                        Spacer()
                        Text(speechTranscriber.showWaveForms ? "Hide wave forms" : "Show wave forms")
                            .padding(.all)
                            .frame(height: 40.0)
                            .background(Color.gray.opacity(0.2))
                        Spacer()
                    }
                    .onTapGesture {
                        speechTranscriber.showWaveForms.toggle()
                    }
                }
                HStack {
                    Spacer()
                    VStack {
                        if !speechTranscriber.isRecording {
                            Text("Tap to start")
                                .foregroundColor(.red)
                                .bold()
                        }
                        recordingButtonView
                            .onTapGesture {
                                withAnimation {
                                    speechTranscriber.isRecording.toggle()
                                    let generator = UIImpactFeedbackGenerator(style: .medium)
                                    generator.impactOccurred()
                                }
                            }
                    }
                    Spacer()
                }
            } else {
                Button {
                    openAnswerTextBox.toggle()
                } label: {
                    Text("Tap here to answer the question")
                        .foregroundStyle(.white)
                }
                .padding()
                .background(
                    Color.mint
                )
                .cornerRadius(7.0)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(question.questionText)
                Spacer()
            }
            HStack {
                answerView
            }
            Spacer()
        }
        .onChange(of: speechTranscriber.isRecording, initial: false, { oldValue, newValue in
            handleRecordingStateChange(newValue)
        })
        .padding(.all)
        .background(
            Color.indigo.opacity(0.5)
                .cornerRadius(8.0)
        )
        .padding(.all)
    }
    
    private func handleRecordingStateChange(_ isRecording: Bool) {
        if isRecording {
            startRecording()
        } else {
            stopRecording()
        }
    }
    
    private func startRecording() {
        speechTranscriber.resetTranscript()
        speechTranscriber.startTranscribing()
    }
    
    fileprivate func computeFullTranscript() -> String {
        if fullTranscript.isEmpty {
            return speechTranscriber.transcript
        } else {
            return fullTranscript + ((fullTranscript.last == ".") ? "" : "." + "\n\(speechTranscriber.transcript)")
        }
    }
    
    private func stopRecording() {
        fullTranscript = computeFullTranscript()
        speechTranscriber.stopTranscribing()
    }
}
