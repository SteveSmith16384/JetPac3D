extends KinematicBody

const value = 50


var main : Main
var player
var speed

func _ready():
	main = get_tree().get_root().get_node("Main")
	player = main.get_node("Player")

	speed = Globals.rnd.randi_range(7, 13)
	
	var mat = SpatialMaterial.new()
	var c = Globals.rnd.randi_range(1, 3)
	match c:
		1: 
			mat.albedo_color = Color(1, 0, 0, 1.0)
		2: 
			mat.albedo_color = Color(0, 1, 0, 1.0)
		3: 
			mat.albedo_color = Color(1, 1, 0, 1.0)
	pass
	$CSGSphere.material_override = mat
	self.look_at(player.translation, Vector3.UP)
	pass
		

func _process(delta):
	if Globals.NO_ENEMIES:
		return
	
	if player.alive == false:
		return
		
	var dir = global_transform.basis.z * delta * -1 * speed
	var col : KinematicCollision = move_and_collide(dir)
	if col:
		if col.collider == player:
			main.collision(col.collider)
			
		queue_free()

	pass



