extends CharacterBody2D

signal player_change(value : bool)
func change_player(value : int) -> void:
	player_change.emit(value)

@onready var sprite: AnimatedSprite2D = %Sprite

const WALK_SPEED : float = 70.0
const RUN_SPEED : float = 70.0

var disable_controls : bool = false :
	get:
		return disable_controls
	set (value):
		if value:
			sprite.play("idle_down")
		disable_controls = value
		
var last_direction : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("idle_down")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player_input(delta)


func player_input(delta : float) -> void:
	if disable_controls:
		return
	
	var direction = Input.get_vector("Left","Right","Up","Down")
	
	if direction.x > 0 :
		sprite.flip_h = false
	elif direction.x < 0 :
		sprite.flip_h = true
	
	if Input.is_action_pressed("Run") :
		velocity = direction * (WALK_SPEED + RUN_SPEED)
	else :
		velocity = direction * WALK_SPEED 
		
	if !direction :
		play_idle()
	else :
		play_walk(Input.is_action_pressed("Run"))
		last_direction = direction
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Travel"):
		pass
		#on_travel()

func play_walk(running : bool) -> void:
	var animation : String = "run" if running else "walk"
	if last_direction.x == 0 and last_direction.y == -1 :
		animation += "_up"
		sprite.play(animation)
	elif last_direction.x != 0 and last_direction.y == 0:
		animation += "_side"
		sprite.play(animation)
	elif last_direction.x == 0 and last_direction.y == 1:
		animation += "_down"
		sprite.play(animation)
		
func play_idle() -> void :
	if last_direction.x == 0 and last_direction.y == -1 :
		sprite.play("idle_up")
	elif last_direction.x != 0 and last_direction.y == 0:
		sprite.play("idle_side")
	elif last_direction.x == 0 and last_direction.y == 1:
		sprite.play("idle_down")

func on_travel():
	if !disable_controls :
		disable_controls = true
		sprite.play("travel")
		sprite.animation_finished.connect(func() -> void: disable_controls = false)
		
var returning : bool
