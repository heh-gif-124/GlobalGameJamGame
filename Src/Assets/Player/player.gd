extends CharacterBody2D

var speed = 250  # speed in pixels/sec
var available_mask = [
	"Miskin",
	"Mengengah",
	"Kaya",
	"Konglo"
	]
func _ready() -> void:
	$Miskin.visible = true
	$Miskin.play("default")
var current_mask = available_mask[0]
func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	_swapping_mask()
	_animation_handler()
	move_and_slide()

func _swapping_mask():
	if Input.is_action_just_pressed("first_mask"):
		current_mask = available_mask[0]
		print("swapped to: "+current_mask)
		$Miskin.visible = true
		$Menengah.visible = false
	elif Input.is_action_just_pressed("2nd_mask"):
		current_mask = available_mask[1]
		print("swapped to: "+current_mask)
		$Miskin.visible = false
		$Menengah.visible = true
	elif Input.is_action_just_pressed("3rd_mask"):
		current_mask = available_mask[2]
		print("swapped to: "+current_mask)
	elif Input.is_action_just_pressed("4th_mask"):
		current_mask = available_mask[3]
		print("swapped to: "+current_mask)

func _animation_handler():
	if current_mask == available_mask[0]:
		if Global.has_food == true:
			$Miskin.play("has_food")
		else:
			if Input.is_action_pressed("right"):
				$Miskin.play("left_walk")
			elif Input.is_action_pressed("left"):
				$Miskin.play("right_walk_1")
			else:
				$Miskin.play("default")
	elif  current_mask == available_mask[1]:
		if Global.has_food == true:
			$Menengah.play("has_food")
		else:
			if Input.is_action_pressed("right"):
				$Menengah.play("left_walk")
			elif Input.is_action_pressed("left"):
				$Menengah.play("right_walk_1")
			else:
				$Menengah.play("default")
