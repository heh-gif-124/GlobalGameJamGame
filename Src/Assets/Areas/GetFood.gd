extends Area2D
class_name CounterArea
var current_npc
func _ready():
	current_npc = Global.available_mask.pick_random()

func _food_obtain(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.has_food = true
		print("Food Obtained")
