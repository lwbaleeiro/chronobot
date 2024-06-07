extends Node

var max_health: int = 3
var current_healht: int

signal on_health_changed

func _ready():
	current_healht = max_health

func decrease_health(health_amount: int):
	current_healht -= health_amount;
	
	if current_healht < 0:
		current_healht = 0
	on_health_changed.emit(current_healht)

func increase_health(health_amount: int):
	current_healht += health_amount;
	
	if current_healht > max_health:
		current_healht = max_health
	on_health_changed.emit(current_healht)
