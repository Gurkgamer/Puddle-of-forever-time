extends AudioStreamPlayer

const ORIGINS = preload("res://Audio/BGM/Origins.ogg")
const SMOOTH_AS_GLASS = preload("res://Audio/BGM/Smooth As Glass.ogg")
const A_LITTLE_R___R = preload("res://Audio/BGM/A Little R & R.ogg")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	player.player_change.connect(_on_player_change)

func _on_player_change(value : int) -> void:
	match value:
		0:
			stream = SMOOTH_AS_GLASS
			play()
		1:
			stream = ORIGINS
			play()
		2:
			stream = A_LITTLE_R___R
			play()
