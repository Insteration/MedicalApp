import Foundation
import SQLite3

struct DB: ParserProtocol {
    
    static var db: OpaquePointer? = nil
    
    mutating func openDB() -> String {
        guard let path = Bundle.main.path(forResource: "Sante", ofType: "db") else {
            return "FIG_VAM"
        }
        
        guard sqlite3_open(path, &DB.db) == SQLITE_OK else {
            print("error open DB \(Error.self)")
            return "error open DB on path =  \(path)"}
        
        return "open DataBase done \(path)"
    }
    
    func getHTML(_ id: Int) -> String {
        
        var values = String()
        var str: OpaquePointer? = nil
        let query = "SELECT html FROM slides WHERE id = \(id)"
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
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
        
        return values
    }
    
    func clearTxt(txt: inout String, id: Int, name: String) -> [(idSlide: Int , name: String, word: String, cnt: Int, listWord: String)]{
        
        let errorChar: Set<Character> = ["'"]
        txt.removeAll(where: { errorChar.contains($0) })
        
        // for french "’" don't remove
        let arrayTxt = txt.components(separatedBy:
            [",", " ", "!",".","?","\n","\r","(",")","*","_",
             "0","1","2","3","4","5","6","7","8","9", "+", "!",
             "=", ";", ":", "<", "&", "\"", "\\", "@", "[", "]",
             "{", "}", "«", "»", "-", "/", "·", "|", "#", " ",
             "“"])
            .filter({$0.count > 1})
        print("arrayTxt.count = ", arrayTxt.count)
        //        print(arrayTxt.sorted())
        
        var setTxt = Set<String>()
        arrayTxt.forEach{ setTxt.insert($0.lowercased()) }
        print("setTxt.count = ", setTxt.count)
        //        print(setTxt.sorted())
        
        // формируем массив кортежей для наполнения таблицы
        // сделать через модель
        var arrDict = [(idSlide: Int,
                        name: String,
                        word: String,
                        cnt: Int,
                        listWord: String)]()
        arrDict = []
        
        setTxt.sorted().forEach{
            let word = $0
            
            var cnt = 1
            var listWord = word
            arrayTxt.forEach{
                if $0.contains(word) {
                    cnt += 1
                    listWord += " " + word
                }
            }
            
            let rec: (idSlide: Int , name: String, word: String, cnt: Int, listWord: String) = (id, name, $0, cnt, listWord)
            
            arrDict.append(rec)
        }
        
        print("arrDict.count = ", arrDict.count)
        
        // sort Dict on cnt, more to less
        arrDict = arrDict.sorted(by: { $0.3 > $1.3 } )
//        arrDict.forEach({print($0)})
        
        return arrDict
    }
}

// MARK: - delete records from table
extension DB {
    
    func deleteRecords(inTable:String, id: Int){
        
        var del: OpaquePointer? = nil
        let query = "DELETE FROM \(inTable) WHERE id_slide = '\(id)'"
        
        guard sqlite3_prepare_v2(DB.db, query, -1, &del, nil)==SQLITE_OK else {
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error prepare delete: \(errmsg)")
            return
        }
        
        guard sqlite3_step(del) == SQLITE_DONE  else {
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error delete: \(errmsg)")
            return
        }
        
        sqlite3_finalize(del)
        print(query)
    }
}

//MARK: - close DB
extension DB {
    func closeDB() {
        sqlite3_close(DB.db)
    }
}

// MARK: - CREATE VIRTUAL TABLE "slides_search"
/* CREATE VIRTUAL TABLE "slides_search" USING FTS5 ( id_slide, name, word, list_word, cnt )
 var arrDict = [(
    idSlide: Int,
    name: String,
    word: String,
    cnt: Int,
    listWord: String
 )]() */
extension DB {
    
