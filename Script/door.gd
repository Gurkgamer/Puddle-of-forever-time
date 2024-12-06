extends Node2D

@export var old_door : bool
const DOOR_NEW_CLOSED = preload("res://Images/SpriteSheet/Forest/door_new_closed.png")
const DOOR_NEW_OPEN = preload("res://Images/SpriteSheet/Forest/door_new_open.png")
const DOOR_OLD_CLOSED = preload("res://Images/SpriteSheet/Forest/door_old_closed.png")
const DOOR_OLD_OPEN = preload("res://Images/SpriteSheet/Forest/door_old_open.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	if old_door :
		get_node("Sprite2D").texture = DOOR_OLD_CLOSED
	else :
		get_node("Sprite2D").texture = DOOR_NEW_CLOSED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open() -> void:
	if !old_door :
		%DoorOpenSFX.play()
	open_clock.call_deferred()
	if old_door:
		get_node("Sprite2D").texture = DOOR_OLD_OPEN
	else : 
		get_node("Sprite2D").texture = DOOR_NEW_OPEN

func open_clock() -> void:
	%Block.disabled = true
