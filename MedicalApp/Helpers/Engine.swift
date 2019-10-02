import Foundation

class Engine {
    var db = DB()
    
    func selectQuestionFromTable(nameTable: String) -> [String] {
        var result = ["hello"]
        
        result.append(contentsOf: db.selectFromTable(column: "question", inTable: nameTable, afterWhere: ""))
        
        return result
    }
    
    func selectDateFromTable(nameTable: String) -> [String] {
        var result = ["hello_date"]
        
        result.append(contentsOf: db.selectFromTable(column: "date_question", inTable: nameTable, afterWhere: ""))
        
        return result
        
        
    }
}

struct QuestionsAtribute {
    var name = String()
    var question = String()
    var time = String()
}
