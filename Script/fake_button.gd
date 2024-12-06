extends Sprite2D

const BUTTON_1 = preload("res://Images/button1.png")
const BUTTON_2 = preload("res://Images/button2.png")

func _on_area_2d_body_entered(body: Node2D) -> void:
	texture = BUTTON_2


func _on_area_2d_body_exited(body: Node2D) -> void:
	texture = BUTTON_1
