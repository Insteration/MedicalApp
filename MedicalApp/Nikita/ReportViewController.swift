//
//  ReportViewController.swift
//  MedicalApp
//
//  Created by Nikita Traydakalo on 7/31/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {
    @IBOutlet weak var mainTableView: UITableView!
    
    var textFields = [UITextField]()
    var labels = [UILabel]()
    var send = UIButton()
    var later = UIButton()
    var usagePropre = UIButton()
    var plus = UIButton()
    var acceptSwitch = UISwitch()
    
    
    var data = ReportData()
    var isKeyboardShow = false
    var lastCell = UITableViewCell()
    var keyBoardHeight = CGFloat(0)
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.allowsSelection = false
        customInit()
        clearFields()
        
        //dataReport = []
        printData()
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    
    private func customInit() {
        for i in 0..<12 {
            labels.append(UILabel())
            labels[i].textAlignment = .right
            labels[i].text = names[i]
        }
        for i in 0..<12 {
            textFields.append(UITextField())
            textFields[i].borderStyle = UITextField.BorderStyle.roundedRect
        }
        send.addTarget(self, action: #selector(pushSendButton), for: UIControl.Event.touchUpInside)
        later.addTarget(self, action: #selector(pushLaterButton), for: UIControl.Event.touchUpInside)
        usagePropre.addTarget(self, action: #selector(pushUsagePropreButton), for: UIControl.Event.touchUpInside)
        plus.addTarget(self, action: #selector(pushButtonPlus), for: UIControl.Event.touchUpInside)
    }
    
    
    
    
    @IBAction func pushLaterButton(_ sender: UIButton) {
        if areAllFieldsFilled() {
            addReportIntoData()
            saveData()
        } else {
            createAllert("Warning", "Not all fields are filled")
        }
        
    }
    
    @IBAction func pushSendButton(_ sender: UIButton) {
        if areAllFieldsFilled() {
            sendData()
        } else {
            createAllert("Warning", "Not all fields are filled")
        }
    }
    
    @IBAction func pushUsagePropreButton(_ sender: UIButton) {
        createAllertForExit()
    }
    
    @IBAction func pushButtonPlus(_ sender: UIButton) {
        print("plus")
        if areAllFieldsFilled() {
            addReportIntoData()
            clearFields()
        } else {
            createAllert("Warning", "Not all fields are filled")
        }
    }
    
    
    
    
    private func createAllert(_ title: String,_ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func createAllertForExit() {
        let alert = UIAlertController(title: "", message: "Are you sure you want to exit?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Stay", style: UIAlertAction.Style.default, handler: nil ))
        alert.addAction(UIAlertAction(title: "Exit", style: UIAlertAction.Style.destructive, handler: { action in
            self.dismiss(animated: true, completion: nil)  //FIXME: exit
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func areAllFieldsFilled() -> Bool {
        for textField in textFields {
            if textField.text == "" {
                return false
            }
        }
        return true
    }
    
    private func clearFields() {
        for i in 5..<textFields.count {
            textFields[i].text = ""
        }
        acceptSwitch.isOn = false
    }
    
    
    
    private func printData() {
        for value in dataReport {
            print("///////////////////////////////////////")
            for i in 0..<value.meatingData.count {
                print(names[i], "-", value.meatingData[i])
            }
            print("Accepted", value.isAccepted)
            for value2 in value.peopleReports {
                for i in 0..<value2.count {
                    print(names[i + 5], "-", value2[i])
                }
            }
        }
    }
    
    private func addReportIntoData() {
        for i in 0..<data.meatingData.count {
            if let tmp = textFields[i].text {
                if data.meatingData.count == i {
                    data.meatingData.append(String())
                }
                data.meatingData[i] = tmp
            }
        }
        data.peopleReports.append([String]())
        for i in 5..<textFields.count {
            data.peopleReports[data.countPeoples - 1].append(String())
            data.peopleReports[data.countPeoples - 1][i - 5] = textFields[i].text ?? ""
        }
        data.isAccepted = acceptSwitch.isOn
    }
    
    private func saveData() {
        dataReport.append(data)
        clearFields()
        printData()
        
    }
    
    private func sendData() {
        //FIXME:send data
        if false { // если есть соединение отправить data на сервер
            
        } else { // если нет соединение сохранить в data не больше 10
            saveData()
        }
    }
}





extension ReportViewController {
    
    private func createHeaderView() -> UIView {
        let headerView = UIView()
        let myLabel = UILabel()
        
        myLabel.layer.masksToBounds = true;
        myLabel.layer.cornerRadius = 20
        
        headerView.addSubview(myLabel)
        
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myLabel.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        myLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor,constant: -8).isActive = true
        myLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
        myLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
        
        myLabel.font = UIFont.boldSystemFont(ofSize: 30)
        myLabel.backgroundColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
        myLabel.textColor = .white
        myLabel.textAlignment = .center
        myLabel.text = names[namesId.report.rawValue]
        
        
        
        
        return headerView
    }
    
    private func createCellButtonPlus() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.addSubview(plus)
        
        plus.translatesAutoresizingMaskIntoConstraints = false
        plus.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        plus.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -8).isActive = true
        plus.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        plus.widthAnchor.constraint(equalTo: plus.heightAnchor).isActive = true
        
        plus.setTitle(names[namesId.buttonPlus.rawValue], for: .normal)
        plus.setTitleColor(.black, for: .normal)
        
        return cell
    }
    
    private func createCellForAccept() -> UITableViewCell {
        let cell = UITableViewCell()
        let myLabel = UILabel()
        cell.addSubview(acceptSwitch)
        cell.addSubview(myLabel)
        
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myLabel.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        myLabel.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        myLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -8).isActive = true
        myLabel.leftAnchor.constraint(equalTo: cell.centerXAnchor , constant: -8).isActive = true
        myLabel.numberOfLines = 0
        myLabel.text = names[namesId.accept.rawValue]
        
        
        acceptSwitch.translatesAutoresizingMaskIntoConstraints = false
        acceptSwitch.centerYAnchor.constraint(equalTo: myLabel.centerYAnchor).isActive = true
        acceptSwitch.rightAnchor.constraint(equalTo: myLabel.leftAnchor, constant: -8).isActive = true
        
        
        
        return cell
    }
    
    private func createCellWithButtons() -> UITableViewCell {
        let cell = UITableViewCell()
        var buttons = [later, send, usagePropre]
        for i in 0..<3 {
            buttons.append(UIButton())
            cell.addSubview(buttons[i])
            
            buttons[i].translatesAutoresizingMaskIntoConstraints = false
            buttons[i].topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            buttons[i].bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -8).isActive = true
            switch i {
            case 0:
                buttons[i].leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
                buttons[i].backgroundColor = .lightGray
                
                buttons[i].setTitle(names[namesId.buttonLater.rawValue], for: .normal)
            case 1:
                buttons[i].leftAnchor.constraint(equalTo: buttons[i - 1].rightAnchor, constant: 8).isActive = true
                buttons[i].widthAnchor.constraint(equalTo: buttons[i - 1].widthAnchor).isActive = true
                buttons[i].backgroundColor = .lightGray
                
                buttons[i].setTitle(names[namesId.buttonSend.rawValue], for: .normal)
            case 2:
                buttons[i].leftAnchor.constraint(equalTo: buttons[i - 1].rightAnchor, constant: 8).isActive = true
                buttons[i].rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
                buttons[i].widthAnchor.constraint(equalTo: buttons[i - 1].widthAnchor).isActive = true
                buttons[i].backgroundColor = .red
                
                buttons[i].setTitle(names[namesId.butttonUsagePropre.rawValue], for: .normal)
            default: break
            }
        }
        
        
        return cell
    }
    
    private func createCellWithLabel() -> UITableViewCell {
        let cell = UITableViewCell()
        let myLabel = UILabel()
        
        cell.addSubview(myLabel)
        
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myLabel.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        myLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor,constant: -8).isActive = true
        myLabel.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
        myLabel.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        
        myLabel.numberOfLines = 0
        myLabel.textAlignment = .center
        myLabel.text = names[namesId.allert.rawValue]
        
        
        return cell
    }
    
    private func createCellForItem(_ id: Int) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.addSubview(textFields[id])
        cell.addSubview(labels[id])
        
        labels[id].translatesAutoresizingMaskIntoConstraints = false
        labels[id].topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        labels[id].leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
        labels[id].bottomAnchor.constraint(equalTo: cell.bottomAnchor , constant: -8).isActive = true
        
        textFields[id].translatesAutoresizingMaskIntoConstraints = false
        textFields[id].topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        textFields[id].rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        textFields[id].bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -8).isActive = true
        textFields[id].leftAnchor.constraint(equalTo: labels[id].rightAnchor, constant: 8).isActive = true
        textFields[id].widthAnchor.constraint(equalTo: labels[id].widthAnchor).isActive = true
        
        return cell
    }
}





extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 18
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 2:
            return 80
        case 5:
            return 20
        case 14:
            return 80
        case 17:
            if isKeyboardShow {
                return keyBoardHeight
            } else {
                return 0
            }
        default:
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch indexPath.row {
        case 0..<2:
            cell = createCellForItem(indexPath.row)
        case 2:
            cell = createCellWithLabel()
        case 3..<5:
            cell = createCellForItem(indexPath.row - 1)
        case 6..<14:
            cell = createCellForItem(indexPath.row - 2)
        case 14:
            cell = createCellForAccept()
        case 15:
            cell = createCellButtonPlus()
        case 16:
            cell = createCellWithButtons()
        case 17:
            lastCell = cell
        default:()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createHeaderView()
    }
}





extension ReportViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissingKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissingKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyBoardHeight = keyboardSize.height
        }
        isKeyboardShow = true
        if let tmpIndexPath = mainTableView.indexPath(for: lastCell) {
            mainTableView.reloadRows(at: [tmpIndexPath], with: .automatic)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        isKeyboardShow = false
        if let tmpIndexPath = mainTableView.indexPath(for: lastCell) {
            mainTableView.reloadRows(at: [tmpIndexPath], with: .automatic)
        }
    }
}




 extension UserDefaults {
    
    public func setStructArray<T: Codable>(_ value: [T], forKey defaultName: String){
        let data = value.map { try? JSONEncoder().encode($0) }
        
        set(data, forKey: defaultName)
    }
    
    public func structArrayData<T>(_ type: T.Type, forKey defaultName: String) -> [T] where T : Decodable {
        guard let encodedData = array(forKey: defaultName) as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(type, from: $0) }
    }
}



