    func insertSlideSearch(inTable: String,
                         arrDict: [(
        idSlide: Int,
        name: String,
        word: String,
        cnt: Int,
        listWord: String)]) {
        
        var insert: OpaquePointer? = nil
        
        arrDict.forEach{
            
            let insertString = """
            INSERT INTO \(inTable) (id_slide, name, word, cnt, list_word) VALUES ('\($0.idSlide)', '\($0.name)', '\($0.word)', '\($0.cnt)', '\($0.listWord)');
            """
            guard sqlite3_prepare_v2(DB.db, insertString, -1, &insert, nil) == SQLITE_OK,
                sqlite3_step(insert) == SQLITE_DONE
                else {
                    let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
                    print("error preparing insert: \(errmsg): for insert: ", insertString)
                    return
            }
            
        }
        
        sqlite3_finalize(insert)
    }
}

// MARK: - get dict for insert in table slides_search
/* var arrDict = [(
    idSlide: Int,
    name: String,
    word: String,
    cnt: Int,
    listWord: String
    )]() */
extension DB {
    
    func createDict(_ id : Int) {
        
        var html = String()
        var name = String()
        var str: OpaquePointer? = nil
        
        let query = "SELECT name, html FROM slides WHERE id = \(id)"
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            //            print("query \(query) is DONE")
        } else {
            print("query \(query) is uncorrect")
        }
        
        if sqlite3_step(str) == SQLITE_ROW {
            name = String(cString: sqlite3_column_text(str, 0))
            html = String(cString: sqlite3_column_text(str, 1))
        } else {
            print("error get HTML from DataBase")
        }
        
        sqlite3_finalize(str)
        
        // parser html
        var txt = parse(htmlString: html)
        
        let arrDict = clearTxt(txt: &txt, id: id, name: name)
        print("let arrDict = clearTxt(txt: &txt, id: id, name: name,  arrDict.count = ", arrDict.count)
        
        deleteRecords(inTable: "slides_search", id: id)
        printWordCount(id)
        
        insertSlideSearch(inTable: "slides_search",
                        arrDict: arrDict)
    
        return
    }
}

// MARK: - insert In Table question
extension DB {
    func insertInTable(inTable: String, question: String) {
        
        var insert: OpaquePointer? = nil
        let insertString = """
        INSERT INTO \(inTable) (question) VALUES ('\(question)');
        """
        guard sqlite3_prepare_v2(DB.db, insertString, -1, &insert, nil) == SQLITE_OK,
            sqlite3_step(insert) == SQLITE_DONE
            else {
                let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
                print("error preparing insert: \(errmsg)")
                return
        }
        
        print("insert in table done")
        print(insertString)
        sqlite3_finalize(insert)
    }
}

// MARK: - get records from table slides_search on request
extension DB {
    
    // SELECT name, word, cnt from slides_search where list_word MATCH "many" ORDER BY rank;
    func searchSlides (_ req: String) -> [String] {
        
        var values = [String]()
        var str: OpaquePointer? = nil
        let query = req
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("query \(query) is DONE")
        } else {
            print("query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
        }
        
        while (sqlite3_step(str)) == SQLITE_ROW {
            
            let name = String(cString: sqlite3_column_text(str, 0))
            let count = String(cString: sqlite3_column_text(str, 1))
            let sum_count_word = String(cString: sqlite3_column_text(str, 2))
            let list = String(cString: sqlite3_column_text(str, 3))
            print(name + "(" + count + ", " + sum_count_word + "): " + list)
            values.append(name + "(" + sum_count_word + ", " + count + "): " + list)
        }
        
        return values
    }
    
    // MARK: - split search query on space
    func splittingSearch(_ query: String) -> [String] {
        
        var txt = query
//        let errorChar: Set<Character> = ["'"]
        let errorChar: Set<Character> = [
            "'", ",", "!", ".","?","\n","\r","(",")", "_",
            "0","1","2","3","4","5","6","7","8","9", "+", "!",
            "=", ";", ":", "<", "&", "\"", "\\", "@", "[", "]",
            "{", "}", "«", "»", "-", "/", "·", "|", "#", "“",
            "$", "^", "%"]

        txt.removeAll(where: { errorChar.contains($0) })
        
        // for french "’" don't remove
        let arrayTxt = txt.components(separatedBy: " ")
        
        print("arrayTxt.count = ", arrayTxt.count)
        print(arrayTxt)
        
        var setTxt = Set<String>()
        arrayTxt.forEach{ setTxt.insert($0.lowercased()) }
        print("setTxt.count = ", setTxt.count)
        print(setTxt)
        
        return arrayTxt
    }
    
