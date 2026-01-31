extends Control

func _ready():
	# Memastikan UI Pause tidak muncul saat awal main
	hide()
	# Pastikan Process Mode di Inspector diset ke "Always"
	process_mode = PROCESS_MODE_ALWAYS

func _process(_delta):
	# Memeriksa input Esc setiap frame
	testEsc()

func resume():
	get_tree().paused = false
	hide()

func paused():
	get_tree().paused = true
	show() # Menampilkan UI saat pause

func testEsc():
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			resume()
		else:
			paused()

func _on_continue_pressed() -> void:
	resume()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	
	# 2. Ganti scene ke Main Menu (Sesuaikan path filenya)
	get_tree().change_scene_to_file("res://Src/MainMenu/MainMenu.tscn")
