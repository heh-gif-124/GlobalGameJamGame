extends CharacterBody2D

var speed = 400  # speed in pixels/sec
var available_mask = [
	"Miskin",
	"Mengengah",
	"Kaya",
	"Konglo"
	]
var current_mask = available_mask[0]
func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	_swapping_mask()
	move_and_slide()

func _swapping_mask():
	if Input.is_action_just_pressed("first_mask"):
		current_mask = available_mask[0]
		print("swapped to: "+current_mask)
	elif Input.is_action_just_pressed("2nd_mask"):
		current_mask = available_mask[1]
		print("swapped to: "+current_mask)
	elif Input.is_action_just_pressed("3rd_mask"):
		current_mask = available_mask[2]
		print("swapped to: "+current_mask)
	elif Input.is_action_just_pressed("4th_mask"):
		current_mask = available_mask[3]
		print("swapped to: "+current_mask)
