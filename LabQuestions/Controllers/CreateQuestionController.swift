//
//  CreateQuestionController.swift
//  LabQuestions
//
//  Created by Alex Paul on 12/11/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class CreateQuestionController: UIViewController {
  
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var questionsTextView: UITextView!
    
    @IBOutlet weak var labPickerView: UIPickerView!
    //pickerView has datasource and delegate but DATEpicker does not
    
    
    //data for pickerView
    private var labs = ["Concurrency", "Comic", "Parsing JSON - Weather, Color, User", "Image and Error Handling", "Intro to UNit testing - Jokes, Star Wars, Trivia"].sorted() //ascending by default a - z
    
    //lab name will be the current selected row in the picker view
    private var labName: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure the pickerview
        labPickerView.dataSource = self
        labPickerView.delegate = self
        
        //variable to track the current selected lab in the picker view
        labName = labs.first // default lab is the first  row of the picker view
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //we want to change the color and border width
        //of the text view
        //experiment with shadows on views
        //every view has a CALayer
        
        //semantic colors are new to iOS 13
        //semantic colors adapt to light or dark
        //CG - Core Graphics
        questionsTextView.layer.borderColor = UIColor.systemPink.cgColor
        questionsTextView.layer.borderWidth = 2
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true) //or completion: nil
    }
    
    @IBAction func create(_ sender: UIBarButtonItem) {
        // 3 required parameters to create a Question object
        guard let questionTitle = titleTextField.text,
            !questionTitle.isEmpty,
        let labName = labName,
            let labDescription = questionsTextView.text,
            !labDescription.isEmpty
        else {
            showAlert(title: "Missing Fields", message: "Title, Description are required")
            return
        }
        
        let question = PostedQuestion(title: questionTitle,
                                      labName: labName,
                                      description: labDescription,
                                      createdAt: String.getISOTimestamp())
        
        //TODO: POST Question using APIClient
        LabQuestionsAPIClient.postQuestion(question: question) { [weak self](result) in
            
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error posting question", message: "\(appError)")
                }
            case .success:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Success", message: "\(questionTitle) was posted")
                }
            }
        }
    }
    
    
}

extension CreateQuestionController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return labs.count
    }
    
}

extension CreateQuestionController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return labs[row]
    }
}
