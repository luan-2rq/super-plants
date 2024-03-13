@tool
extends VBoxContainer

@export var save_path : String # (String, FILE)
@export var spreadsheet_id: String
@export var localization_sheet_names : Array[String] # (Array, String)

@onready var button : Node = $Button
@onready var result_label : Node = $Label
@onready var oauth_client : Node = get_parent()
var url = "https://sheets.googleapis.com/v4/spreadsheets/%s/values/%s?access_token=%s"
var http_request_instance

func _ready():
	button.connect("pressed", Callable(self, "_on_button_pressed"))
	oauth_client.connect("token_received", Callable(self, "_on_token_received"))

func _on_button_pressed():
	oauth_client.authorize()

func _on_token_received(token):
	var data = await get_spreadsheet_data(token)
	import_spreadsheet(data)
	
func get_spreadsheet_data(token):
	## GET SPREADSHEET DATA
	
	var spreadsheet_data : Array = Array()
	
	http_request_instance = HTTPRequest.new()
	add_child(http_request_instance)
	var headers = [
		"Content-Type: application/x-www-form-urlencoded",
		'Accept: application/json'
	]
	headers = PackedStringArray(headers)
	for name in localization_sheet_names:
		var error = http_request_instance.request(url % [spreadsheet_id, name, token])

		if error != OK:
			push_error("An error occurred in the HTTP request with ERR Code: %s" % error)

		var response = await http_request_instance.request_completed
		var response_body = response[3].get_string_from_utf8()
		var json = JSON.new()
		var err = json.parse(response_body)
		if err != OK:
			push_error("An error occurred parsing the table json: %s" % err)
		else:
			var json_parse_result = json.data
			spreadsheet_data.append(json_parse_result)

		http_request_instance.cancel_request()
	return spreadsheet_data
	
func import_spreadsheet(spreadsheet_data : Array):
	var new_table = spreadsheet_data[0]["values"]
	var cur_table_to_merge
	for i in range(spreadsheet_data.size() - 1):
		cur_table_to_merge = spreadsheet_data[i + 1]["values"]
		remove_header(cur_table_to_merge)
		new_table.append_array(cur_table_to_merge)
	save_as_csv(new_table)
			
func save_as_csv(matrix):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		for row in matrix:
			
			var str_row = row[0]
			for i in range(1, row.size()):
				str_row += "," + row[i] 

			file.store_line(str_row)

		print("Imported table saved to CSV successfully.")
		result_label.text = "Successfully imported"
	else:
		print("Failed to open the file for writing.")
		result_label.text = "Import failed"
	
func remove_header(matrix):
	matrix.remove_at(0)
