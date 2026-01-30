extends Area2D
class_name CounterArea

func _food_obtain(body: Node2D) -> void:
	Global.has_food = true
	print("Food Obtained")
