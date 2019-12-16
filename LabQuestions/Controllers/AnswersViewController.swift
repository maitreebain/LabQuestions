//
//  AnswersViewController.swift
//  LabQuestions
//
//  Created by Maitree Bain on 12/16/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class AnswersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var answers = [Answer]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var question: Question?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchAnswers()
        tableView.dataSource = self
    }
    
    private func fetchAnswers() {
        guard let question = question else {
            fatalError("no question found")
        }
        
        LabQuestionsAPIClient.fetchAnswers(question: question) { [weak self] (result) in
            
            switch result{
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Failed fetching answers", message: "\(appError)")
                }
            case .success(let answers):
                
                self?.answers = answers.filter { $0.questionId == question.id }
                
            }
        }
    }
    
}

extension AnswersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath)
        
        let answer = answers[indexPath.row]
        
        cell.textLabel?.text = answer.answerDescription
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
