import Foundation

class Engine {
    var db = DB()
    var question = "question"
    var date_question = "date_question"
    
    func selectQuestionFromTable(nameTable: String) -> [String] {
        
        return db.selectFromTable(column: question, inTable: nameTable, afterWhere: "")
    }
    
    func selectDateFromTable(nameTable: String) -> [String] {
        
        return db.selectFromTable(column: date_question, inTable: nameTable, afterWhere: "")
    }
}


