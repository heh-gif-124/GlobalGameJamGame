extends CharacterBody2D

@export var speed = 100
@export var knockback_strength = 1000
@export var friction = 800

var move_direction = Vector2.ZERO
var is_being_knocked_back = false
var type = ["Miskin", "Mengengah", "Kaya", "Konglo"]
var current
var poor_talk=[
	"I don't take advice from people who use coupons.",
	"Shoo. Your presence is lowering the property value.",
	"Careful, your desperation is leaking onto the carpet.",
	"I’ve seen better dressed statues in a park."
]
var rich_talk=[
	"Acting rich won't pay your rent, pal.",
	"You look like a butler with an identity crisis.",
	"Fake it all you want, you're still one of us."
]

func _ready():
	current = type.pick_random()
	# Hubungkan sinyal Area2D ke fungsi script ini
	$Hurtbox.body_entered.connect(_on_hurtbox_body_entered)
	# Hubungkan sinyal Timer untuk ganti arah gerak
	$WanderTimer.timeout.connect(_pick_random_direction)
	print(current)
	_pick_random_direction()
	

func _physics_process(delta):
	if is_being_knocked_back:
		# Jika sedang terlempar, kecepatan akan berkurang karena gesekan
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		if velocity.length() < 10:
			is_being_knocked_back = false
	else:
		# Pergerakan random biasa
		velocity = velocity.move_toward(move_direction * speed, friction * delta)
	
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
