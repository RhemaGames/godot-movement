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

#### We're using the documented defaults for a kinematic character from Godot's website. Edited for use in Mistro instead of needing to be copied and pasted every node.
	
func process_input(obj,camera,delta):

	# ----------------------------------
	# Walking
	obj.dir = Vector3()
	var cam_xform = camera.get_global_transform()

	var input_movement_vector = Vector2.ZERO
	var input_rotation_vector = Vector3.ZERO

	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("movement_strafe_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("movement_strafe_right"):
		input_movement_vector.x += 1
#	if Input.is_action_pressed("movement_roll_left"):
#		input_rotation_vector.z -= 1
#	if Input.is_action_pressed("movement_roll_right"):
#		input_rotation_vector.z += 1
	
#	if Input.is_action_pressed("ui_up"):
#		input_rotation_vector.x += 1
#	if Input.is_action_pressed("ui_down"):
#		input_rotation_vector.x -= 1
#	
#	if Input.is_action_pressed("ui_left"):
#		input_rotation_vector.y += 1
#	if Input.is_action_pressed("ui_right"):
#		input_rotation_vector.y -= 1
		
	if obj.INVERSE_CONTROL:
		obj.pitch_input =  Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	else:
		obj.pitch_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
	#obj.turn_input = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right") 
	obj.rotation_input = Input.get_action_strength("movement_roll_right") - Input.get_action_strength("movement_roll_left")
	obj.thrust_input = Input.get_action_strength("movement_forward") - Input.get_action_strength("movement_backward")
	obj.strafe_input = Input.get_action_strength("movement_strafe_right") - Input.get_action_strength("movement_strafe_left")

	input_movement_vector = input_movement_vector.normalized()
	input_rotation_vector = input_rotation_vector.normalized()

	# Basis vectors are already normalized.
	obj.dir += -cam_xform.basis.z * input_movement_vector.y
	obj.dir += cam_xform.basis.x * input_movement_vector.x
	#obj.rot.x += input_rotation_vector.x 
	#obj.rot.z += input_rotation_vector.z 
	#obj.rot.y += input_rotation_vector.y 
		
	# ----------------------------------

	# ----------------------------------
	# Jump
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

func mouse_input(obj,event):
		# Mouse look (only if the mouse is captured).
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Horizontal mouse look.
		#obj.rot.y -= event.relative.x * obj.MOUSE_SENSITIVITY
		# Vertical mouse look.
		#obj.rot.x = clamp(obj.rot.x - event.relative.y * obj.MOUSE_SENSITIVITY, -1.57, 1.57)
		#obj.pitch_input = clamp(obj.rot.x - event.relative.y * obj.TURN_SPEED, -1.57, 1.57)
		#obj.turn_input -= event.relative.x * obj.MOUSE_SENSITIVITY
		#obj.transform.basis = Basis(obj.rot)
		pass
