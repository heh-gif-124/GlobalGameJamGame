extends Node2D
@export var silly : Array[PackedScene]

var max=5
var current_amount = 0
func _on_timer_timeout() -> void:
	if current_amount < max:
		current_amount += 1
		var b = silly.pick_random().instantiate()
		b.global_position = global_position
		owner.add_child(b)
