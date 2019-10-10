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
    
   
    
    var textFields: [UITextField] = {
        var text = [UITextField]()
        for i in 0..<12 {
            text.append(UITextField())
            text[i].borderStyle = UITextField.BorderStyle.roundedRect
            text[i].addTarget(self, action: #selector(valueChangeTextField), for: UIControl.Event.editingChanged)
            text[i].translatesAutoresizingMaskIntoConstraints = false
        }
        return text
    }()
    
    var labels: [UILabel] = {
        var label = [UILabel]()
        for i in 0..<12 {
            label.append(UILabel())
            label[i].textAlignment = .right
            label[i].translatesAutoresizingMaskIntoConstraints = false
        }
        return label
    }()
    
    var send: UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(pushSendButton), for: UIControl.Event.touchUpInside)
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var later: UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(pushLaterButton), for: UIControl.Event.touchUpInside)
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var usagePropre: UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(pushUsagePropreButton), for: UIControl.Event.touchUpInside)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var plus: UIButton = {
        var button = UIButton()
        button.addTarget(self, action: #selector(pushButtonPlus), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var picker: UIPickerView = {
        var pick = UIPickerView()
        pick.translatesAutoresizingMaskIntoConstraints = false
        return pick
    }()
    
    var acceptSwitch = UISwitch()
    
    var names = namesEnglish
    var data = Report()
    var isKeyboardShow = false
    var lastCell = UITableViewCell()
    var keyBoardHeight = CGFloat(0)
    var reportDataPicker = reportDataPickerEnglish
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let locale = Locale.current.languageCode
        if locale == "fr" {
            names = namesFransh
            reportDataPicker = reportDataPickerFransh
        }
        
        dataReport = []
        
        mainTableView.allowsSelection = false
        customInit()
        clearFields()


        
        printData()
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        picker.delegate = self
        picker.dataSource = self
    }
    
    
    private func customInit() {
        for i in 0..<labels.count {
            if i >= namesId.visitType.rawValue {
                labels[i].text = self.names[i + 1]
            } else {
                labels[i].text = names[i]
            }
        }
        later.setTitle(names[namesId.buttonLater.rawValue], for: .normal)
        send.setTitle(names[namesId.buttonSend.rawValue], for: .normal)
        usagePropre.setTitle(names[namesId.butttonUsagePropre.rawValue], for: .normal)
    }
    
    
    @IBAction func valueChangeTextField(_ sender: UITextField) {
        let id = textFields.firstIndex(of: sender) ?? textFields.count
        var isRed = false
        switch id {
        case namesId.dateOfMeeting.rawValue:()
            if !isValidDate(sender.text ?? "") { isRed = true }
        case namesId.numberOfPeople.rawValue:
            if !isValidNumbers(sender.text ?? "") { isRed = true }
        case namesId.country.rawValue:
            if !isValidCountry(sender.text ?? "") { isRed = true }
        case namesId.city.rawValue:
            if !isValidCity(sender.text ?? "") { isRed = true }
        case namesId.commentaire1.rawValue:()
        case namesId.name.rawValue - 1:
            if !isValidName(sender.text ?? "") { isRed = true }
        case namesId.lastName.rawValue - 1:
            if !isValidName(sender.text ?? "") { isRed = true }
        case namesId.function.rawValue - 1:()
        case namesId.organisation.rawValue - 1:()
        case namesId.email.rawValue - 1:
            if !isValidEmail(sender.text ?? "") {
                isRed = true
            }
        case namesId.phone.rawValue - 1:
            if !isValidPhone(sender.text ?? "") {
                isRed = true
            }
        case namesId.commentaire2.rawValue - 1:()
        default:()
        }
        
        if isRed {
            sender.textColor = .red
        } else {
            sender.textColor = .black
        }
        
    }
    
    @IBAction func pushLaterButton(_ sender: UIButton) {
        if areAllFieldsFilled() {
            addReportIntoData()
            saveData()
            dismiss(animated: true, completion: nil)
        } else {
            createAllert(names[namesId.warning.rawValue], names[namesId.notAllFieldsAreFilled.rawValue])
        }
        
    }
    
    @IBAction func pushSendButton(_ sender: UIButton) {
        if areAllFieldsFilled() {
            addReportIntoData()
            sendData()
            dismiss(animated: true, completion: nil)
        } else {
            createAllert(names[namesId.warning.rawValue], names[namesId.notAllFieldsAreFilled.rawValue])
        }
    }
    
    @IBAction func pushUsagePropreButton(_ sender: UIButton) {
        createAllertForExit()
    }
    
    @IBAction func pushButtonPlus(_ sender: UIButton) {
        if areAllFieldsFilled() {
            addReportIntoData()
            clearFields()
        } else {
            createAllert(names[namesId.warning.rawValue], names[namesId.notAllFieldsAreFilled.rawValue])
        }
    }
    
    
    
    
    private func createAllert(_ title: String,_ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: names[namesId.ok.rawValue], style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func createAllertForExit() {
        let alert = UIAlertController(title: "", message: names[namesId.areYouSureYouWantToExit.rawValue], preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: names[namesId.stay.rawValue], style: UIAlertAction.Style.default, handler: nil ))
        alert.addAction(UIAlertAction(title: names[namesId.exit.rawValue], style: UIAlertAction.Style.destructive, handler: { action in
            self.dismiss(animated: true, completion: nil)  //FIXME: exit
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func areAllFieldsFilled() -> Bool {
        for textField in textFields {
            if textField.text == "" {
                return false
            }
            if textField.textColor == .red {
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
        let data = dataReport
        for report in data {
            print(names[namesId.dateOfMeeting.rawValue] + "-" + report.meatingData)
            print(names[namesId.numberOfPeople.rawValue] + "-", report.numberOfPeople)
            print(names[namesId.country.rawValue] + "-", report.country)
            print(names[namesId.city.rawValue] + "-",report.city)
            print(names[namesId.commentaire1.rawValue] + "-",report.comment)
            print(names[namesId.visitType.rawValue] + "-",report.meatingType)
            for person in report.people {
                print(names[namesId.name.rawValue] + "-" + person.name)
                print(names[namesId.lastName.rawValue] + "-" + person.lastName)
                print(names[namesId.function.rawValue] + "-" + person.function)
                print(names[namesId.organisation.rawValue] + "-" + person.organization)
                print(names[namesId.email.rawValue] + "-" + person.email)
                print(names[namesId.phone.rawValue] + "-" + person.phone)
                print(names[namesId.commentaire2.rawValue] + "-" + person.comment)
                print(names[namesId.accept.rawValue] + "-" + String(person.isAccept))
            }
        }
    }
    
    private func addReportIntoData() {
        data.meatingData = textFields[namesId.dateOfMeeting.rawValue].text ?? "-1"
        data.numberOfPeople = textFields[namesId.numberOfPeople.rawValue].text ?? "-1"
        data.country = textFields[namesId.country.rawValue].text ?? "-1"
        data.city = textFields[namesId.city.rawValue].text ?? "-1"
        data.comment = textFields[namesId.commentaire1.rawValue].text ?? "-1"
        data.meatingType = reportDataPicker[picker.selectedRow(inComponent: 0)]
        
        data.people.append(Person())
        data.people[data.people.count - 1].name = textFields[namesId.name.rawValue - 1].text ?? "-1"
        data.people[data.people.count - 1].lastName = textFields[namesId.lastName.rawValue - 1].text ?? "-1"
        data.people[data.people.count - 1].function = textFields[namesId.function.rawValue - 1].text ?? "-1"
        data.people[data.people.count - 1].organization = textFields[namesId.organisation.rawValue - 1].text ?? "-1"
        data.people[data.people.count - 1].email = textFields[namesId.email.rawValue - 1].text ?? "-1"
        data.people[data.people.count - 1].phone = textFields[namesId.phone.rawValue - 1].text ?? "-1"
        data.people[data.people.count - 1].comment = textFields[namesId.commentaire2.rawValue - 1].text ?? "-1"
        data.people[data.people.count - 1].isAccept = acceptSwitch.isOn
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
            buttons[i].topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            buttons[i].bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -8).isActive = true
        }
        
        later.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
        send.leftAnchor.constraint(equalTo: later.rightAnchor, constant: 8).isActive = true
        send.widthAnchor.constraint(equalTo: later.widthAnchor).isActive = true
        usagePropre.leftAnchor.constraint(equalTo: send.rightAnchor, constant: 8).isActive = true
        usagePropre.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        usagePropre.widthAnchor.constraint(equalTo: send.widthAnchor).isActive = true
        
        return cell
    }
    
    private func createCellForItem(_ id: Int) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.addSubview(textFields[id])
        cell.addSubview(labels[id])
        
        labels[id].topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        labels[id].leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
        labels[id].bottomAnchor.constraint(equalTo: cell.bottomAnchor , constant: -8).isActive = true
        
        textFields[id].topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        textFields[id].rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        textFields[id].bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -8).isActive = true
        textFields[id].leftAnchor.constraint(equalTo: labels[id].rightAnchor, constant: 8).isActive = true
        textFields[id].widthAnchor.constraint(equalTo: labels[id].widthAnchor).isActive = true
        
        return cell
    }
    
    private func createCellForPicer() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.addSubview(picker)
        
        picker.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        picker.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
        picker.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
       
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
        case 6:
            return 30
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
            cell = createCellForPicer() //createCellWithLabel()
        case 3..<6:
            cell = createCellForItem(indexPath.row - 1)
        case 7..<14:
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





extension ReportViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reportDataPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reportDataPicker[row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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




extension ReportViewController {
    func isValidNumbers(_ str: String) -> Bool {
        return isValid(str, "^[0-9]+$")
    }
    
    func isValidPhone(_ str: String) -> Bool {
        return isValid(str, "^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\\s\\./0-9]*$")
    }
    
    func isValidEmail(_ str: String) -> Bool {
        return isValid(str,"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")
    }
    
    func isValidName(_ str: String) -> Bool {
        return isValid(str, "^[a-zA-Z]+$")
    }
    
    func isValidCountry(_ str: String) -> Bool {
        return isValid(str, "^[a-zA-Z]{2,}$")
    }
    
    func isValidCity(_ str: String) -> Bool {
        return isValid(str, "^[a-zA-Z]+(?:[\\s-][a-zA-Z]+)*$")
    }
    
    func isValidDate(_ str: String) -> Bool {
        return isValid(str, "^(?:(?:31(\\/|-|\\.)(?:0?[13578]|1[02]))\\1|(?:(?:29|30)(\\/|-|\\.)(?:0?[13-9]|1[0-2])\\2))(?:(?:1[6-9]|[2-9]\\d)?\\d{2})$|^(?:29(\\/|-|\\.)0?2\\3(?:(?:(?:1[6-9]|[2-9]\\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\\d|2[0-8])(\\/|-|\\.)(?:(?:0?[1-9])|(?:1[0-2]))\\4(?:(?:1[6-9]|[2-9]\\d)?\\d{2})$")
    }
    
    func isValid(_ str: String, _ reg: String) -> Bool {
        let pred = NSPredicate(format:"SELF MATCHES %@", reg)
        return pred.evaluate(with: str)
    }
}










//class ReportView: UIView {
//    @IBOutlet weak var mainTableView: UITableView!
//
//    var textFields = [UITextField]()
//    var labels = [UILabel]()
//    var send = UIButton()
//    var later = UIButton()
//    var usagePropre = UIButton()
//    var plus = UIButton()
//    var acceptSwitch = UISwitch()
//    var picker = UIPickerView()
//
//
//    var data = ReportData()
//    var isKeyboardShow = false
//    var lastCell = UITableViewCell()
//    var keyBoardHeight = CGFloat(0)
//    var names = namesEnglish
//    var reportDataPicker = reportDataPickerEnglish
//
//
//
//
//    override init () {
//        super.init()
//        let locale = Locale.current.languageCode
//        //        print("/////////////////////", locale)
//        if locale == "fr" {
//            names = namesFransh
//            reportDataPicker = reportDataPickerFransh
//        }
//
//        mainTableView.allowsSelection = false
//        customInit()
//        clearFields()
//
//
//        for value in textFields {
//            value.addTarget(self, action: #selector(valueChangeTextField), for: UIControl.Event.editingChanged)
//        }
//
//        printData()
//        self.hideKeyboardWhenTappedAround()
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//
//
//        mainTableView.delegate = self
//        mainTableView.dataSource = self
//        picker.delegate = self
//        picker.dataSource = self
//    }
//
//
//    private func customInit() {
//        for i in 0..<12 {
//            labels.append(UILabel())
//            labels[i].textAlignment = .right
//            if i >= namesId.visitType.rawValue {
//                labels[i].text = names[i + 1]
//            } else {
//                labels[i].text = names[i]
//            }
//
//        }
//        for i in 0..<12 {
//            textFields.append(UITextField())
//            textFields[i].borderStyle = UITextField.BorderStyle.roundedRect
//
//        }
//
//        //        for value in textFields {
//        //            value.delegate = self
//        //        }
//
//        send.addTarget(self, action: #selector(pushSendButton), for: UIControl.Event.touchUpInside)
//        later.addTarget(self, action: #selector(pushLaterButton), for: UIControl.Event.touchUpInside)
//        usagePropre.addTarget(self, action: #selector(pushUsagePropreButton), for: UIControl.Event.touchUpInside)
//        plus.addTarget(self, action: #selector(pushButtonPlus), for: UIControl.Event.touchUpInside)
//
//        let tmpButtont = [send , usagePropre, later]
//        for value in tmpButtont {
//            value.layer.cornerRadius = 15
//            value.clipsToBounds = true
//        }
//
//    }
//
//
//    @IBAction func valueChangeTextField(_ sender: UITextField) {
//        let id = textFields.firstIndex(of: sender) ?? textFields.count
//        var isRed = false
//        switch id {
//        case namesId.dateOfMeeting.rawValue:()
//        if !isValidDate(sender.text ?? "") { isRed = true }
//        case namesId.numberOfPeople.rawValue:
//            if !isValidNumbers(sender.text ?? "") { isRed = true }
//        case namesId.country.rawValue:
//            if !isValidCountry(sender.text ?? "") { isRed = true }
//        case namesId.city.rawValue:
//            if !isValidCity(sender.text ?? "") { isRed = true }
//        case namesId.commentaire1.rawValue:()
//        case namesId.name.rawValue - 1:
//            if !isValidName(sender.text ?? "") { isRed = true }
//        case namesId.lastName.rawValue - 1:
//            if !isValidName(sender.text ?? "") { isRed = true }
//        case namesId.fonction.rawValue - 1:()
//        case namesId.organisation.rawValue - 1:()
//        case namesId.email.rawValue - 1:
//            if !isValidEmail(sender.text ?? "") {
//                isRed = true
//            }
//        case namesId.number.rawValue - 1:
//            if !isValidPhone(sender.text ?? "") {
//                isRed = true
//            }
//        case namesId.commentaire2.rawValue - 1:()
//
//        default:()
//        }
//
//        if isRed {
//            sender.textColor = .red
//        } else {
//            sender.textColor = .black
//        }
//
//    }
//
//    @IBAction func pushLaterButton(_ sender: UIButton) {
//        if areAllFieldsFilled() {
//            addReportIntoData()
//            saveData()
//            //dismiss(animated: true, completion: nil)  //FIME: exit
//        } else {
//            createAllert(names[namesId.warning.rawValue], names[namesId.notAllFieldsAreFilled.rawValue])
//        }
//
//    }
//
//    @IBAction func pushSendButton(_ sender: UIButton) {
//        if areAllFieldsFilled() {
//            addReportIntoData()
//            sendData()
//            //            dismiss(animated: true, completion: nil)//FIXME:exit
//        } else {
//            createAllert(names[namesId.warning.rawValue], names[namesId.notAllFieldsAreFilled.rawValue])
//        }
//    }
//
//    @IBAction func pushUsagePropreButton(_ sender: UIButton) {
//        createAllertForExit()
//    }
//
//    @IBAction func pushButtonPlus(_ sender: UIButton) {
//        //print("plus")
//        if areAllFieldsFilled() {
//            addReportIntoData()
//            clearFields()
//        } else {
//            createAllert(names[namesId.warning.rawValue], names[namesId.notAllFieldsAreFilled.rawValue])
//        }
//    }
//
//
//
//
//    private func createAllert(_ title: String,_ message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
//
//        alert.addAction(UIAlertAction(title: names[namesId.ok.rawValue], style: UIAlertAction.Style.default, handler: nil))
//
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    private func createAllertForExit() {
//        let alert = UIAlertController(title: "", message: names[namesId.areYouSureYouWantToExit.rawValue], preferredStyle: UIAlertController.Style.alert)
//
//        alert.addAction(UIAlertAction(title: names[namesId.stay.rawValue], style: UIAlertAction.Style.default, handler: nil ))
//        alert.addAction(UIAlertAction(title: names[namesId.exit.rawValue], style: UIAlertAction.Style.destructive, handler: { action in
//            //self.dismiss(animated: true, completion: nil)  //FIXME: exit
//        }))
//
//        present(alert, animated: true, completion: nil)
//    }
//
//    private func areAllFieldsFilled() -> Bool {
//        for textField in textFields {
//            if textField.text == "" {
//                return false
//            }
//            if textField.textColor == .red {
//                return false
//            }
//        }
//        return true
//    }
//
//    private func clearFields() {
//        for i in 5..<textFields.count {
//            textFields[i].text = ""
//        }
//        acceptSwitch.isOn = false
//    }
//
//
//
//    private func printData() {
//        for value in dataReport {
//            print("///////////////////////////////////////")
//            for i in 0..<value.meatingData.count {
//                print(names[i], "-", value.meatingData[i])
//
//            }
//
//            for j in 0..<value.peopleReports.count {
//                print("Person number ----->", j)
//                print("Accepted", value.isAccepted[j])
//                for i in 0..<value.peopleReports[j].count {
//                    print(names[i + namesId.name.rawValue], "-", value.peopleReports[j][i])
//                }
//            }
//        }
//    }
//
//    private func addReportIntoData() {
//        for i in 0..<namesId.visitType.rawValue {
//            if data.meatingData.count < namesId.visitType.rawValue {
//                data.meatingData.append(String())
//                if let tmp = textFields[i].text {
//                    data.meatingData[i] = tmp
//                }
//            }
//        }
//        if data.meatingData.count == namesId.visitType.rawValue {
//            data.meatingData.append(String())
//        }
//        data.meatingData[data.meatingData.count - 1] = reportDataPicker[picker.selectedRow(inComponent: 0)]
//        data.peopleReports.append([String]())
//        for i in 5..<textFields.count {
//            data.peopleReports[data.countPeoples - 1].append(String())
//            data.peopleReports[data.countPeoples - 1][i - 5] = textFields[i].text ?? ""
//        }
//        data.isAccepted.append(acceptSwitch.isOn)
//    }
//
//    private func saveData() {
//        dataReport.append(data)
//        clearFields()
//        printData()
//
//    }
//
//    private func sendData() {
//        //FIXME:send data
//        if false { // если есть соединение отправить data на сервер
//
//        } else { // если нет соединение сохранить в data не больше 10
//            saveData()
//        }
//    }
//
//
//}
//
//
//extension ReportView {
//
//    private func createHeaderView() -> UIView {
//        let headerView = UIView()
//        let myLabel = UILabel()
//
//        myLabel.layer.masksToBounds = true;
//        myLabel.layer.cornerRadius = 20
//
//        headerView.addSubview(myLabel)
//
//        myLabel.translatesAutoresizingMaskIntoConstraints = false
//        myLabel.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
//        myLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor,constant: -8).isActive = true
//        myLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
//        myLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
//
//        myLabel.font = UIFont.boldSystemFont(ofSize: 30)
//        myLabel.backgroundColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
//        myLabel.textColor = .white
//        myLabel.textAlignment = .center
//        myLabel.text = names[namesId.report.rawValue]
//
//
//
//
//        return headerView
//    }
//
//    private func createCellButtonPlus() -> UITableViewCell {
//        let cell = UITableViewCell()
//        cell.addSubview(plus)
//
//        plus.translatesAutoresizingMaskIntoConstraints = false
//        plus.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
//        plus.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -8).isActive = true
//        plus.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
//        plus.widthAnchor.constraint(equalTo: plus.heightAnchor).isActive = true
//
//        plus.setTitle(names[namesId.buttonPlus.rawValue], for: .normal)
//        plus.setTitleColor(.black, for: .normal)
//
//        return cell
//    }
//
//    private func createCellForAccept() -> UITableViewCell {
//        let cell = UITableViewCell()
//        let myLabel = UILabel()
//        cell.addSubview(acceptSwitch)
//        cell.addSubview(myLabel)
//
//        myLabel.translatesAutoresizingMaskIntoConstraints = false
//        myLabel.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
//        myLabel.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
//        myLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -8).isActive = true
//        myLabel.leftAnchor.constraint(equalTo: cell.centerXAnchor , constant: -8).isActive = true
//        myLabel.numberOfLines = 0
//        myLabel.text = names[namesId.accept.rawValue]
//
//
//        acceptSwitch.translatesAutoresizingMaskIntoConstraints = false
//        acceptSwitch.centerYAnchor.constraint(equalTo: myLabel.centerYAnchor).isActive = true
//        acceptSwitch.rightAnchor.constraint(equalTo: myLabel.leftAnchor, constant: -8).isActive = true
//
//
//
//        return cell
//    }
//
//    private func createCellWithButtons() -> UITableViewCell {
//        let cell = UITableViewCell()
//        var buttons = [later, send, usagePropre]
//        for i in 0..<3 {
//            buttons.append(UIButton())
//            cell.addSubview(buttons[i])
//
//            buttons[i].translatesAutoresizingMaskIntoConstraints = false
//            buttons[i].topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
//            buttons[i].bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -8).isActive = true
//            switch i {
//            case 0:
//                buttons[i].leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
//                buttons[i].backgroundColor = .lightGray
//
//                buttons[i].setTitle(names[namesId.buttonLater.rawValue], for: .normal)
//            case 1:
//                buttons[i].leftAnchor.constraint(equalTo: buttons[i - 1].rightAnchor, constant: 8).isActive = true
//                buttons[i].widthAnchor.constraint(equalTo: buttons[i - 1].widthAnchor).isActive = true
//                buttons[i].backgroundColor = .lightGray
//
//                buttons[i].setTitle(names[namesId.buttonSend.rawValue], for: .normal)
//            case 2:
//                buttons[i].leftAnchor.constraint(equalTo: buttons[i - 1].rightAnchor, constant: 8).isActive = true
//                buttons[i].rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
//                buttons[i].widthAnchor.constraint(equalTo: buttons[i - 1].widthAnchor).isActive = true
//                buttons[i].backgroundColor = .red
//
//                buttons[i].setTitle(names[namesId.butttonUsagePropre.rawValue], for: .normal)
//            default: break
//            }
//        }
//
//
//        return cell
//    }
//
//
//
//    private func createCellForItem(_ id: Int) -> UITableViewCell {
//        let cell = UITableViewCell()
//        cell.addSubview(textFields[id])
//        cell.addSubview(labels[id])
//
//        labels[id].translatesAutoresizingMaskIntoConstraints = false
//        labels[id].topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
//        labels[id].leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
//        labels[id].bottomAnchor.constraint(equalTo: cell.bottomAnchor , constant: -8).isActive = true
//
//        textFields[id].translatesAutoresizingMaskIntoConstraints = false
//        textFields[id].topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
//        textFields[id].rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
//        textFields[id].bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -8).isActive = true
//        textFields[id].leftAnchor.constraint(equalTo: labels[id].rightAnchor, constant: 8).isActive = true
//        textFields[id].widthAnchor.constraint(equalTo: labels[id].widthAnchor).isActive = true
//
//        return cell
//    }
//
//    private func createCellForPicer() -> UITableViewCell {
//        let cell = UITableViewCell()
//        cell.addSubview(picker)
//
//        picker.translatesAutoresizingMaskIntoConstraints = false
//        picker.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
//        picker.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
//        picker.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
//        picker.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
//
//
//        return cell
//    }
//}
//
//
//extension ReportView: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 18
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.row {
//        case 2:
//            return 80
//        case 6:
//            return 30
//        case 14:
//            return 80
//        case 17:
//            if isKeyboardShow {
//                return keyBoardHeight
//            } else {
//                return 0
//            }
//        default:
//            return 40
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell = UITableViewCell()
//
//        switch indexPath.row {
//        case 0..<2:
//            cell = createCellForItem(indexPath.row)
//        case 2:
//            cell = createCellForPicer() //createCellWithLabel()
//        case 3..<6:
//            cell = createCellForItem(indexPath.row - 1)
//        case 7..<14:
//            cell = createCellForItem(indexPath.row - 2)
//        case 14:
//            cell = createCellForAccept()
//        case 15:
//            cell = createCellButtonPlus()
//        case 16:
//            cell = createCellWithButtons()
//        case 17:
//            lastCell = cell
//        default:()
//        }
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return createHeaderView()
//    }
//}
//
//
//extension ReportView {
//
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissingKeyboard))
//        tap.cancelsTouchesInView = false
//        self.addGestureRecognizer(tap)
//    }
//
//    @objc func dismissingKeyboard() {
//        self.endEditing(true)
//    }
//
//    @objc func keyboardWillShow(notification: Notification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            keyBoardHeight = keyboardSize.height
//        }
//        isKeyboardShow = true
//        if let tmpIndexPath = mainTableView.indexPath(for: lastCell) {
//            mainTableView.reloadRows(at: [tmpIndexPath], with: .automatic)
//        }
//    }
//
//    @objc func keyboardWillHide(notification: Notification) {
//        isKeyboardShow = false
//        if let tmpIndexPath = mainTableView.indexPath(for: lastCell) {
//            mainTableView.reloadRows(at: [tmpIndexPath], with: .automatic)
//        }
//    }
//}
//
//
//extension ReportView: UIPickerViewDataSource, UIPickerViewDelegate {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return reportDataPicker.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return reportDataPicker[row]
//    }
//
////    override func didReceiveMemoryWarning() {
////        super.didReceiveMemoryWarning()
////    }
//}
//
//
//extension ReportView {
//    func isValidNumbers(_ str: String) -> Bool {
//        return isValid(str, "^[0-9]+$")
//    }
//
//    func isValidPhone(_ str: String) -> Bool {
//        return isValid(str, "^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\\s\\./0-9]*$")
//    }
//
//    func isValidEmail(_ str: String) -> Bool {
//        return isValid(str,"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")
//    }
//
//    func isValidName(_ str: String) -> Bool {
//        return isValid(str, "^[a-zA-Z]+$")
//    }
//
//    func isValidCountry(_ str: String) -> Bool {
//        return isValid(str, "^[a-zA-Z]{2,}$")
//    }
//
//    func isValidCity(_ str: String) -> Bool {
//        return isValid(str, "^[a-zA-Z]+(?:[\\s-][a-zA-Z]+)*$")
//    }
//
//    func isValidDate(_ str: String) -> Bool {
//        return isValid(str, "^(?:(?:31(\\/|-|\\.)(?:0?[13578]|1[02]))\\1|(?:(?:29|30)(\\/|-|\\.)(?:0?[13-9]|1[0-2])\\2))(?:(?:1[6-9]|[2-9]\\d)?\\d{2})$|^(?:29(\\/|-|\\.)0?2\\3(?:(?:(?:1[6-9]|[2-9]\\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\\d|2[0-8])(\\/|-|\\.)(?:(?:0?[1-9])|(?:1[0-2]))\\4(?:(?:1[6-9]|[2-9]\\d)?\\d{2})$")
//    }
//
//    func isValid(_ str: String, _ reg: String) -> Bool {
//        let pred = NSPredicate(format:"SELF MATCHES %@", reg)
//        return pred.evaluate(with: str)
//    }
//}
