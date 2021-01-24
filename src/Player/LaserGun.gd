extends Spatial

const laser_fire_rate = 0.1
const clip_size = 15
const laser_reload_rate = .5
const ads_acceleration : float = 0.3

export var default_position : Vector3
export var camera_path : NodePath

var camera : Camera
var main : Main
var player : Player

var current_ammo = clip_size
var can_laser_fire = true
var laser_reloading = false

export (PackedScene) var Bullet

func _ready():
	player = self.get_node("../../..")

	current_ammo = clip_size
	camera = get_node(camera_path)
	camera.fov = 70
	
	main = get_tree().get_root().get_node("Main")
	pass

	
func _process(delta):
	if player.alive == false:
		return
		
	if Input.is_action_pressed("primary_fire") and can_laser_fire:
		if current_ammo > 0 and not laser_reloading:
			fire_bullet()
		elif not laser_reloading:
			reload()
	
	if Input.is_action_just_pressed("reload") and not laser_reloading:
		reload()
	
	transform.origin = transform.origin.linear_interpolate(default_position, ads_acceleration)
	pass


func fire_bullet():
	can_laser_fire = false
	current_ammo -= 1
	var bullet : Bullet = Bullet.instance()
	var main : Main = get_tree().get_root().get_node("Main")
	main.add_child(bullet)
	
	bullet.transform = global_transform
	bullet.translation = get_node("Muzzle").global_transform.origin
	
	yield(get_tree().create_timer(laser_fire_rate), "timeout")

	if current_ammo <= 0:
		reload()
		
	can_laser_fire = true
	pass


func reload():
	laser_reloading = true

	yield(get_tree().create_timer(laser_reload_rate), "timeout")

	current_ammo = clip_size
	laser_reloading = false
	pass


