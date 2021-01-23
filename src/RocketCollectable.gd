extends KinematicBody

var destroyed_by_rocket

var main : Main
var player : Player

func _ready():
	main = get_tree().get_root().get_node("Main")
	player = main.get_node("Player")
	pass
	
	
func collided(coll):
	if coll == player:
		player.set_num_rockets(10)
		main.play_audio("res://Assets/sfx/Replenish.wav")
		queue_free()
	pass

