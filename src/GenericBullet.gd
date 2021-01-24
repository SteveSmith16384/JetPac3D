class_name Bullet 
extends KinematicBody

# This is for the player's bullets

const SPEED = 20

var main : Main
var player : Player
var dir : Vector3

func _ready():
	main = get_tree().get_root().get_node("Main")
	player = main.get_node("Player")
	$AudioStreamPlayer.play()
	pass


func _process(delta):
	var dir = global_transform.basis.z * delta * -1 * SPEED
	var col : KinematicCollision = move_and_collide(dir)
	if col:
		if "destroyed_by_bullet" in col.collider:
			main.small_explosion(col.collider)
			main.collision(col.collider)
			#col.collider.queue_free()
		else:
			main.tiny_explosion(self)
		queue_free()
	pass


func _on_Timer_timeout():
	queue_free()
	pass
