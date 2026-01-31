extends Node2D

func _process(delta: float) -> void:
	$CanvasLayer/Main_UI/TextureRect/Label.text = str(Global.task_completed)+"/10"
