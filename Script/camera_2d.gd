extends Camera2D

signal reached_lerp_destination()

var player : CharacterBody2D
var who_follow : Node2D :
	get :
		return who_follow
	set (value):
		who_follow = value
		
var idle : bool = false :
	get :
		return idle
	set (value) :
		idle = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	who_follow = player
	zoom = Vector2(3,3)

const FOLLOW_SPEED : float = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if idle:
		return
	if !move_smooth:
		global_position = who_follow.global_position
	else :
		global_position = global_position.lerp(who_follow.global_position, delta * FOLLOW_SPEED)
		if abs(int(global_position.x) - int(who_follow.global_position.x)) < 10 and  abs(int(global_position.y) - int(who_follow.global_position.y)) < 10:
			idle = true
			reached_lerp_destination.emit()
		
func follow_pig(pig : CharacterBody2D)-> void :
	who_follow = pig
	move_smooth = false
	idle = false
	
func follow_player() -> void :
	move_smooth = false
	who_follow = player
	idle = false

var move_smooth : bool
func lerp_camera_to_door(door : Node2D) -> void:
	idle = false
	who_follow = door
	move_smooth = true
