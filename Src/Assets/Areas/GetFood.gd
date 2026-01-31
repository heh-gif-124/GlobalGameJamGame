extends Area2D
class_name CounterArea

func _food_obtain(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.has_food = true
		print("Food Obtained")
