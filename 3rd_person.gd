extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

### We're using the documented defaults for a kinematic character from Godot's website. We edit it a bit to make sure it can be use for any object.

### The object will need these variables to function

#const GRAVITY = -24.8
#var vel = Vector3()
#const MAX_SPEED = 20
#const JUMP_SPEED = 18
#const ACCEL = 4.5

#var dir = Vector3()

#const DEACCEL= 16
#const MAX_SLOPE_ANGLE = 40


func process_movement_walk(obj,delta):
	
	obj.dir = obj.dir.normalized()
	
	
	obj.vel.y += delta * obj.GRAVITY
	

	var hvel = obj.vel
	#hvel.y = 0

	var target = obj.dir
	target *= obj.MAX_SPEED

	var accel
	if obj.dir.dot(hvel) > 0:
		accel = obj.ACCEL
	else:
		accel =obj.DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta)
	obj.vel.x = hvel.x
	obj.vel.y = hvel.y
	obj.vel.z = hvel.z
	obj.vel = obj.move_and_slide(obj.vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(obj.MAX_SLOPE_ANGLE))
