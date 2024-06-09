extends NodeState

var bullet = preload("res://player/bullet.tscn")

@export var character_body_2d: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var muzzle: Marker2D

@export_category("Run State")
@export var speed: int = 1000
@export var max_horizontal_speed: int = 300

var muzzle_position: Vector2

func on_process(_delta: float):
	pass

func on_physics_process(delta: float):
	
	var direction: float = GameInputEvents.movement_input()
	
	gun_muzzle_position(direction)
	
	if direction:
		character_body_2d.velocity.x += direction * speed * delta
		character_body_2d.velocity.x = clamp(character_body_2d.velocity.x, -max_horizontal_speed, max_horizontal_speed)
		
	if direction != 0:
		animated_sprite_2d.flip_h = false if direction > 0 else true
	
	if GameInputEvents.shoot_input():
		gun_shooting(direction)
		
	character_body_2d.move_and_slide()
		
func enter():
	muzzle.position = Vector2(18, -26)
	muzzle_position = muzzle.position
	animated_sprite_2d.play("shoot_run")
	
func exit():
	animated_sprite_2d.stop()
	
func gun_muzzle_position(direction: float):
	if direction > 0:
		muzzle.position.x = muzzle_position.x
	elif direction < 0:
		muzzle.position.x = -muzzle_position.x

func gun_shooting(direction: float):
	
	var blullet_instance = bullet.instantiate() as Node2D
	blullet_instance.direction = direction
	blullet_instance.move_x_direction = true
	blullet_instance.global_position = muzzle.global_position
	get_parent().add_child(blullet_instance)
