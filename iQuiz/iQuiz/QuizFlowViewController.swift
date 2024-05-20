//
//  QuizFlowViewController.swift
//  iQuiz
//
//  Created by Maggie Liang on 5/10/24.
//

import UIKit

class QuizFlowViewController: UIViewController {

    // Labels
    @IBOutlet weak var DLabel: UILabel!
    @IBOutlet weak var CLabel: UILabel!
    @IBOutlet weak var BLabel: UILabel!
    @IBOutlet weak var ALabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionnumberLabel: UILabel!

    // Answer Buttons
    @IBOutlet weak var DAnserButton: UIButton!
    @IBOutlet weak var CAnserButton: UIButton!
    @IBOutlet weak var BAnserButton: UIButton!
    @IBOutlet weak var AAnserButton: UIButton!

    // Answer Views
    @IBOutlet weak var AView: UIView!
    @IBOutlet weak var BView: UIView!
    @IBOutlet weak var CView: UIView!
    @IBOutlet weak var DView: UIView!

    // Buttons
    @IBOutlet weak var nextbutton: UIButton!
    @IBOutlet weak var submitbutton: UIButton!

    // Variables
    var finalQuestionCount: Int = 0
    var count = 0
    var currentAnswer: String = ""
    var correctAnswersCount = 0
    var totalQuestionsCount = 0
    var hasAnswered = false
    var currentAnswers: [String] = []

    // Show Message TextView
    @IBOutlet weak var showmessage: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Call the function to get the question content based on the selected index
        getQuestionContent(selectedIndex: TopicViewController.selectedIndex)

