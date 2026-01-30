extends Area2D
class_name CounterArea

func _food_obtain(body):
	Global.has_food = true
	print("Food Obtained")
