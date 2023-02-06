#### Template file for player setup. Copy and paste and modify as needed.

var ship
var world
const AntiGrav = 0.01
var flying = true
var thrust = 1
var MAX_SPEED = 280
const JUMP_SPEED = 18
var INVERSE_CONTROL = true
var ACCEL = 0.5
var TURN_SPEED = 1.5
var mouse_axis := Vector2()

const MOUSE_SENSITIVITY = 0.002
const MOVE_SPEED = 1.5

var dir = Vector3()
var pre_dir = Vector3()
var rot = Vector3.ZERO
var vel = Vector3()

var movement_input = {
	"turn":0.0,
	"pitch":0.0,
	"rotation":0.0,
	"strafe":0.0,
	"thrust":0.0
}

var hullStrength = 100
var currentHullStrength = 100

const DEACCEL= 0.5
const MAX_SLOPE_ANGLE = 40

var state = "starting"
var target = null

var player = true

var has_disc = false
var disc = null
var disc_in_range = false
var catch_sequence = false
var disabled = []

signal action(act)

var actions:Array = ["target_1","target_2","target_3","target_4","grab","launch","special","disc"]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_action(act):
	#print(act)
	match act:
		"grab":
			pass
		"launch":
			pass
		"special":
			pass
		"disc":
			pass
