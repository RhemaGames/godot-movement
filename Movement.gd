extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mode = "walk"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func Init(obj,_mode):
	var move_dict = {}
	match _mode:
		"walk": 
			mode = "walk"
			move_dict = {
				"movement_turn_left":[{"key":KEY_A}],
				"movement_turn_right":[{"key":KEY_D}],
				"movement_forward":[{"key":KEY_W}],
				"movement_backward":[{"key":KEY_S}],
				"movement_jump":[{"key":KEY_SPACE}],
				"movement_crouch":[{"key":KEY_CONTROL}],
				"movement_run":[{"key":KEY_SHIFT}],
				"movement_strafe_left":[{"key":KEY_Z}],
				"movement_strafe_right":[{"key":KEY_X}]
			}
			var point = Position3D.new()
			point.name = "ActivePoint"
			obj.add_child(point)
			
		"fly":
			mode = "fly"
			move_dict = {
				"movement_pitch_up":[{"key":KEY_UP}],
				"movement_pitch_down":[{"key":KEY_DOWN}],
				"movement_strafe_left":[{"key":KEY_A}],
				"movement_strafe_right":[{"key":KEY_D}],
				"movement_forward":[{"key":KEY_W}],
				"movement_backward":[{"key":KEY_S}],
				"movement_roll_right":[{"key":KEY_E}],
				"movement_roll_left":[{"key":KEY_Q}],
				"movement_turn_right":[{"key":KEY_RIGHT}],
				"movement_turn_left":[{"key":KEY_LEFT}]
			}
		"drive":
			mode = "drive"
			
	for act in move_dict.keys():
		InputMap.add_action(act)
		for input in move_dict[act]:
			var key = InputEventKey.new()
			key.set_physical_scancode(move_dict[act][0]["key"])
			InputMap.action_add_event(act,key)
		
	

#### We're using the documented defaults for a kinematic character from Godot's website. Edited for use in Mistro instead of needing to be copied and pasted every node.
	
func process_input(obj,disable,inputMap):

	obj.dir = Vector3()
	var anchor = obj.get_node("ActivePoint")
	var cam_xform = anchor.get_global_transform()
	
	match mode:
		"fly":
			if obj.INVERSE_CONTROL:
				obj.movement_input["pitch"] =  Input.get_action_strength("movement_pitch_up") - Input.get_action_strength("movement_pitch_down")
			else:
				obj.movement_input["pitch"]  = Input.get_action_strength("movement_pitch_down") - Input.get_action_strength("movement_pitch_up")
		
			obj.movement_input["rotation"] = Input.get_action_strength("movement_roll_right") - Input.get_action_strength("movement_roll_left")
			obj.movement_input["turn"] = Input.get_action_strength("movement_turn_left") - Input.get_action_strength("movement_turn_right")
			
			if !"thrust" in disable: 
				obj.movement_input["thrust"] = Input.get_action_strength("movement_forward") - Input.get_action_strength("movement_backward")
			else:
				obj.movement_input["thrust"] = 0
			if !"strafe" in disable:
				obj.movement_input["strafe"] = Input.get_action_strength("movement_strafe_right") - Input.get_action_strength("movement_strafe_left")
			else:
				obj.movement_input["strafe"] = 0	

			#input_movement_vector = input_movement_vector.normalized()
			#input_rotation_vector = input_rotation_vector.normalized()

	
			obj.dir += -cam_xform.basis.z * obj.movement_input["thrust"]
			obj.dir += cam_xform.basis.x * obj.movement_input["strafe"]
			
		"walk":
			obj.movement_input["turn"] =  Input.get_action_strength("movement_turn_left") - Input.get_action_strength("movement_turn_right")
			
			if !"walk" in disable: 
				obj.movement_input["walk"] = Input.get_action_strength("movement_forward") - Input.get_action_strength("movement_backward")
			else:
				obj.movement_input["walk"] = 0
				
			if !"strafe" in disable:
				obj.movement_input["strafe"] = Input.get_action_strength("movement_strafe_right") - Input.get_action_strength("movement_strafe_left")
			else:
				obj.movement_input["strafe"] = 0
			
			obj.dir += -cam_xform.basis.z * obj.movement_input["walk"]
			obj.dir += cam_xform.basis.x * obj.movement_input["strafe"]
		
			# ----------------------------------

			# ----------------------------------
			## Jump
			if obj.is_on_floor():
				if Input.is_action_just_pressed("movement_jump"):
					obj.vel.y = obj.JUMP_SPEED
			# ----------------------------------

			# ----------------------------------
			
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# ----------------------------------

	# Game Defined inputs 
	for act in obj.actions:
		if Input.is_action_just_pressed(act):
			obj.emit_signal("action",act)
			
			
# Mouse look

