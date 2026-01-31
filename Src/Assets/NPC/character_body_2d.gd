extends CharacterBody2D

@export var speed = 250
@export var knockback_strength = 1000
@export var friction = 800
@export var point : Array[Marker2D]
var current_location
@onready var navagent := $NavigationAgent2D as NavigationAgent2D
var move_direction = Vector2.ZERO
var is_being_knocked_back = false
var current
var poor_talk=[
	"I don't take advice from people who use coupons.",
	"Shoo. Your presence is lowering the property value.",
	"Careful, your desperation is leaking onto the carpet.",
	"I’ve seen better dressed statues in a park."
]
var rich_talk=[
	"Save the poetry for someone who even cares, fancy-pants!",
	"Actin’ rich won't pay your rent, pal",
	"Look at this plastic-wrapped, posh-boy!",
	"Fake it all you want; you're still one of us."
]

func makepath() -> void:
	current_location = point.pick_random()
	navagent.target_position = current_location.global_position

func _ready():
	for child in get_parent().get_children():
		# Check if the child is actually a Marker2D
		if child is Marker2D:
			point.append(child)
	
	makepath()
	current = Global.available_mask.pick_random()
	# Hubungkan sinyal Area2D ke fungsi script ini
	$Hurtbox.body_entered.connect(_on_hurtbox_body_entered)
	# Hubungkan sinyal Timer untuk ganti arah gerak
	$WanderTimer.timeout.connect(_pick_random_direction)
	print(current)
	if current == "Miskin":
		$Miskin.visible = true
	elif current == "Mengengah":
		$Menengah.visible = true
	elif current == "Kaya":
		$Kaya.visible = true
	elif current == "Konglo":
		$Konglo.visible = true
	_pick_random_direction()
	

func _physics_process(delta):
	var dir = to_local(navagent.get_next_path_position()).normalized()
	
	if is_being_knocked_back:
		# Jika sedang terlempar, kecepatan akan berkurang karena gesekan
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		if velocity.length() < 10:
			is_being_knocked_back = false
	else:
		velocity = dir * speed
		
		
	
	move_and_slide()

func _pick_random_direction():
	# Memilih arah acak (x: -1 s/d 1, y: -1 s/d 1)
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	# Randomize waktu tunggu agar tidak bergerak bersamaan
	$WanderTimer.wait_time = randf_range(1, 3)

func _on_hurtbox_body_entered(body):
	if body.is_in_group("player") and body.has_method("apply_knockback"):
		if body.current_mask != current:
			Global.has_food = false
			var knockback_direction = (body.global_position - global_position).normalized()
			# Panggil fungsi yang ada di script player
			body.apply_knockback(knockback_direction * knockback_strength)
			var player_rank_index = Global.available_mask.find(body.current_mask)
			var my_rank_index = Global.available_mask.find(current)
			if player_rank_index < my_rank_index:
				$Label.text = poor_talk.pick_random()
			elif player_rank_index > my_rank_index:
				$Label.text = rich_talk.pick_random()
			$Label.visible = true
			$DialogTimer.start(0)

func apply_knockback(player_position):
	is_being_knocked_back = true
	# Hitung arah dari Player ke NPC
	var knockback_direction = (global_position - player_position).normalized()
	# Pukul NPC ke arah tersebut
	velocity = knockback_direction * knockback_strength



func _on_dialog_timer_timeout() -> void:
	$Label.visible = false


func _on_wander_timer_timeout() -> void:
	makepath()
