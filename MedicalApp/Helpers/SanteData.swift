import Foundation
import SQLite3

struct DB {
    
    func getHTML(_ id: Int = 3) -> String {
        guard let path = Bundle.main.path(forResource: "Sante", ofType: "db") else {return "FIG_VAM"}
  
        var db: OpaquePointer? = nil
        guard sqlite3_open(path, &db) == SQLITE_OK else {
            print("error creating DB \(Error.self)")
            return "" }
        print("create DataBase done \(path)")
        
        
        var values = String()
        var str: OpaquePointer? = nil
        let query = "SELECT html FROM slides WHERE id = \(id)"
        
        if sqlite3_prepare_v2(db, query, -1, &str, nil) == SQLITE_OK {
            print("query \(query) is DONE")
        } else {
            print("query \(query) is uncorrect")
        }
        
        if sqlite3_step(str) == SQLITE_ROW {
            let html = String(cString: sqlite3_column_text(str, 0))
            values = html
        } else {
            print("error get HTML from DataBase")
        }
        
        sqlite3_close(db)
        return values
    }
    
    // update slides SET txt = "parser html" WHERE id =1;
    func updateTXT(){
        
    }
    
    
}

