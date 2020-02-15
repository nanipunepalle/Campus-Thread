//
//  CreateEvent1ViewController.swift
//  CampusThreadUpdated
//
//  Created by Lalith on 11/02/20.
//  Copyright © 2020 NANI. All rights reserved.
//

import UIKit
import Firebase

class CreateEvent1ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate{
    
    
    
    var eventTypes = [EventTypes]()
    var eventtype: [String] = []
    
    let db = Firestore.firestore()
    
    
    @IBOutlet weak var eventNameField: UITextField!
    @IBOutlet weak var eventTypeTableView: UITableView!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var phNoTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var regFeesTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTypeTableView.dataSource = self
        eventTypeTableView.delegate = self
        startTimeTextField.delegate = self
        endTimeTextField.delegate = self
        startTimeTextField.tag = 2
        endTimeTextField.tag = 3
        loadEventTypes()
        eventTypeTableView.reloadData()
        
//        navigationItem.hidesBackButton = true
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "Event1ToEvent2", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = eventTypes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        cell.textLabel?.text = event.eventTypeName
        cell.accessoryType = event.eventTypeSelected ? .checkmark : .none
        if event.eventTypeSelected{
            eventtype.append(event.eventTypeName)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventTypes[indexPath.row].eventTypeSelected = !eventTypes[indexPath.row].eventTypeSelected
        tableView.deselectRow(at: indexPath, animated: true)
        eventtype = []
        tableView.reloadData()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        startTimeTextField.inputView = datePicker
        endTimeTextField.inputView = datePicker
        if textField.tag == 2{
            datePicker.addTarget(self, action: #selector(handleDatePicker1(sender:)), for: .valueChanged)
        }
        if textField.tag == 3{
            datePicker.addTarget(self, action: #selector(handleDatePicker2(sender:)), for: .valueChanged)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let error = validateFields()
        
        if error != nil {
            showAlert(err: error!)
        }
        else{
            let secondVc = segue.destination as! CreateEvent2ViewController
//            secondVc.presentationController?.presentationStyle = .f
            secondVc.eventName = eventNameField.text!
            secondVc.eventType = eventtype
            secondVc.eventEmail = emailTextField.text
            secondVc.eventphno = Double(phNoTextField.text ?? "")
            secondVc.regFees = Int(regFeesTextField.text!)
            secondVc.eventStartDate = stringtodate(date: startTimeTextField.text!)
            secondVc.eventEndDate = stringtodate(date: endTimeTextField.text!)
            secondVc.eventStartDateString = startTimeTextField.text!
            secondVc.eventEndDateString = endTimeTextField.text!
            
        }
    }
    
    
    
    //Functions
    
    
    func validateFields() -> String?
    {
        if eventNameField.text == "" || startTimeTextField.text == "" || endTimeTextField.text == "" || regFeesTextField.text == "" || emailTextField.text == ""{
            return "Fill all required Fields"
        }
        if isValidEmail(emailTextField.text!) == false{
            return "invalid Email"
        }
        if isValidPhno(value: phNoTextField.text!) == false{
            return "invalid Phone Number"
        }
        
        if isValidDates(date1: stringtodate(date: startTimeTextField.text!), date2: stringtodate(date: endTimeTextField.text!)) == false{
            
            return "invalid Dates"
        }
        return nil
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPhno(value: String) -> Bool {
        let phoneNumberRegex = "^[6-9]\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        return phoneTest.evaluate(with: value)
    }
    
    func isValidDates(date1:Date,date2: Date) -> Bool{
        if date1 >= date2{
            return false
        }
        
        if date1 < Date() || date2 < Date(){
            return false
        }
        
        return true
    }
    
    func showAlert(err: String){
        let alert = UIAlertController(title: "Invalid", message: err, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style:.default, handler: nil))
        self.present(alert,animated: true, completion: nil)
    }
    
    @objc func handleDatePicker1(sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy HH:mm"
        startTimeTextField.text = dateFormatter.string(from: sender.date)
    }
    @objc func handleDatePicker2(sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy HH:mm"
        endTimeTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func stringtodate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        print(date)
        //        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "dd/MMM/yyyy HH:mm"
        let datefinal = dateFormatter.date(from:date)!
        return datefinal
    }
    
    
    
    func loadEventTypes()
    {
        db.collection("EventTypes").addSnapshotListener { (querySnapshot, err) in
            if err != nil{
                print(err?.localizedDescription ?? "error extracting eventypes from database")
            }
            else{
                if let snapshotDocuments = querySnapshot?.documents
                {
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        if let eventType = data["eventTypeName"] as? String{
                            let newEventType = EventTypes(eventTypeName: eventType, eventTypeSelected: false)
//                            print(eventType)
                            self.eventTypes.append(newEventType)
                            DispatchQueue.main.async {
                                _ = IndexPath(row: self.eventTypes.count - 1, section: 0)
                                self.eventTypeTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}
