# Game.gd - attach ke root node Game
extends Node2D

@export var target_score: int = 10
@export var time_limit: float = 10.0  # 10 detik waktu main

var current_score: int = 0
var game_active: bool = true
var time_left: float = 0

@onready var task_label: Label = $CanvasLayer/Control/TaskLabel
@onready var back_button: Button = $CanvasLayer/Control/BackButton
@onready var timer_label: Label = $CanvasLayer/Control/TimerLabel
@onready var game_timer: Timer = $GameTimer
@onready var pause_menu = $PauseMenu

func _ready():
	print("🎮 Game Scene Loaded")
	
	# Setup waktu
	time_left = time_limit
	update_task_display()
	update_timer_display()
	
	# Connect button
	back_button.pressed.connect(_on_back_pressed)
	
	# Setup input jika belum ada
	if not InputMap.has_action("add_score"):
		var action = InputEventKey.new()
		action.keycode = KEY_F
		InputMap.add_action("add_score")
		InputMap.action_add_event("add_score", action)

	
	# Start timer
	if game_timer:
		game_timer.wait_time = 1.0  # Update setiap 1 detik
		game_timer.timeout.connect(_on_game_timer_timeout)
		game_timer.start()
	else:
		print("⚠️ GameTimer node not found!")

func _process(_delta):
	# Check for F key press
	if Input.is_action_just_pressed("add_score") and game_active:
		add_score(1)
	
	# Check win condition
	if current_score >= target_score and game_active:
		game_won()

func _on_game_timer_timeout():
	if not game_active:
		return
	
	time_left -= 1.0
	update_timer_display()
	
	# Check jika waktu habis
	if time_left <= 0:
		game_over()

func update_timer_display():
	if timer_label:
		# Format waktu: 00:10
		var minutes = int(time_left) / 60
		var seconds = int(time_left) % 60
		timer_label.text = "TIME: %02d:%02d" % [minutes, seconds]
		
		# Ubah warna berdasarkan waktu
		if time_left <= 3.0:
			timer_label.modulate = Color.RED
			# Tambah efek berkedip
			timer_label.visible = fmod(time_left, 0.5) > 0.25
		elif time_left <= time_limit * 0.3:
			timer_label.modulate = Color.YELLOW
		else:
			timer_label.modulate = Color.WHITE

func add_score(points: int):
	if not game_active:
		return
	
	current_score += points
	print("➕ Score added: ", points, " | Total: ", current_score, " | Time left: ", time_left)
	update_task_display()
	
	# Visual feedback
	show_score_popup(points)

func show_score_popup(points: int):
	var popup = Label.new()
	popup.text = "+%d" % points
	popup.modulate = Color.GREEN
	popup.position = Vector2(
		randf_range(200, 600),
		randf_range(150, 400)
	)
	
	# Tambah ke scene
	$CanvasLayer/Control.add_child(popup)
	
	# Animasi
	var tween = create_tween()
	tween.tween_property(popup, "position:y", popup.position.y - 50, 0.5)
	tween.parallel().tween_property(popup, "modulate:a", 0.0, 0.5)
	tween.tween_callback(popup.queue_free)

func update_task_display():
	if task_label:
		task_label.text = "TASK: %d/%d" % [current_score, target_score]
		
		# Change color based on progress
		var progress = float(current_score) / target_score
		if progress >= 1.0:
			task_label.modulate = Color.GREEN
		elif progress >= 0.7:
			task_label.modulate = Color.YELLOW
		else:
			task_label.modulate = Color.WHITE

func game_won():
	if not game_active:
		return
	
	game_active = false
	print("🎉 TASK COMPLETED!")
	
	# Stop timer
	if game_timer:
		game_timer.stop()
	
	# Tampilkan pesan kemenangan singkat (opsional)
	show_quick_win_message()
	
	# Tunggu sebentar lalu pindah ke ContinueGame
	await get_tree().create_timer(1.5).timeout  # 1.5 detik delay
	go_to_continue_screen()

func show_quick_win_message():
	var win_label = Label.new()
	win_label.text = "LEVEL COMPLETE!"
	win_label.modulate = Color.GREEN
	win_label.position = Vector2(300, 150)
	win_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	$CanvasLayer/Control.add_child(win_label)
	
	# Animasi fade out
	var tween = create_tween()
	tween.tween_property(win_label, "modulate:a", 0.0, 1.0)
	tween.tween_callback(win_label.queue_free)

