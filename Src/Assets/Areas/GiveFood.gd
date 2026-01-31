extends Area2D
class_name GiveArea

func _food_give(body: Node2D) -> void:
	if Global.has_food == true and body.is_in_group("player"):
		Global.has_food = false
		Global.task_completed += 1
		print("Food given")
		
		queue_free()
