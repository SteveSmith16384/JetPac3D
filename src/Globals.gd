extends Node

const VERSION = "0.1"
const RELEASE_MODE = true
const DEBUG_START_POS = true and !RELEASE_MODE # If true, uses StartPos in main for player's start position
const NO_ENEMIES = true and !RELEASE_MODE
const SHOW_FPS = true and !RELEASE_MODE
#const VIEW_RANGE = 32
const START_LIVES = 9

var rnd : RandomNumberGenerator

func _ready():
	rnd = RandomNumberGenerator.new()
	rnd.randomize()
	pass
	

