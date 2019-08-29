import Foundation
import SQLite3

struct DB {
    
    func getHTML(_ id: Int = 1) -> String {
        guard let path = Bundle.main.path(forResource: "Sante", ofType: "db") else {return "FIG_VAM"}
        //        guard let url = Bundle.main.url(forResource: "Sante", withExtension: "db") else { return "" }
        //        print("1: URL = \(url)")
        var db: OpaquePointer? = nil
        guard sqlite3_open(path, &db) == SQLITE_OK else {
            print("error creating DB \(Error.self)")
            return "" }
        print("create DataBase done \(path)")
        
        
        var values = String()
        var str: OpaquePointer? = nil
        let query = "SELECT html FROM slides WHERE id = \(id)"
        
        //        if afterWhere != "" {
        //            query += "WHERE \(afterWhere)"
        //        }
        
        if sqlite3_prepare_v2(db, query, -1, &str, nil) == SQLITE_OK {
            print("query \(query) is DONE")
        } else {
            print("query \(query) is uncorrect")
        }
        
        if sqlite3_step(str) == SQLITE_ROW {
//            let id = sqlite3_column_int(str, 0)
//            let name = String(cString: sqlite3_column_text(str, 1))
            let html = String(cString: sqlite3_column_text(str, 0))
            values = html
            //            values.append(String(id) + " " + name)
        } else {
            print("error get HTML from DataBase")
        }
        
        sqlite3_close(db)
        return values
    }
    
    
}

