extends Node2D

func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://Src/Scenes/game.tscn")# Replace with function body.


func _on_exit_pressed():
	get_tree().quit() # Replace with function body.
