extends CharacterBody2D

const GRAVITY = 1000

var bullet = preload("res://player/bullet.tscn")
var player_death_effect = preload("res://player/player_death_effect/player_death_effect.tscn")

@export var speed: int = 1000
@export var max_horizontal_speed: int = 300
@export var slow_down_speed: int = 1900

@export var jump: int = -300
@export var jump_horizontal_speed: int = 1000
@export var max_jump_horizontal_speed: int = 300
@export var jump_count: int = 1

enum State {Idle, Run, Jump, Shoot}

var current_state: State
var muzzle_position
var current_jump_count: int

@onready var animated = $AnimatedSprite2D
@onready var muzzle: Marker2D = $Muzzle
@onready var hit_animation_player = $HitAnimationPlayer

func _ready():
	current_state = State.Idle
	muzzle_position = muzzle.position

func _physics_process(delta: float):
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	player_muzzle_position()
	player_shooting(delta)
	
	move_and_slide()
	
	player_animation()
	
func player_falling(delta: float):
	if not is_on_floor():
		velocity.y += GRAVITY  * delta

func player_idle(_delta: float):
	if is_on_floor():
		current_state = State.Idle

func player_shooting(_delta: float):
	var direction = input_movement()
	
	if direction != 0 and Input.is_action_just_pressed("shoot"):
		var bullet_instance = bullet.instantiate() as Node2D
		bullet_instance.direction = direction
		bullet_instance.global_position = muzzle.global_position
		get_parent().add_child(bullet_instance)
		current_state = State.Shoot

func player_run(delta: float):
	if !is_on_floor():
		return
	
	var direction = input_movement()
	
	if direction:
		velocity.x += direction * speed * delta
		velocity.x = clamp(velocity.x, -max_horizontal_speed, max_horizontal_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, slow_down_speed * delta)
		
	if direction != 0:
		current_state = State.Run
		animated.flip_h = false if direction > 0 else true

func player_jump(delta: float):
	
	var jump_input: bool = Input.is_action_just_pressed("jump")
	
	if is_on_floor() and jump_input:
		current_jump_count = 0
		velocity.y = jump
		current_jump_count += 1
		current_state = State.Jump
		
	if !is_on_floor() and jump_input and current_jump_count < jump_count:
		velocity.y = jump
		current_jump_count += 1
		current_state = State.Jump
		
	if !is_on_floor() and current_state == State.Jump:
		var direction = input_movement()
		velocity.x += direction * jump_horizontal_speed * delta
		velocity.x = clamp(velocity.x, -max_jump_horizontal_speed, max_jump_horizontal_speed)

func player_muzzle_position():
	var direction = input_movement()
	
	if direction > 0:
		muzzle.position.x = muzzle_position.x
	elif direction < 0:
		muzzle.position.x = -muzzle_position.x

func player_animation():
	if current_state == State.Idle:
		animated.play("idle")
	elif current_state == State.Run and animated.animation != "run_shoot":
		animated.play("run")
	elif current_state == State.Jump:
		animated.play("jump") 
	elif current_state == State.Shoot:
		animated.play("run_shoot")

func player_death():
	var player_death_effect_instance = player_death_effect.instantiate() as Node2D
	player_death_effect_instance.global_position = global_position
	get_parent().add_child(player_death_effect_instance) # importante, adicionar ao parent do player pois quando deletar o player a animação não ser deletada junto
	queue_free()

func input_movement():
	var direction: float = Input.get_axis("move_left", "move_right")
	return direction

func _on_hur_box_body_entered(body: Node2D):
	if body.is_in_group("Enemy"):
		HealthManager.decrease_health(body.damage_amount)
		hit_animation_player.play("hit")
	
	if HealthManager.current_healht == 0:
		player_death()
