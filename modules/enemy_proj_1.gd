extends Node2D

@export var speed = 500.0
@onready var body = $projectile_1_body


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * speed * delta


func _on_projectile_1_body_area_entered(area: Area2D) -> void:
	if area.is_in_group("friendly"):
		body.visible = false
		await get_tree().create_timer(0.1).timeout
		queue_free()
		
func _on_timer_timeout():
	queue_free()
