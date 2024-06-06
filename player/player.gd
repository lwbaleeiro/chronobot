extends CharacterBody2D

const GRAVITY = 1000
const SPEED = 300
const JUMP = -300
const HORIZONTAL_JUMP = 100

enum State {Idle, Run, Jump}

var current_state

@onready var animated = $AnimatedSprite2D

func _ready():
	current_state = State.Idle

func _physics_process(delta):
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	
	move_and_slide()
	player_animation()
	
func player_falling(delta):
	if not is_on_floor():
		velocity.y += GRAVITY  * delta

func player_idle(delta):
	if is_on_floor():
		current_state = State.Idle

func player_jump(delta):
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP
		current_state = State.Jump
		
	if not is_on_floor() and current_state == State.Jump:
		var direction = Input.get_axis("move_left", "move_right")
		velocity.x += direction * HORIZONTAL_JUMP * delta

func player_run(delta):
	if not is_on_floor():
		return
	
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction != 0:
		current_state = State.Run
		animated.flip_h = false if direction > 0 else true

func player_animation():
	if current_state == State.Idle:
		animated.play("idle")
	elif current_state == State.Run:
		animated.play("run")
	elif current_state == State.Jump:
		animated.play("jump") 
