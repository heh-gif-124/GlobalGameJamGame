extends Control
# Drag your 4 mask nodes into this array in the inspector
# Or use get_children() if they are the only children of a node
@export var mask_icons: Array[Node2D] 
var total_seconds = 30 # 5 minutes for example
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("first_mask"):
		update_mask_highlight(0)
	elif Input.is_action_just_pressed("2nd_mask"):
		update_mask_highlight(1)
	elif Input.is_action_just_pressed("3rd_mask"):
		update_mask_highlight(2)
	elif Input.is_action_just_pressed("4th_mask"):
		update_mask_highlight(3)




func _on_game_t_imer_timeout() -> void:
	total_seconds -= 1
	update_timer_display()
	
	if total_seconds <= 0:
		$GameTimer.stop()


func update_timer_display():
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	# This formats it as 00:00
	$TImeLabel.text = "%02d:%02d" % [minutes, seconds]


func update_mask_highlight(selected_index: int):
	for i in range(mask_icons.size()):
		if i == selected_index:
			# Highlighted state (Full color and slightly bigger)
			mask_icons[i].modulate = Color(1, 1, 1, 1) # Normal white
			mask_icons[i].scale = Vector2(0.25, 0.25)
		else:
			# De-selected state (Dimmed and smaller)
			mask_icons[i].modulate = Color(0.3, 0.3, 0.3, 0.7) # Dark/Transparent
			mask_icons[i].scale = Vector2(0.2, 0.2)
