extends Spatial


var main : Main

func _ready():
	main = get_tree().get_root().get_node("Main")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EnemySpawn_Timer_timeout():
	var b = preload("res://BallEnemy.tscn")
	var b2 = b.instance()
	b2.translation = $EnemySpawnPos.translation
	main.add_child(b2)
	pass


func _on_Dropzone_area_entered(area):
	if area.has_method("drop"):
		area.drop()
	pass
