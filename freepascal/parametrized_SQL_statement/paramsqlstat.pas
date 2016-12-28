program Parametrized_SQL_Statement;
uses
  sqlite3, sysutils;

const
  DB_FILE : PChar = 'test.db';

var
  DB                :Psqlite3;
  ResultCode        :Integer;
  SQL               :PChar;
  CompiledStatement :Psqlite3_stmt;

Procedure InsertValues(DB :Psqlite3);
var
  i             :integer;
  ResultCode    :integer;
  SQLStatements :array [1..4] of PChar;
begin
  SQLStatements[1] := 'insert into players (name, score, active, jerseyNum) values (''Ben Roethlisberger'', 94.1, 1, 7);';
  SQLStatements[2] := 'insert into players (name, score, active, jerseyNum) values (''Alex Smith'', 85.3, 1, 11);';
  SQLStatements[3] := 'insert into players (name, score, active, jerseyNum) values (''Payton Manning'', 96.5, 0, 18);';
  SQLStatements[4] := 'insert into players (name, score, active, jerseyNum) values (''John Doe'', 15, 0, 99);';

  for i:=1 to 4 do
  begin
    ResultCode := sqlite3_exec(DB, SQLStatements[i], nil, nil, nil);
    if ResultCode <> SQLITE_OK then
    begin
      writeln(format('Error #%d: %s', [ResultCode, sqlite3_errmsg(db)]));
      sqlite3_close(DB);
      halt(ResultCode);
    end;
  end;
end;

begin
  // Open the database.
  ResultCode := sqlite3_open(DB_FILE, @DB);
  if ResultCode <> SQLITE_OK then
  begin
    writeln(format('%d: %s', [ResultCode, sqlite3_errmsg(db)]));
    halt(1);
  end;

  // Create the players table in the database.
  SQL := 'create table players(id integer primary key asc, name text, score real, active integer, jerseyNum integer);';
  ResultCode := sqlite3_exec(DB, SQL, nil, nil, nil);
  if ResultCode <> SQLITE_OK then
  begin
    writeln(format('Error #%d: %s', [ResultCode, sqlite3_errmsg(db)]));
    sqlite3_close(DB);
    halt(ResultCode);
  end;

  // Insert some values into the players table.
  InsertValues(DB);

  // Update player #99.
  // TODO

  sqlite3_close(db);
end.