//    @IBOutlet weak var reportLabel: UILabel!
//    @IBOutlet weak var acceptSwitch: UISwitch!
//
//
//    @IBOutlet weak var numberOfPeople: UITextField!
//    @IBOutlet weak var country: UITextField!
//    @IBOutlet weak var city: UITextField!
//    @IBOutlet weak var message1: UITextField!
//    @IBOutlet weak var name: UITextField!
//    @IBOutlet weak var lastName: UITextField!
//    @IBOutlet weak var fonction: UITextField!
//    @IBOutlet weak var organisation: UITextField!
//    @IBOutlet weak var email: UITextField!
//    @IBOutlet weak var number: UITextField!
//    @IBOutlet weak var message2: UITextField!
//
//    var reportData: [ReportData]!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        reportData = [ReportData]()
//
//        clearFields()
//        customInit()
//        self.hideKeyboardWhenTappedAround()
//    }
//
//
//    @IBAction func pushLaterButton(_ sender: UIButton) {
//        saveReportData()
//        exitReport()
//    }
//
//    @IBAction func pushSendButton(_ sender: UIButton) {
//        SendRepostData()
//        exitReport()
//    }
//
//    @IBAction func pushNonButton(_ sender: UIButton) {
//        exitReport()
//    }
//
//    @IBAction func pushButtonPlus(_ sender: UIButton) {
//        if areAllFieldsFilled() {
//            addReportIntoReportData()
//            clearFields()
//        } else {
//            createAllert("Warning", "Not all fields are filled")
//        }
//    }
//
//
//
//    private func customInit() {
//
//        reportLabel.layer.masksToBounds = true;
//        reportLabel.layer.cornerRadius = reportLabel.frame.height / 2
//    }
//
//
//    private func createAllert(_ title: String,_ message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
//
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    private func createAllertForExit() {
//        let alert = UIAlertController(title: "", message: "Are you sure you want to exit?", preferredStyle: UIAlertController.Style.alert)
//
//        alert.addAction(UIAlertAction(title: "Stay", style: UIAlertAction.Style.default, handler: nil ))
//        alert.addAction(UIAlertAction(title: "Exit", style: UIAlertAction.Style.destructive, handler: { action in
//            print("exit report ok")
//        }))
//
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    private func exitReport() {
//        createAllertForExit()
//    }
//
//    private func saveReportData() {
//        if areAllFieldsFilled() {
//            print("save data ok")
//            clearFields()
//        } else {
//            createAllert("Warning", "Not all fields are filled")
//        }
//    }
//
//    private func SendRepostData() {
//        print("send data ok")
//    }
//
//    private func areAllFieldsFilled() -> Bool {
//        if  numberOfPeople.text != "" &&
//            country.text != "" &&
//            city.text != "" &&
//            message1.text != "" &&
//            name.text != "" &&
//            lastName.text != "" &&
//            fonction.text != "" &&
//            organisation.text != "" &&
//            email.text != "" &&
//            number.text != "" &&
//            message2.text != "" &&
//            acceptSwitch.isOn == true{
//            return true
//        }
//        return false
//    }
//
//    private func clearFields() {
//
//        numberOfPeople.text = ""
//        country.text = ""
//        city.text = ""
//        message1.text = ""
//        name.text = ""
//        lastName.text = ""
//        fonction.text = ""
//        organisation.text = ""
//        email.text = ""
//        number.text = ""
//        message2.text = ""
//
//        acceptSwitch.isOn = false
//    }
//
//    private func addReportIntoReportData() {
//        reportData.append(ReportData(
//            numberOfPeople: numberOfPeople.text ?? "",
//            country: country.text ?? "",
//            city: city.text ?? "",
//            message1: message1.text ?? "",
//            name: name.text ?? "",
//            lastName: lastName.text ?? "",
//            fonction: fonction.text ?? "",
//            organisation: organisation.text ?? "",
//            email: email.text ?? "",
//            number: number.text ?? "",
//            message2: message2.text ?? ""
//        ))
//    }
//
//
//}
//
//
//extension UIViewController {
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissingKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc func dismissingKeyboard() {
//        view.endEditing(true)
//    }
//}
