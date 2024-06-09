extends CharacterBody2D

var player_death_effect = preload("res://player/player_death_effect/player_death_effect.tscn")

@onready var animated = $AnimatedSprite2D
@onready var muzzle: Marker2D = $Muzzle

func player_death():
	var player_death_effect_instance = player_death_effect.instantiate() as Node2D
	player_death_effect_instance.global_position = global_position
	get_parent().add_child(player_death_effect_instance) # importante, adicionar ao parent do player pois quando deletar o player a animação não ser deletada junto
	queue_free()

func _on_hur_box_body_entered(body: Node2D):
	if body.is_in_group("Enemy"):
		var tween = get_tree().create_tween()
		tween.tween_property(animated, "material:shader_parameter/enabled", true, 0)
		tween.tween_property(animated, "material:shader_parameter/enabled", false, 0.2)
		HealthManager.decrease_health(body.damage_amount)

	
	if HealthManager.current_healht == 0:
		player_death()
