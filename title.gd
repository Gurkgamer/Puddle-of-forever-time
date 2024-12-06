extends Control

const LEVEL = preload("res://Scene/level.tscn")
@onready var shader_white: Sprite2D = %ShaderWhite
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Travel"):
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(audio_stream_player,"volume_db",-55,5)
		tween.tween_property(shader_white,"modulate:a",1,2).finished.connect(func() -> void:
			var level = LEVEL.instantiate()
			get_parent().add_child(level)
			queue_free()
		)
