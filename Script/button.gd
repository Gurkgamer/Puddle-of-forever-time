extends Node2D

@export var doors_to_open : Array[Node2D]
@export var things_to_free : Array[Node2D]
const FLASH = preload("res://Scene/flash.tscn")
const BUTTON_1 = preload("res://Images/button1.png")
const BUTTON_2 = preload("res://Images/button2.png")

var pressed : bool
var camera : Camera2D

var door_open_counter : int = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if finished : return
	is_in = true
	body.disable_controls = true
	reached_lerp_destination()
	
func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera")
	camera.reached_lerp_destination.connect(_on_reached_lerp_destination)

var is_in : bool = false
var finished: bool = false

func _process(delta: float) -> void:
	if finished :
		disable_button()

var door_please_open

func _on_reached_lerp_destination() -> void:
	if is_in:
		lerping = false
		door_please_open.open()
		reached_lerp_destination()
		
var lerping : bool
func reached_lerp_destination() -> void:
	if !is_in or lerping: return
		
	if finished : return
	
	if door_open_counter < doors_to_open.size():
		var current_door = doors_to_open[door_open_counter]
		door_open_counter +=1
		if !current_door.old_door:
			camera.lerp_camera_to_door(current_door)
			door_please_open = current_door
			lerping = true
		else :
			reached_lerp_destination()
			
				
	if !lerping:
		for door_to_open in doors_to_open :
			if door_to_open.old_door :
				door_to_open.open()
			
		animation_return_player()
		
func animation_return_player() -> void:
	if !is_in : return
	if finished : return
	get_tree().create_timer(1).timeout.connect(func() -> void:
		camera.follow_player()
		%TravelSFX.play()
		var flash_screen = FLASH.instantiate()
		add_child(flash_screen)	
		for thing_to_free in things_to_free:
				thing_to_free.queue_free()
		var player = get_tree().get_first_node_in_group("Player")
		player.get_node("Sprite").play_backwards("travel")
		player.change_player(0)
		player.get_node("Sprite").animation_finished.connect(func() -> void:
			if !%CollisionShape2D.disabled or !finished:
				player.disable_controls = false
				finished = true
				camera.reached_lerp_destination.disconnect
				player.get_node("Sprite").animation_finished.disconnect
				disable_button()
				,CONNECT_ONE_SHOT)
		)
	
func disable_button() -> void:
	if finished : return
	%CollisionShape2D.disabled = true
	var player = get_tree().get_first_node_in_group("Player")
	player.get_node("Sprite").animation_finished.disconnect


func _on_area_2d_button_pressed(body: Node2D) -> void:
	get_node("Sprite2D").texture = BUTTON_2


func _on_area_2d_button_not_pressed(body: Node2D) -> void:
	get_node("Sprite2D").texture = BUTTON_1
