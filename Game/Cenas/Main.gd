extends Node2D


var done = false

func _process(delta):
	var texture = $Viewport.get_texture()
	$MainCanvas/Tree/ScrollController/PlantScrollContainer/Control/Screen.texture = texture
		
func _ready() -> void:
	pass
	#Firebase.Auth.connect("login_succeeded", self, "_on_signup_success")
	#Firebase.Auth.connect("signup_succeeded", self, "_on_login_success")
	#Firebase.Auth.connect("login_failed", self, "_on_login_fail")
	#Firebase.Auth.connect("auth_request", self, "_on_auth_request")

	#Firebase.Auth.check_auth_file()
	
func _on_signup_success(result):
	Firebase.Auth.save_auth(result)
	
func _on_login_success(result):
	Firebase.Auth.save_auth(result)

func _on_auth_request(result_code, result_content):
	if result_code == ERR_DOES_NOT_EXIST:
		Firebase.Auth.login_anonymous()

func _on_login_fail(code, message):
	print(code)
	print(message)