        // Create a swipe right gesture recognizer
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight(_:)))
        swipeRightGesture.direction = .left
        view.addGestureRecognizer(swipeRightGesture)

        // Create a swipe left gesture recognizer
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight(_:)))
        swipeLeftGesture.direction = .right
        view.addGestureRecognizer(swipeLeftGesture)
    }
    
  
    @objc func handleSwipeRight(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            // Handle left swipe
            if hasAnswered {
                // If the user has answered the current question, submit the answer
                submitTapped(self)
                hasAnswered = false
            } else {
                // If the user has not answered the current question, move to the next question
                nextTapped(self)
            }
        } else if gesture.direction == .right {
            // Handle right swipe
            // Clear all variables and return to the root view controller
            self.count = 0
            self.correctAnswersCount = 0
            self.totalQuestionsCount = 0
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func getQuestionContent(selectedIndex: Int) {
        // Try to load data for the selected index and current question count
        if let data = loadData(forIndex: selectedIndex, questionsIndex: count, topics: TopicViewController.quizList) {
            // Extract the data into separate variables
            let (questionCount, topicTitle, topicDescription, questionText, answer, answers) = data

            // Set the view controller's title to the topic title
            self.title = topicTitle

            // Set the final question count based on the loaded data
            finalQuestionCount = questionCount

            // Set the current answer based on the loaded data
            currentAnswer = answer

            // Set the current answers array based on the loaded data
            currentAnswers = answers

            // Update the question number label text to reflect the current question count
            questionnumberLabel.text = "Question \(count + 1):"

            // Set the question label text to the loaded question text
            questionLabel.text = questionText

            // Check if there are at least 4 answers available
            if answers.count >= 4 {
                // Set the answer labels and enable the answer buttons
                ALabel.text = "A. \(answers[0])"
                BLabel.text = "B. \(answers[1])"
                CLabel.text = "C. \(answers[2])"
                DLabel.text = "D. \(answers[3])"
                AAnserButton.isEnabled = true
                BAnserButton.isEnabled = true
                CAnserButton.isEnabled = true
                DAnserButton.isEnabled = true
            }
        } else {
            // Print an error message if failed to load data
            print("Failed to load data.")
        }
    }


    @IBAction func submitTapped(_ sender: Any) {
        // Check if the user has answered the question
        guard hasAnswered else {
            // If the user has not answered, show an alert message and return
            showAnswerAlert(message: "Please select an answer")
            return
        }
        
        // Disable all answer buttons
        AAnserButton.isEnabled = false
        BAnserButton.isEnabled = false
        CAnserButton.isEnabled = false
        DAnserButton.isEnabled = false
        
        // Get the user's selected answer
        let userAnswer = getUserAnswer()
        
        // Check if the user's answer is correct
        let isCorrect = userAnswer == currentAnswer
        
        // Show an alert indicating if the answer is correct or not
        showAlert(isCorrect: isCorrect)
        
        // Update the correct answers count if the answer is correct
        if isCorrect {
            correctAnswersCount += 1
            //change green color
            changegreenbgcolor()
        } else
        {
            //change red color
            changeredbgcolor()
        }
        
        // Increase the total questions count regardless of the answer correctness
        totalQuestionsCount += 1
        
        // Disable the submit button to prevent multiple submissions
        submitbutton.isEnabled = false
    }
    
    func showAnswerAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }

    func changeredbgcolor(){
        // Check which answer button is selected and return the corresponding answer key
        if AAnserButton.isSelected {
            self.AView.backgroundColor = .systemRed
        } else if BAnserButton.isSelected {
            self.BView.backgroundColor = .systemRed
        } else if CAnserButton.isSelected {
            self.CView.backgroundColor = .systemRed
        } else if DAnserButton.isSelected {
            self.DView.backgroundColor = .systemRed
        }
    }
    
    func changegreenbgcolor(){
        // Check which answer button is selected and return the corresponding answer key
        if AAnserButton.isSelected {
            self.AView.backgroundColor = .systemGreen
        } else if BAnserButton.isSelected {
            self.BView.backgroundColor = .systemGreen
        } else if CAnserButton.isSelected {
            self.CView.backgroundColor = .systemGreen
        } else if DAnserButton.isSelected {
            self.DView.backgroundColor = .systemGreen
        }
    }
   
    
    func getUserAnswer() -> String {
        // Check which answer button is selected and return the corresponding answer key
        if AAnserButton.isSelected {
            return "1"
        } else if BAnserButton.isSelected {
            return "2"
        } else if CAnserButton.isSelected {
            return "3"
        } else if DAnserButton.isSelected {
            return "4"
        } else {
            return ""
        }
    }
    
    func getUserAnswerLabel(key: String) -> String {
        // Return the label text corresponding to the given answer key
        if key == "1" {
            return currentAnswers[0]
        } else if key == "2" {
            return currentAnswers[1]
        } else if key == "3" {
            return currentAnswers[2]
        } else if key == "4" {
            return currentAnswers[3]
        } else {
            return ""
        }
    }


    func showAlert(isCorrect: Bool) {
        // Convert the current answer to letters
        let answerLetters = convertToLetters(currentAnswer)
        // Get the label text for the current answer
        let answerDetails = getUserAnswerLabel(key: currentAnswer)
        
        // Create the alert message based on the correctness of the answer
        let message = isCorrect ? "Congratulations, the answer is correct!" : "Sorry, the answer is incorrect. \nThe correct answer is \n\(answerLetters), \(answerDetails)"
        
        // Set the message to the showmessage label
        showmessage.text = message
    }

    func convertToLetters(_ answer: String) -> String {
        var letters = ""
        // Convert the answer key to letters
        for char in answer {
            switch char {
            case "1":
                letters += "A"
            case "2":
                letters += "B"
            case "3":
                letters += "C"
            case "4":
                letters += "D"
            default:
                break
            }
        }
        return letters
    }

    func resetSelectedButton() {
        // Reset the selected state of answer buttons and clear the showmessage label
        self.showmessage.text = ""
        AAnserButton.isSelected = false
        BAnserButton.isSelected = false
        CAnserButton.isSelected = false
        DAnserButton.isSelected = false
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        // Reset the selected answer button, enable the submit button, and increment the count
        resetSelectedButton()
        submitbutton.isEnabled = true
        count += 1
        
        if count < finalQuestionCount {
            // Reset the background color of answer views
            self.AView.backgroundColor = .black
            self.BView.backgroundColor = .black
            self.CView.backgroundColor = .black
            self.DView.backgroundColor = .black
            
            // Get the content of the next question
            getQuestionContent(selectedIndex: TopicViewController.selectedIndex)
        } else {
            // Disable the submit button and show the completion alert
            submitbutton.isEnabled = false
            showCompletionAlert()
        }
    }

    
    func showCompletionAlert() {
        // Calculate the score and set initial values for message and title
        let score = "\(correctAnswersCount) of \(finalQuestionCount) correct"
        var message = ""
        var title = ""
        
        // Display different descriptive texts based on the user's score
        if correctAnswersCount == finalQuestionCount {
            title = "Perfect!"
            message = "You got them all right!"
        } else if correctAnswersCount >= finalQuestionCount / 2 {
            title = "Almost!"
            message = "You did well, keep it up!"
        } else {
            title = "Keep going!"
            message = "You have room for improvement, keep trying!"
        }
        
        // Create and present the completion alert
        let alert = UIAlertController(title: title, message: "\(message)\nScore: \(score)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    
    func loadData(forIndex index: Int, questionsIndex: Int, topics: [Topic]) -> (Int,String, String, String,String, [String])? {
        // Check if the topic index is valid
        guard index >= 0 && index < topics.count else {
            print("Invalid topic index.")
            return nil
        }
        
        // Retrieve topic information
        let topic = topics[index]
        let topicTitle = topic.title
        let topicDescription = topic.desc
        
        // Check if the questions index is valid
        guard questionsIndex >= 0 && questionsIndex < topic.questions.count else {
            print("Invalid questions index.")
            return nil
        }
        
        // Retrieve question information
        let question = topic.questions[questionsIndex]
        let questionText = question.text
        let singleAnswer = question.answer
        let answers = question.answers
        
        // Return the retrieved information as a tuple
        return (topic.questions.count, topicTitle, topicDescription, questionText, singleAnswer, answers)
    }
    
    @IBAction func DTapped(_ sender: Any) {
        // Handle the tap on the D answer button
        handleOptionButtonTap(button: DAnserButton, view: DView)
    }

    @IBAction func CTapped(_ sender: Any) {
        // Handle the tap on the C answer button
        handleOptionButtonTap(button: CAnserButton, view: CView)
    }

    @IBAction func BTapped(_ sender: Any) {
        // Handle the tap on the B answer button
        handleOptionButtonTap(button: BAnserButton, view: BView)
    }

    @IBAction func ATapped(_ sender: Any) {
        // Handle the tap on the A answer button
        handleOptionButtonTap(button: AAnserButton, view: AView)
    }

    func handleOptionButtonTap(button: UIButton, view: UIView) {
        // Deselect all answer buttons
        AAnserButton.isSelected = false
        BAnserButton.isSelected = false
        CAnserButton.isSelected = false
        DAnserButton.isSelected = false
        
        // Select the tapped answer button
        button.isSelected = true
        
        // Reset the background color of all answer views to black
        AView.backgroundColor = .black
        BView.backgroundColor = .black
        CView.backgroundColor = .black
        DView.backgroundColor = .black
        
        // Set the background color of the tapped answer view to green
        view.backgroundColor = .gray
        
        // Set the hasAnswered flag to true
        hasAnswered = true
    }

}
