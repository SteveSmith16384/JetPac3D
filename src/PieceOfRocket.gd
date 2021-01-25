extends Area

var main : Main
var player : Player

var locked_to_player = false
var dropping = false

func _ready():
	main = get_tree().get_root().get_node("Main")
	player = main.get_node("Player")
	pass
	
func _process(delta):
	if locked_to_player:
		var node = player.get_node("Head/Camera/Carrying")
		var pos = node.global_transform.origin
		self.translation = pos
	elif dropping:
		# todo
		pass
	pass
	
	
func drop():
	locked_to_player = false
	dropping = true
	pass
	
	
func collided(coll):
	if dropping:
		return
		
	if locked_to_player:
		return
		
	if coll == player:
		main.play_audio("res://Assets/sfx/Replenish.wav")
		locked_to_player = true
	pass


func _on_RocketMiddle_body_entered(body):
	collided(body)
	pass


func _on_RocketTop_body_entered(body):
	collided(body)
	pass


func _on_Fuel_body_entered(body):
	collided(body)
	pass
	
