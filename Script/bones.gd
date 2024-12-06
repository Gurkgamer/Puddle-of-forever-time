extends Node2D

const FLASH = preload("res://Scene/flash.tscn")
@export var travel_destination : CharacterBody2D
@onready var key_prompt: Sprite2D = %KeyPrompt
var is_in : bool
var player : CharacterBody2D
var key_stroke_initial_position : Vector2

func _ready() -> void:
	key_prompt.modulate.a = 0
	key_stroke_initial_position = key_prompt.global_position

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "Player" : return
	key_prompt.visible = true
	is_in = true
	player = body
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(key_prompt, "modulate:a", 1, 0.3)
	tween.tween_property(key_prompt, "global_position:y", global_position.y - 10, 0.3)

var only_once : bool = false

func _input(event: InputEvent) -> void:
	if only_once :
		return
		
	if event.is_action_pressed("Travel") and is_in:
		only_once = true
		player.disable_controls = true
		player.velocity = Vector2.ZERO
		var player_sprite = player.get_node("Sprite")
		player_sprite.play("travel")
		await player_sprite.animation_finished.connect(func() -> void:
			if !player.returning :
				var tween = create_tween()
				var original_modulate = player.modulate
				tween.tween_property(player, "modulate:v", 15, 2).from(1).finished.connect(
					func() -> void:
						if !player.returning :
							var flash_screen = FLASH.instantiate()
							add_child(flash_screen)
							%TravelSFX.play()
							travel_destination.disable_controls = false
							var camera = get_tree().get_first_node_in_group("Camera")
							camera.follow_pig(travel_destination)
							if travel_destination.name == "DinoFifth":
								player.change_player(2)
							else :
								player.change_player(1)
							player.modulate = original_modulate
							player_sprite.animation_finished.disconnect
			,CONNECT_ONE_SHOT)
		,CONNECT_ONE_SHOT)

func _on_area_2d_body_exited(body: Node2D) -> void:
	key_prompt.visible = false
	is_in = false
	key_prompt.modulate.a = 0
	key_prompt.global_position = key_stroke_initial_position
	only_once = false
