extends Control

var database: SQLite

var table = {
    "id": {
        "data_type": "int",
        "primary_key": true,
        "not_null": true,
        "auto_increment": true},
}

func _ready():
    database = SQLite.new()
    database.path = "res://data/data.db"
    database.open_db()
    pass