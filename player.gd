extends CharacterBody2D
class_name Player

const SPEED = 300.0
@export var health : int = 100


func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	
	velocity = Input.get_vector("left", "right", "up", "down") * SPEED
	
	move_and_slide()
