extends Node2D


func _on_newgame_pressed():
	get_tree().change_scene_to_file("res://node_2d.tscn")


func _on_quit_pressed():
	get_tree().quit() # Replace with function body.
