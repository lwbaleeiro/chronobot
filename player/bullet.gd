extends AnimatedSprite2D

var speed: int = 600
var direction: int
var damage_amount: int = 1

var bullet_impact_effect = preload("res://player/bullet_impact_effect.tscn")

func _physics_process(delta: float):
	move_local_x(direction * speed * delta)

func _on_timer_timeout():
	queue_free()

func _on_hit_box_area_entered(_area):
	print("Bullet area entered")

func _on_hit_box_body_entered(_body):
	bullet_impact()

func get_damage_amount() -> int:
	return damage_amount

func bullet_impact():
	var bullect_impact_effect_instace = bullet_impact_effect.instantiate() as Node2D
	bullect_impact_effect_instace.global_position = global_position
	get_parent().add_child(bullect_impact_effect_instace)
	queue_free()