func mouse_input(obj,head,event):
	var sensitivity = 1
		# Mouse look (only if the mouse is captured).
	if obj.MOUSE_SENSITIVITY:
		sensitivity = obj.MOUSE_SENSITIVITY
		
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Horizontal mouse look.
		head.rotation.y -= event.relative.x * sensitivity
		#head.rotation.y -= wrapf(head.rotation.y, 0.0,360.0)
		 #Vertical mouse look.
		head.rotation.x = clamp(head.rotation.x - event.relative.y * sensitivity,-1.57, 1.57)
		
		## This bit is to move the character in relation to the camera. Needs some work
		#obj.rot.x = clamp(obj.rot.x - event.relative.y * sensitivity, -1.57, 1.57)
		#obj.pitch_input = clamp(obj.rot.x - event.relative.y * obj.TURN_SPEED, -1.57, 1.57)
		#obj.turn_input -= event.relative.x * obj.MOUSE_SENSITIVITY
		#obj.transform.basis = Basis(head.rotation)
		
	if event is InputEventMouseButton and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		
		pass
		
func joypad_input(obj,event):
	if event is InputEventJoypadMotion:
		print_debug("Gamepad motion ",event)
	if event is InputEventJoypadButton:
		print_debug("Gamepad button",event)
		

func fly_simple(obj,delta):
	
	obj.dir = obj.dir.normalized()
	obj.rot = obj.rot.normalized()
	
	#if obj.dir.z < 0 and obj.thrust < obj.MAX_SPEED:
	#	obj.thrust -= 1
	
	obj.vel.y += obj.world.GRAVITY - obj.world.ATMO

	

	var hvel = obj.vel
	var hrot = obj.rot
	#hvel.y = 0

	obj.target = obj.dir
	obj.target *= obj.MAX_SPEED

	var accel:float 
	if obj.dir.dot(hvel) > 0:
		accel = obj.ACCEL - (obj.world.GRAVITY + obj.world.ATMO)
	else:
		accel = obj.ACCEL - (obj.world.GRAVITY + obj.world.ATMO)
			
	#obj.transform.basis = obj.transform.basis.rotated(obj.transform.basis.x,obj.rot.x * 0.01)
	#obj.transform.basis = obj.transform.basis.rotated(obj.transform.basis.y,obj.rot.y * 0.01)
	#obj.transform.basis = obj.transform.basis.rotated(obj.transform.basis.z,obj.rot.z * 0.01)
		
	obj.transform.basis = obj.transform.basis.rotated(obj.transform.basis.x.normalized(),(-obj.movement_input["pitch"] * obj.TURN_SPEED * delta))
	obj.transform.basis = obj.transform.basis.rotated(obj.transform.basis.y.normalized(),(obj.movement_input["turn"] * obj.TURN_SPEED * delta))
	obj.transform.basis = obj.transform.basis.rotated(obj.transform.basis.z.normalized(),(-obj.movement_input["rotation"] * obj.TURN_SPEED * delta))
	
	
	#obj.ship.rotation.y = lerp(obj.ship.rotation.y,obj.turn_input * obj.TURN_SPEED * delta ,1.5*delta)	
	
	hvel = hvel.linear_interpolate(obj.target, accel * delta)
	obj.vel.x = hvel.x
	obj.vel.y = hvel.y
	obj.vel.z = hvel.z 
	obj.vel = obj.move_and_slide(obj.vel, Vector3(0, 0, 0), 0.05, 4, deg2rad(obj.MAX_SLOPE_ANGLE))
	#obj.vel = obj.move_and_collide(obj.vel)
	
	

func walk(obj,delta):
	
	obj.dir = obj.dir.normalized()
	
	
	obj.vel.y += obj.world.GRAVITY
	

	var hvel = obj.vel
	#hvel.y = 0

	obj.target = obj.dir
	obj.target *= obj.MAX_SPEED

	var accel
	if obj.dir.dot(hvel) > 0:
		accel = obj.ACCEL
	else:
		accel = obj.DEACCEL + abs(obj.world.GRAVITY) + abs(obj.world.ATMO)
	
	obj.transform.basis = obj.transform.basis.rotated(obj.transform.basis.y.normalized(),(obj.movement_input["turn"] * obj.TURN_SPEED * delta))

	

	hvel = hvel.linear_interpolate(obj.target, accel * delta)
	obj.vel.x = hvel.x
	#obj.vel.y = hvel.y
	obj.vel.z = hvel.z
	obj.vel = obj.move_and_slide(obj.vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(obj.MAX_SLOPE_ANGLE))

	#if obj.vel.length() > 0.2:
	#		var look_direction = Vector2(obj.vel.z,obj.vel.x)
	#		obj.rotation.y = look_direction.angle()