func go_to_continue_screen():
	print("🏆 Moving to Continue Game...")
	
	# Cek apakah file ContinueGame.tscn ada
	var continue_path = "res://Src/Scenes/ContinueGame.tscn"
	
	# Debug: cek file exist
	if FileAccess.file_exists(continue_path):
		get_tree().change_scene_to_file(continue_path)
	else:
		print("❌ ContinueGame.tscn not found at:", continue_path)
		print("   Falling back to Main Menu...")
		
		# Coba beberapa path alternatif
		var possible_paths = [
			"res://ContinueGame.tscn",
			"res://Scenes/ContinueGame.tscn",
			"res://Src/ContinueGame.tscn",
			"res://Continue.tscn"
		]
		
		for path in possible_paths:
			if FileAccess.file_exists(path):
				print("✅ Found at:", path)
				get_tree().change_scene_to_file("res://Src/Scenes/ContinueGame.tscn")
				return
		
		# Jika tidak ditemukan, ke Main Menu
		get_tree().change_scene_to_file("res://Src/Scenes/MainMenu.tscn")

# Di Game.gd, GANTI fungsi game_over():

func game_over():
	if not game_active:
		return
	
	game_active = false
	print("⏰ TIME'S UP! GAME OVER")
	
	# Stop timer
	if game_timer:
		game_timer.stop()
	
	# Pindah ke GameOver scene dengan data
	go_to_game_over_screen()

func go_to_game_over_screen():
	# Load GameOver scene
	var game_over_scene = preload("res://Src/Scenes/GameOver.tscn")
	if game_over_scene:
		var game_over_instance = game_over_scene.instantiate()
		
		# Pass data ke GameOver scene
		# Kita perlu cek apakah GameOver scene punya script dengan fungsi setup()
		if game_over_instance.has_method("setup"):
			game_over_instance.setup(current_score, target_score, time_limit - time_left)
		
		# Pindah scene
		get_tree().change_scene_to_packed(game_over_scene)
	else:
		print("❌ GameOver scene not found!")
		# Fallback: tampilkan game over di scene yang sama
		show_game_over_fallback()

func show_game_over_fallback():
	# Fallback jika GameOver scene tidak ada
	var game_over_label = Label.new()
	game_over_label.text = "GAME OVER!\nScore: %d/%d\nTime: %.1fs" % [current_score, target_score, time_limit - time_left]
	game_over_label.modulate = Color.RED
	game_over_label.position = Vector2(300, 150)
	game_over_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	$CanvasLayer/Control.add_child(game_over_label)
	
	# Tambah retry button
	var retry_button = Button.new()
	retry_button.text = "RETRY"
	retry_button.position = Vector2(350, 250)
	retry_button.pressed.connect(_on_retry_pressed_fallback)
	$CanvasLayer/Control.add_child(retry_button)
	
	# Tambah menu button
	var menu_button = Button.new()
	menu_button.text = "MAIN MENU"
	menu_button.position = Vector2(350, 300)
	menu_button.pressed.connect(_on_menu_pressed_fallback)
	$CanvasLayer/Control.add_child(menu_button)

func _on_retry_pressed_fallback():
	# Reset game
	reset_game()	
	
	# Hapus UI fallback
	for child in $CanvasLayer/Control.get_children():
		if child is Button or (child is Label and child.text.begins_with("GAME OVER")):
			child.queue_free()

func _on_menu_pressed_fallback():
	_on_back_pressed()

func _on_back_pressed():
	print("🔙 Returning to Main Menu")
	get_tree().change_scene_to_file("res://Src/Scenes/MainMenu.tscn")

func reset_game():
	current_score = 0
	game_active = true
	time_left = time_limit
	update_task_display()
	update_timer_display()
	
	# Hapus message labels
	for child in $CanvasLayer/Control.get_children():
		if child is Label and (child.text.begins_with("LEVEL") or child.text.begins_with("GAME")):
			child.queue_free()
	
	# Restart timer
	if game_timer:
		game_timer.start()
