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
func process_movement_fly(obj,delta):
	
	obj.dir = obj.dir.normalized()
	obj.rot = obj.rot.normalized()
	
	#if obj.dir.z < 0 and obj.thrust < obj.MAX_SPEED:
	#	obj.thrust -= 1
	
	obj.vel.y += delta * obj.GRAVITY

	

	var hvel = obj.vel
	var hrot = obj.rot
	#hvel.y = 0

	obj.target = obj.dir
	obj.target *= obj.MAX_SPEED

	var accel
	if obj.dir.dot(hvel) > 0:
		accel = obj.ACCEL
	else:
		accel = obj.ACCEL
	
	#obj.transform.basis = obj.transform.basis.rotated(obj.transform.basis.x,obj.rot.x * 0.01)
	#obj.transform.basis = obj.transform.basis.rotated(obj.transform.basis.y,obj.rot.y * 0.01)
	#obj.transform.basis = obj.transform.basis.rotated(obj.transform.basis.z,obj.rot.z * 0.01)
		
	obj.transform.basis = obj.transform.basis.rotated(obj.transform.basis.x,obj.pitch_input * obj.TURN_SPEED * delta)
	obj.transform.basis = obj.transform.basis.rotated(obj.transform.basis.y,obj.turn_input * obj.TURN_SPEED * delta)
	obj.transform.basis = obj.transform.basis.rotated(obj.transform.basis.z,obj.rotation_input * obj.TURN_SPEED * delta)
	
	
	obj.ship.rotation.y = lerp(obj.ship.rotation.y,-obj.turn_input * obj.TURN_SPEED * delta ,1.5*delta)	
	
	hvel = hvel.linear_interpolate(obj.target, accel * delta)
	obj.vel.x = hvel.x
	obj.vel.y = hvel.y
	obj.vel.z = hvel.z 
	obj.vel = obj.move_and_slide(obj.vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(obj.MAX_SLOPE_ANGLE))
