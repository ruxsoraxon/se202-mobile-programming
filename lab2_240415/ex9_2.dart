/// SE202 Mobile Programming — Lab 2, Exercise 9.2
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

abstract interface class DBConnector {
  void connect();
  List<String> query(String sql);
  void close();
}

class MySQLConnector implements DBConnector {
  final String host;
  MySQLConnector(this.host);

  @override
  void connect() => print('Connected to MySQL at $host');

  @override
  List<String> query(String sql) {
    print('Running: $sql');
    return ['row1', 'row2'];
  }

  @override
  void close() => print('Connection closed');
}

void main() {
  final DBConnector db = MySQLConnector('localhost:3306');
  db.connect();
  print(db.query('SELECT * FROM users'));
  db.close();
}
