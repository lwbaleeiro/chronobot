extends CharacterBody2D

const GRAVITY = 1000

var bullet = preload("res://player/bullet.tscn")

@export var speed: int = 1000
@export var max_horizontal_speed: int = 300
@export var slow_down_speed: int = 1900

@export var jump: int = -300
@export var jump_horizontal_speed: int = 1000
@export var max_jump_horizontal_speed: int = 300

enum State {Idle, Run, Jump, Shoot}

var current_state: State
var muzzle_position

@onready var animated = $AnimatedSprite2D
@onready var muzzle: Marker2D = $Muzzle

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
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump
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
		
func input_movement():
	var direction: float = Input.get_axis("move_left", "move_right")
	return direction

func _on_hur_box_body_entered(body: Node2D):
	if body.is_in_group("Enemy"):
		print("Enemy entered: ", body.damage_amount)
		HealthManager.decrease_health(body.damage_amount)
