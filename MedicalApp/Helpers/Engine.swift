import Foundation

class Engine {
    var db = DB()
    
    func selectFromTableEngine(nameTable: String) -> [String] {
        var result = ["hello"]
        result.append(contentsOf: db.selectFromTable(name: "question", inTable: nameTable, afterWhere: ""))
        
        return result
    }
}
