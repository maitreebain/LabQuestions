//
//  QuestionDetailController.swift
//  LabQuestions
//
//  Created by Alex Paul on 12/11/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class QuestionDetailController: UIViewController {
  
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var questionTitle: UILabel!
    
    @IBOutlet weak var labName: UILabel!
    
    @IBOutlet weak var questionTextView: UITextView!
    
    var question: Question?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showAnswerQuestion" {
        
        guard let navController = segue.destination as? UINavigationController,
            let answerQuestionController = navController.viewControllers.first as? AnswerQuestionController else {
            fatalError("could not downcast to AQC")
        }
        answerQuestionController.question = question
        } else if segue.identifier == "showAnswers" {
            //TODO: pass question over to Answers view controller
            guard let answersViewController = segue.destination as? AnswersViewController else {
                fatalError("no downcast to AVC")
            }
            answersViewController.question = question
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        
    }
    
    
    private func updateUI() {
        guard let question = question else {
        fatalError("could not update ui, verify question got set in prepare(for segue: )")
    }
        labName.text = question.labName
        questionTitle.text = question.title
        questionTextView.text = question.description

        userImageView.getImage(with: question.avatar) { [weak self] (result) in
            
            switch result{
            case .failure:
                // because getImage is using NetworkHelper which uses URLSession and is on a background thread. We are not allowed to updateUI on the background thread. App will crash.
                DispatchQueue.main.async {
                    self?.userImageView.image = UIImage(systemName: "person.fill")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.userImageView.image = image
                }
                
            }
        }
}
}
