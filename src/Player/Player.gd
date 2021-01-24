class_name Player
extends KinematicBody

const speed = 7
const acceleration = 5
const gravity = 0.98
const jetpac_power = 4
const mouse_sensitivity = 0.3

var main : Main

onready var head = $Head
onready var camera = $Head/Camera

var gun

var velocity = Vector3()
var camera_x_rotation = 0

var alive = true

var play_footstep : bool = false
var actually_play_footstep : bool = true

func _ready():
	main = get_tree().get_root().get_node("Main")
	gun = $Head/Camera/gun
	pass
	

func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))

		var x_delta = event.relative.y * mouse_sensitivity
		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90: 
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta
	pass


func _physics_process(delta):
	var head_basis = head.get_global_transform().basis
	
	play_footstep = false
	
	if alive == false:
		velocity.x = 0
		velocity.z = 0
		velocity.y -= gravity
		move_and_slide(velocity, Vector3.UP)
		return
		
	var direction = Vector3()
	if Input.is_action_pressed("move_forward"):
		play_footstep = true
		direction -= head_basis.z
	elif Input.is_action_pressed("move_backward"):
		play_footstep = true
		direction += head_basis.z
	
	if Input.is_action_pressed("move_left"):
		play_footstep = true
		direction -= head_basis.x
	elif Input.is_action_pressed("move_right"):
		play_footstep = true
		direction += head_basis.x

	if Input.is_action_pressed("jump"):
		velocity.y += jetpac_power
		pass
		
	direction = direction.normalized()
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity.y -= gravity
	
	velocity = move_and_slide(velocity, Vector3.UP)
	if get_slide_count() > 0:
		var coll = get_slide_collision(0).get_collider()
		if coll.has_method("collided"):
			coll.collided(self)
		pass
	
	if play_footstep:
		play_footstep()
		
	if self.translation.y < -3:
		var sfx = load("res://Assets/sfx/falling_aagh.wav")
		$AudioStreamPlayer_Generic.stream = sfx
		$AudioStreamPlayer_Generic.play()
		main.player_killed(false)
	pass
	
	
func play_footstep():
	if actually_play_footstep == false:
		return
		
	actually_play_footstep = false
	var sfx = load("res://Assets/sfx/metal_interactions/metal_button_press" + str(Globals.rnd.randi_range(1, 2)) + ".wav")
	$AudioStreamPlayer_Generic.stream = sfx
	$AudioStreamPlayer_Generic.play()
	
	yield(get_tree().create_timer(.45), "timeout")
	actually_play_footstep = true
	pass


func restart(trans):
	self.translation = trans
	alive = true
	pass
	
	
