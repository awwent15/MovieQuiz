import UIKit


struct QuizStepViewModel {
    
    let image: UIImage
    let question: String
    let questionNumber: String
}

struct QuizQuestion {
    
    let image: String
    let text: String
    let correctAnswer: Bool
}

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    // Массив с вопросами
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    

    private var currentQuestionIndex = 0

    private var correctAnswers = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        show(quiz: convert(model: questions[currentQuestionIndex]))
    }

    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    // Конвертация
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
        return questionStep
    }

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        handleAnswer(givenAnswer: true)
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        handleAnswer(givenAnswer: false)
    }

    private func handleAnswer(givenAnswer: Bool) {
        let currentQuestion = questions[currentQuestionIndex]
        let isCorrect = givenAnswer == currentQuestion.correctAnswer
        
        // Результат
        showAnswerResult(isCorrect: isCorrect)
        
        // Задержка в 1 секунду
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.moveToNextQuestion()
        }
    }

    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
            imageView.layer.borderColor = UIColor.green.cgColor
        } else {
            imageView.layer.borderColor = UIColor.red.cgColor
        }
        imageView.layer.borderWidth = 5
    }

    private func moveToNextQuestion() {
        currentQuestionIndex += 1
        if currentQuestionIndex < questions.count {
            imageView.layer.borderWidth = 0
            show(quiz: convert(model: questions[currentQuestionIndex]))
        } else {
            showAlert()
        }
    }

    private func showAlert() {
        let alert = UIAlertController(title: "Раунд окончен", message: "Ваш результат: \(correctAnswers) из \(questions.count)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Сыграть ещё раз", style: .default, handler: { [weak self] _ in
            self?.restartQuiz()
        }))
        present(alert, animated: true, completion: nil)
    }

    private func restartQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        imageView.layer.borderWidth = 0
        show(quiz: convert(model: questions[currentQuestionIndex]))
    }
}
