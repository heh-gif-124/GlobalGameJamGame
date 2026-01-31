extends Node2D
@export var required_tasked : int
func _process(delta: float) -> void:
	$CanvasLayer/Main_UI/TextureRect/Label.text = str(Global.task_completed)+"/"+str(required_tasked)
	if Global.task_completed >= required_tasked:
		get_tree().change_scene_to_file("res://Scenes/ContinueGame.tscn")
		
	
