extends CharacterBody2D

var projectile_1 = preload("res://scenes/enemy_proj_1.tscn")
var instance
var player = null
var timer = null
var projectile_delay = 0.5
var can_shoot = true
var follow_range = 100.0

@export var health = 100
@export var max_speed = 120.0
@export var acceleration = 10.0

var forward_speed = 0.0


func _ready() -> void:
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(projectile_delay)
	timer.connect("timeout", on_timeout_complete)
	add_child(timer)


func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	
	if player:
		var player_direction = position.direction_to(player.position)
		var distance_to_player = position.distance_to(player.position)
		look_at(player.position)
		
		if distance_to_player > follow_range:
			forward_speed = lerp(forward_speed, max_speed, acceleration * delta)
			velocity = player_direction * forward_speed
		else:
			forward_speed = lerp(forward_speed, 0.0, acceleration * delta)
			velocity = player_direction * forward_speed
			
		if can_shoot == true:
			shoot()
			can_shoot = false
			timer.start()
			
	move_and_slide()


func shoot():
	instance = projectile_1.instantiate()
	instance.transform = transform
	instance.position = global_position + transform.x * 30
	get_parent().add_child(instance)


func on_timeout_complete():
	can_shoot = true

	move_and_slide()


func _on_detect_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("friendly"):
		player = body


func _on_detect_radius_body_exited(body: Node2D) -> void:
	if body.is_in_group("friendly"):
		player = null
