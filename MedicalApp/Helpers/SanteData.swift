import Foundation
import SQLite3


protocol DB {
    //func getHTML(_ id: Int) -> String
    //func insertInTable(inTable: String, question: String)
}

extension DB {
    
    func openDataBase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        
        guard let path = Bundle.main.path(forResource: "Sante", ofType: "db") else { return db }

        
        guard sqlite3_open(path, &db) == SQLITE_OK else {
            print("error opened DB \(Error.self)")
            return db}
        print("open DataBase done \(path)")
        
        return db
    }
    
    func getHTML(_ id: Int = 3) -> String {
        var values = String()
        var str: OpaquePointer? = nil
        let query = "SELECT html FROM slides WHERE id = \(id)"
        
        if sqlite3_prepare_v2(openDataBase(), query, -1, &str, nil) == SQLITE_OK {
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
        
        //        sqlite3_close(db)
        return values
    }
    
    func insertInTable(inTable: String, question: String) {
        
        var insert: OpaquePointer? = nil
        let insertString = """
        INSERT INTO \(inTable) (question) VALUES ('\(question)');
        """
        guard sqlite3_prepare_v2(openDataBase(), insertString, -1, &insert, nil) == SQLITE_OK,
            sqlite3_step(insert) == SQLITE_DONE
            else {
                print("error insert in table")
                return
        }
        
//        sqlite3_close(openDataBase())
        print("insert in table done")
        print(insertString)
        sqlite3_finalize(insert)
    }
    
    
    func updateTXT(){
    }
    
    
}

