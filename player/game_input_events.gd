class_name GameInputEvents

extends Node

static func movement_input() -> float:
	return Input.get_axis("move_left", "move_right")
	
static func jump_input() -> bool:
	return Input.is_action_just_pressed("jump")

static func shoot_input() -> bool:
	return Input.is_action_just_pressed("shoot")

static func shoot_up_input() -> bool:
	return Input.is_action_just_pressed("shoot") and Input.is_action_pressed("look_up")

static func crouch_input() -> bool:
	return Input.is_action_just_pressed("crouch")

static func fall_input() -> bool:
	return Input.is_action_just_pressed("force_fall")

static func wall_cling_input() -> bool:
	return Input.is_action_just_pressed("wall_cling")
