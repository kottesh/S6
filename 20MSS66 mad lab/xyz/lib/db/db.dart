import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:bcrypt/bcrypt.dart';

class DB {
    static final DB _instance = DB._internal();
    Database? _db;
    
    factory DB() {
        return _instance;
    }
    
    DB._internal();

    Future<Database> get database async {
        if (_db == null) {
            _db = await initDB();
        }

        return _db!;
    }


    Future<Database> initDB() async {
        String path = join(await getDatabasesPath(), 'users.db');

        var db = await openDatabase(
            path,
            version: 1,
            onCreate: create
        );

        return db;
    }

    Future<void> create(Database db, int version) async {
        await db.execute(
            '''
                CREATE TABLE IF NOT EXISTS users (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    username TEXT NOT NULL UNIQUE,
                    password TEXT NOT NULL
                );
            '''
        );

        await initialUsers(); 
    }

    Future<void> initialUsers() async {
        final db = await database;

        final results = await db.query('users');

        if (results.isEmpty) {
            await db.insert('users', {
                'username': 'Test 1',
                'password': BCrypt.hashpw('pass 1', BCrypt.gensalt())
            });
            await db.insert('users', {
                'username': 'Test 2',
                'password': BCrypt.hashpw('pass 2', BCrypt.gensalt())
            });
        }
    }

    Future<bool> authenticateUser(String username, String password) async {
        final db = await database;

        var results = await db.query(
            'users',
            where: 'username = ?',
            whereArgs: [username]
        );

        if (results.isEmpty) {
            return false;
        }

        String db_pass = results[0]['password'] as String;

        return BCrypt.checkpw(password, db_pass);
    }

    Future<int> addUser(String username, String password) async {
        final db = await database;

        try {
            return await db.insert(
                'users', 
                {
                    'username': username,
                    'password': BCrypt.hashpw(password, BCrypt.gensalt())
                }
            );
        } catch (err) {
            print('Error: ${err.toString()}');
            return -1;
        }
    }
}

