extends Sprite2D

@export var parallax_strength: Vector2 = Vector2(0.1, 0.05)  # X, Y strength
@export var movement_scale: float = 100.0  # Seberapa jauh bisa bergerak

var base_position: Vector2
var screen_center: Vector2

func _ready():
	base_position = position
	screen_center = get_viewport().get_visible_rect().size / 2

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	
	var normalized_offset = (mouse_pos - screen_center) / screen_center
	
	var parallax_offset = Vector2(
		normalized_offset.x * movement_scale * parallax_strength.x,
		normalized_offset.y * movement_scale * parallax_strength.y
	)
	
	position = base_position + parallax_offset
