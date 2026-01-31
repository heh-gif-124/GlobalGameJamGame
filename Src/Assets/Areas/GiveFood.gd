extends Area2D
class_name GiveArea
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
func _ready() -> void:
	current = Global.available_mask.pick_random()
	if current == "Miskin":
		$E1.texture = load("res://Src/Sprites/NPC 1/e1.png")
		$E2.texture = load("res://Src/Sprites/NPC 1/e3.png")
	elif current == "Mengengah":
		$E1.texture = load("res://Src/Sprites/NPC 2/e1.png")
		$E2.texture = load("res://Src/Sprites/NPC 2/e3.png")
	elif current == "Kaya":
		$E1.texture = load("res://Src/Sprites/NPC 3/e1.PNG")
		$E2.texture = load("res://Src/Sprites/NPC 3/e3.PNG")
	elif current == "Konglo":
		$E1.texture = load("res://Src/Sprites/NPC 4/e1.PNG")
		$E2.texture = load("res://Src/Sprites/NPC 4/e3.PNG")


func _food_give(body: Node2D) -> void:
	if Global.has_food == true and body.is_in_group("player"):
		var player_rank_index = Global.available_mask.find(body.current_mask)
		var my_rank_index = Global.available_mask.find(current)
		if player_rank_index < my_rank_index:
			$Label.visible = true
			$DissapearTimer.start()
			$Label.text = poor_talk.pick_random()
		elif player_rank_index > my_rank_index:
			$Label.visible = true
			$DissapearTimer.start()
			$Label.text = rich_talk.pick_random()
		else:
			Global.has_food = false
			$CollisionShape2D.queue_free()
			Global.task_completed += 1
			$E2.visible = true
			$E1.visible = false
			print("Food given")
		


func _on_dissapear_timer_timeout() -> void:
	$Label.visible = false
