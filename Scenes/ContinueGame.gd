extends Node2D



func _on_button_pressed():
	if Global.current_level == 1:
		Global.current_level+=1
		Global.task_completed = 0
		get_tree().change_scene_to_file("res://Level2.tscn")
	elif Global.current_level == 2:
		Global.current_level+=1
		Global.task_completed = 0
		get_tree().change_scene_to_file("res://node_2d.tscn")
	


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Src/MainMenu/MainMenu.tscn")# Replace with function body.
