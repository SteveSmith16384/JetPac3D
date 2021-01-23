class_name Main
extends Spatial


var start_pos : Vector3

var prev_start_pos0 : Vector3
var prev_start_pos1 : Vector3
var start_pos_idx : int = 0

var score : int = 0
var lives : int = Globals.START_LIVES
var invincible = false

var tiny_expl = preload("res://TinyExplosion.tscn")	
var small_expl = preload("res://SmallExplosion.tscn")	
var big_expl = preload("res://BigExplosion.tscn")	


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if Globals.DEBUG_START_POS:
		$Player.translation = $StartPosition.translation
	
	start_pos = $Player.translation
	prev_start_pos0 = $Player.translation
	prev_start_pos1 = $Player.translation
	
	#var tb = load("res://TurretBullet.tscn")
	#tb.connect("bullet_hit", self, "bullet_hit")

	$HUD.update_lives_label(lives)
	$HUD.update_score_label(0)
	pass
	

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://IntroScene.tscn")
		return
		
	if lives <= 0:
		if Input.is_action_just_pressed("primary_fire"):
			get_tree().change_scene("res://IntroScene.tscn")
	pass


func collision(collider):
	if collider == $Player:
		player_killed(true)
	else:
		collider.queue_free()
	pass


func player_killed(play_sfx : bool):
	if $Player.alive == false:
		return
	
	if invincible:
		return
		
	$Player.alive = false
	$Music.stop()
	if play_sfx:
		$Player.get_node("Audio_Hit").play()
	lives = lives - 1
	$HUD.update_lives_label(lives)
	if lives > 0:
		$RestartTimer.start()
	else:
		game_over()
		pass
	pass
	
	
func restart_player():
	$Player.restart(start_pos)
	$Music.play()
	
	invincible = true
	$InvincibleTimer.start()
	pass
	

func _on_RestartTimer_timeout():
	$RestartTimer.stop()
	restart_player()
	pass


func tiny_explosion(spatial):
	#var expl = load("res://TinyExplosion.tscn")	
	var i = tiny_expl.instance()
	add_child(i)
	i.translation = spatial.global_transform.origin
	pass
	
	
func small_explosion(spatial):
	#var small_expl = load("res://SmallExplosion.tscn")	
	var i = small_expl.instance()
	add_child(i)
	i.translation = spatial.global_transform.origin
	pass
	
	
func big_explosion(spatial):
	#var big_expl = load("res://BigExplosion.tscn")	
	var i = big_expl.instance()
	add_child(i)
	i.translation = spatial.global_transform.origin
	pass
	

func play_audio(path):
	var s = load(path)
	$AudioStreamPlayer_Generic.stream = s
	$AudioStreamPlayer_Generic.play()
	

func update_rockets_label(num : int):
	$HUD.update_rockets_label(num)
	pass
	

func update_ammo_label(s : String):
	$HUD.update_ammo_label(s)
	pass
	
	
func play_clang():
	#$Audio_Clang.play()  Too irritating?
	pass
	


func _on_RestartPosTimer_timeout():
	if $Player.alive == false:
		return
		
	if start_pos_idx == 0:
		self.prev_start_pos0 = $Player.translation
		self.start_pos = self.prev_start_pos1
		pass
	else:
		self.prev_start_pos1 = $Player.translation
		self.start_pos = self.prev_start_pos0
		pass
		
	start_pos_idx += 1
	if start_pos_idx > 1:
		start_pos_idx = 0
	pass


func inc_score(spatial):
	if "value" in spatial:
		score += spatial.value
		$HUD.update_score_label(score)
	else:
		print("No score for " + spatial.name)
		pass
	pass


func level_complete():
	$Music.stop()
	$VictoryMusic.play()
	$HUD.show_well_done()
	pass


func game_over():
	$HUD.show_game_over()
	$Music.stop()
	$GameOverMusic.play()
	pass
	
	


func _on_InvincibleTimer_timeout():
	invincible = false
	$InvincibleTimer.stop()
	pass # Replace with function body.
