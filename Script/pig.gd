extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = %Sprite
const WALK_SPEED : float = 70.0
const RUN_SPEED : float = 70.0

var starting_position : Vector2
var disable_controls : bool = true :
	get:
		return disable_controls
	set(value):
		if value:
			sprite.play("idle")
		disable_controls = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	starting_position = global_position
	%Grey.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if disable_controls:
		return
	
	%Grey.visible = true
	var direction = Input.get_vector("Left","Right","Up","Down")
	
	if direction.x > 0 :
		sprite.flip_h = true
	elif direction.x < 0 :
		sprite.flip_h = false
		
	velocity = direction * WALK_SPEED
	if direction:
		if Input.is_action_pressed("Run"):
			sprite.play("run")
			velocity = direction * (WALK_SPEED + RUN_SPEED)
		else :
			sprite.play("walk")
	else :
		sprite.play("idle")
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if disable_controls :
		return 
	if event.is_action_pressed("Return") :
		var camera = get_tree().get_first_node_in_group("Camera")	
		camera.follow_player()
		%TravelSFX.play()
		var flash_screen = FLASH.instantiate()
		add_child(flash_screen)
		disable_controls = true
		global_position = starting_position
		%Grey.visible = false
		var player = get_tree().get_first_node_in_group("Player")
		player.get_node("Sprite").play_backwards("travel")
		player.change_player(0)
		player.returning = true
		player.get_node("Sprite").animation_finished.connect(func() -> void:
				player.disable_controls = false
				player.returning = false
				,CONNECT_ONE_SHOT)
			
const FLASH = preload("res://Scene/flash.tscn")