    /*
     SELECT name, count(), sum(count_word) as sum_count_word,
     GROUP_CONCAT(listWord || "(" || count_word || ")", "; ") as list from
     (
         select name, GROUP_CONCAT(word || "(" || cnt || ")", "; ") listWord, count(word) as count_word
         FROM
         (
            select * FROM slides_search WHERE list_word MATCH 'pre*' ORDER BY rank
         )
         GROUP BY name
         UNION
         select name, GROUP_CONCAT(word || "(" || cnt || ")", "; ") listWord, count(word) as count_word
         FROM
         (
            select * FROM slides_search WHERE list_word MATCH 'at*' ORDER BY rank
         )
         GROUP BY name
     )
     GROUP BY name HAVING count() = 2;
     */
    // MARK: - prepare sql query for search with multi words
    func prepareSearch(_ arrWord: [String]) -> String {
        
        var searcgSql = """
        SELECT name, count(), sum(count_word) as sum_count_word,
        GROUP_CONCAT(listWord || "(" || count_word || ")", "; ") as list from
        (
             select name, GROUP_CONCAT(word || "(" || cnt || ")", "; ") listWord, count(word) as count_word
             FROM
             (
                select * FROM slides_search WHERE list_word MATCH '\(arrWord[0])' ORDER BY rank
             )
             GROUP BY name
        """
        
        for index in 1..<arrWord.count{
            searcgSql += """
            \nUNION
            select name, GROUP_CONCAT(word || "(" || cnt || ")", "; ") listWord, count(word) as count_word
            FROM
            (
                select * FROM slides_search WHERE list_word MATCH '\(arrWord[index])' ORDER BY rank
            )
            GROUP BY name
            """
        }
        
        searcgSql += """
        )
        GROUP BY name HAVING count() = \(arrWord.count);
        """
        
//        print(searcgSql)
        return searcgSql
    }
    
}

// MARK: get data image from blob
extension DB {
    
    // TODO: - use Model : (String, Data)
    func getDataFromBlob(_ id: Int = 1) -> (String, Data) {
        
        var str: OpaquePointer? = nil
        var blob = Data()
        var name = String()
        let query = "SELECT name, image from slides_image WHERE id = \(id);"
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("prepare query \(query) is DONE")
        } else {
            print("prepare query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
        }
        
        if sqlite3_step(str) == SQLITE_ROW {
            
            // get name file image
            name = String(cString: sqlite3_column_text(str, 0))
            
            if let dataBlob = sqlite3_column_blob(str, 1){
                let dataBlobLength = sqlite3_column_bytes(str, 1)
                blob = Data(bytes: dataBlob, count: Int(dataBlobLength))
                print("dataBlob: \n", dataBlob)
                print("dataBlobLength = ", dataBlobLength)
            }            
        } else {
            print("query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error run query: \(errmsg)")
        }
        
        return (name, blob)
    }
}

// MARK: - get count word in table slides_search on id_slide
// SELECT count(word) as word_count FROM slides_search  WHERE id_slide = "7";
extension DB {
    
    func printWordCount(_ id: Int) {
        
        var str: OpaquePointer? = nil
        
        let query = "SELECT count(word) as word_count FROM slides_search  WHERE id_slide = '\(id)';"
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
        } else {
            print("query \(query) is uncorrect")
        }
        
        if sqlite3_step(str) == SQLITE_ROW {
            print("word_count with id = \(id): ", String(cString: sqlite3_column_text(str, 0)))
        } else {
            print("error get word_count with id = \(id)")
        }
        
        sqlite3_finalize(str)
    }
    
}

// TODO: - delete extension!
extension DB {
    
