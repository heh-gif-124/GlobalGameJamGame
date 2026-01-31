extends Area2D
class_name GiveArea
var current
func _ready() -> void:
	current = Global.available_mask.pick_random()


func _food_give(body: Node2D) -> void:
	if Global.has_food == true and body.is_in_group("player"):
		Global.has_food = false
		Global.task_completed += 1
		$E2.visible = true
		$E1.visible = false
		print("Food given")
		
