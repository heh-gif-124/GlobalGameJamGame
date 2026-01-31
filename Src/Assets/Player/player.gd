extends CharacterBody2D

var speed = 220  # speed in pixels/sec
var available_mask = [
	"Miskin",
	"Mengengah",
	"Kaya",
	"Konglo"
	]
var is_knocked_back = false
const max_speed: int = 250
const accel: int = 15
const frict: int = 8
var current_mask = available_mask[0]
func _ready() -> void:
	$Miskin.visible = true
	$Miskin.play("default")
	current_mask = available_mask[0]
func _physics_process(delta):
	var direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	var lerp_weight = delta * (accel if direction else frict)
	velocity = lerp(velocity, direction*max_speed, lerp_weight)
	
	
	_swapping_mask()
	_animation_handler()
	move_and_slide()

func apply_knockback(knockback_force: Vector2):
	velocity = knockback_force
	is_knocked_back = true


func _swapping_mask():
	if Input.is_action_just_pressed("first_mask"):
		current_mask = available_mask[0]
		print("swapped to: "+current_mask)
		$Miskin.visible = true
		$Menengah.visible = false
		$Kaya.visible = false
		$CPUParticles2D.emitting = true
	elif Input.is_action_just_pressed("2nd_mask"):
		current_mask = available_mask[1]
		print("swapped to: "+current_mask)
		$Miskin.visible = false
		$Menengah.visible = true
		$Kaya.visible = false
		$CPUParticles2D.emitting = true
	elif Input.is_action_just_pressed("3rd_mask"):
		current_mask = available_mask[2]
		print("swapped to: "+current_mask)
		$Miskin.visible = false
		$Menengah.visible = false
		$Kaya.visible = true
		$CPUParticles2D.emitting = true
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
	elif  current_mask == available_mask[2]:
		if Global.has_food == true:
			$Kaya.play("has_food")
		else:
			if Input.is_action_pressed("right"):
				$Kaya.play("left_walk")
			elif Input.is_action_pressed("left"):
				$Kaya.play("right_walk_1")
			else:
				$Kaya.play("default")