    // сделать через модель
    private func updateSlideWord(inTable: String, txt: String, id: Int) {
        
        var update: OpaquePointer? = nil
        
        //        print("txt = ", txt, "\nid = ", id)
        
        let updateString = """
        UPDATE \(inTable) SET txt = '\(txt)' WHERE iD = \(id)
        """
        //        print("updateString = ",updateString)
        
        guard sqlite3_prepare_v2(DB.db, updateString, -1, &update, nil) == SQLITE_OK,
            sqlite3_step(update) == SQLITE_DONE else {
                let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
                print("error preparing update: \(errmsg)")
                return
        }
        print("update whith guard done")
        
        sqlite3_finalize(update)
    }
    
    func insertSlideWord(inTable: String,
                         arrDict: [(
        idSlide: Int,
        word: String,
        cnt: Int,
        listWord: String)]) {
        
        var insert: OpaquePointer? = nil
        
        arrDict.forEach{
            
            let insertString = """
            INSERT INTO \(inTable) (id_slide, word, cnt, list_word) VALUES ('\($0.idSlide)', '\($0.word)', '\($0.cnt)', '\($0.listWord)');
            """
            guard sqlite3_prepare_v2(DB.db, insertString, -1, &insert, nil) == SQLITE_OK,
                sqlite3_step(insert) == SQLITE_DONE
                else {
                    let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
                    print("error preparing insert: \(errmsg): for insert: ", insertString)
                    return
            }
            
            //            print(insertString)
        }
        
        sqlite3_finalize(insert)
    }
    
    private func updateTXT(inTable: String, txt: String, id: Int) {
        
        var update: OpaquePointer? = nil
        
        //        print("txt = ", txt, "\nid = ", id)
        
        let updateString = """
        UPDATE \(inTable) SET txt = '\(txt)' WHERE iD = \(id)
        """
        
        //        let updateString = "UPDATE slides SET txt = strftime('%Y-%m-%d %H:%M:%S', datetime('now','localtime')) WHERE iD = 3"
        
        //        print("updateString = ",updateString)
        
        guard sqlite3_prepare_v2(DB.db, updateString, -1, &update, nil) == SQLITE_OK,
            sqlite3_step(update) == SQLITE_DONE else {
                let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
                print("error preparing update: \(errmsg)")
                return
        }
        //        print("update whith guard done")
        
        sqlite3_finalize(update)
    }
    
    //    func updateTXT(_ id : Int = 3) -> String {
    //
    //        var html = String()
    //        var str: OpaquePointer? = nil
    //
    //        let query = "SELECT html FROM slides WHERE id = \(id)"
    //
    //        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
    //            //            print("query \(query) is DONE")
    //        } else {
    //            print("query \(query) is uncorrect")
    //        }
    //
    //        if sqlite3_step(str) == SQLITE_ROW {
    //            html = String(cString: sqlite3_column_text(str, 0))
    //        } else {
    //            print("error get HTML from DataBase")
    //        }
    //
    //        // parser html and update field txt
    //        var txt = parse(htmlString: html)
    //
    //        let arrDict = clearTxt(txt: &txt, id)
    //
    //        let dict: String = {
    //
    //            var dict = String()
    //
    //            arrDict.forEach{
    //                dict += "\($0)" + "\n"
    //            }
    //
    //            return dict
    //        }()
    //
    //        deleteRecords(inTable: "slide_word", id: id)
    //
    //        insertSlideWord(inTable: "slide_word",
    //                        arrDict: arrDict)
    //
    //        updateTXT(inTable: "slides", txt: txt, id: id)
    //
    //        // get TXT from BD
    //        let queryTXT = "SELECT txt FROM slides WHERE id = \(id)"
    //        //        var txtSlides = ""
    //
    //        if sqlite3_prepare_v2(DB.db, queryTXT, -1, &str, nil) == SQLITE_OK {
    //            //            print("queryTXT \(query) is DONE")
    //        } else {
    //            print("queryTXT \(query) is uncorrect")
    //        }
    //
    //        if sqlite3_step(str) == SQLITE_ROW {
    //            //            txtSlides = String(cString: sqlite3_column_text(str, 0))
    //        } else {
    //            print("error get TXT from DataBase")
    //        }
    //
    //        //        print("txtSlides = ", txtSlides)
    //
    //        return dict
    //    }
    
}
