extends CharacterBody2D

var health = 100
@export var max_speed = 50.0
@export var max_strafe_speed = 35.0
@export var max_rev_speed = 25.0
@export var acceleration = 5.0
@export var deceleration = 3.0


var forward_speed = 0.0
var strafe_speed_l = 0.0
var strafe_speed_r = 0.0
var reverse_speed = 0.0

@onready var camera = $camera_controller/camera_target/player_cam
@onready var camera_controller = $camera_controller

var rayOrigin = Vector2()
var rayEnd = Vector2()

func get_input(delta):
	# Apply acceleration when moving
	if Input.is_action_pressed("forward"):
		forward_speed = lerp(forward_speed, max_speed, acceleration * delta)
	else:
		forward_speed = lerp(forward_speed, 0.0, deceleration * delta) # Deceleration

	if Input.is_action_pressed("strafe_R"):
		strafe_speed_r = lerp(strafe_speed_r, max_strafe_speed, acceleration * delta)
	else:
		strafe_speed_r = lerp(strafe_speed_r, 0.0, deceleration * delta) # Deceleration

	if Input.is_action_pressed("strafe_L"):
		strafe_speed_l = lerp(strafe_speed_l, max_strafe_speed, acceleration * delta)
	else:
		strafe_speed_l = lerp(strafe_speed_l, 0.0, deceleration * delta) # Deceleration

	if Input.is_action_pressed("reverse"):
		reverse_speed = lerp(reverse_speed, max_rev_speed, acceleration * delta)
	else:
		reverse_speed = lerp(reverse_speed, 0.0, deceleration * delta) # Deceleration

	# Apply movement based on calculated speeds
	velocity = transform.x * forward_speed - transform.x * reverse_speed + transform.y * (strafe_speed_r - strafe_speed_l)



func _physics_process(delta: float) -> void:
	get_input(delta)
	
	look_at(get_global_mouse_position())
	
	camera_controller.position = lerp(camera_controller.position, position, 0.05)

	move_and_slide()
