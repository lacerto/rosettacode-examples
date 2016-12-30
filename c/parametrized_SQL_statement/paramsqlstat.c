#include <stdio.h>
#include <stdlib.h>
#include <sqlite3.h>

static const char* db_file = ":memory:"; // Create an in-memory database.  

void check_error(int result_code, sqlite3 *db);
int select_callback(void* data, int column_count, char** columns, char** column_names);

int main(void) {
    sqlite3 *db;
    int result_code;
    char *sql;
    char *insert_statements[4];
    sqlite3_stmt *compiled_statement;
    int i;
    
    // Open the database.
    result_code = sqlite3_open(db_file, &db);
    check_error(result_code, db);    
    
    // Create the players table in the database.
    sql = "create table players("
          "id integer primary key asc, "
          "name text, "
          "score real, "
          "active integer, " // Store the bool value as integer (see https://sqlite.org/datatype3.html chapter 2.1).
          "jerseyNum integer);";
    result_code = sqlite3_exec(db, sql, NULL, NULL, NULL);
    check_error(result_code, db);    
        
    // Insert some values into the players table.    
    insert_statements[0] = "insert into players (name, score, active, jerseyNum) "
                                        "values ('Roethlisberger, Ben', 94.1, 1, 7);";
    insert_statements[1] = "insert into players (name, score, active, jerseyNum) "
                                        "values ('Smith, Alex', 85.3, 1, 11);";
    insert_statements[2] = "insert into players (name, score, active, jerseyNum) "
                                        "values ('Manning, Payton', 96.5, 0, 18);";
    insert_statements[3] = "insert into players (name, score, active, jerseyNum) "
                                        "values ('Doe, John', 15, 0, 99);";
    
    for (i=0; i<4; i++) {
        result_code = sqlite3_exec(db, insert_statements[i], NULL, NULL, NULL);        
        check_error(result_code, db);    
    }
        
    // Display the contents of the players table.
    printf("Before update:\n");
    sql = "select * from players;";
    result_code = sqlite3_exec(db, sql, select_callback, NULL, NULL);
    check_error(result_code, db);    
    
    // Close the database connection.
    sqlite3_close(db);        
        
    return EXIT_SUCCESS;
}

void check_error(int result_code, sqlite3 *db) {
    if (result_code != SQLITE_OK) {
        printf("Error #%d: %s\n", result_code, sqlite3_errmsg(db));
        sqlite3_close(db);
        exit(result_code);
    }
}

int select_callback(void* data, int column_count, char** columns, char** column_names) {
    int i;
    
    for (i=0; i<column_count; i++) {
        printf(columns[i]);
        if (i < column_count-1) printf(" | ");
    }
    printf("\n");
}

