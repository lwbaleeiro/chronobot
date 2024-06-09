extends NodeState

var bullet = preload("res://player/bullet.tscn")

@export var character_body_2d: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var muzzle: Marker2D

var muzzle_position: Vector2

func on_process(_delta: float):
	pass

func on_physics_process(_delta: float):
	
	gun_muzzle_position()
	if GameInputEvents.shoot_input():
		gun_shooting()
		
	var direction: float = GameInputEvents.movement_input()
	if direction and character_body_2d.is_on_floor():
		transition.emit("Run")

	if GameInputEvents.jump_input():
		transition.emit("Jump")

func enter():
	muzzle.position = Vector2(17, -14)
	muzzle_position = muzzle.position
	animated_sprite_2d.play("shoot_crouch")
	
func exit():
	animated_sprite_2d.stop()
	
func gun_muzzle_position():
	if !animated_sprite_2d.flip_h:
		muzzle.position.x = muzzle_position.x
	elif animated_sprite_2d.flip_h:
		muzzle.position.x = -muzzle_position.x

func gun_shooting():
	var direction: float = -1 if animated_sprite_2d.flip_h == true else 1
	
	var blullet_instance = bullet.instantiate() as Node2D
	blullet_instance.direction = direction
	blullet_instance.move_x_direction = true
	blullet_instance.global_position = muzzle.global_position
	get_parent().add_child(blullet_instance)
