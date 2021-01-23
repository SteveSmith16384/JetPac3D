extends CPUParticles

var player
export var stop_if_far : bool = true

func _ready():
	var main = get_tree().get_root().get_node("Main")
	player = main.get_node("Player")
	pass


func _on_Timer_timeout():
	if stop_if_far:
		var dist = self.global_transform.origin.distance_to(player.translation)
		self.emitting = dist < Globals.VIEW_RANGE
	pass
