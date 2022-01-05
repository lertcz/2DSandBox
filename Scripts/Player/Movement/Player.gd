#https://www.youtube.com/watch?v=mHeh-8xZvBo

extends KinematicBody2D

"""const UP_DIRECTION := Vector2.UP

export var speed := 100

export var jump_strenght := 180
var curGravity := 0
export var maxGravity := 150

var _velocity := Vector2.ZERO

func _physics_process(delta: float) -> void:
	#move
	_velocity.x = 0 # reset the velocity value
	if Input.is_action_pressed("right"):
		_velocity.x += speed
	if Input.is_action_pressed("left"):
		_velocity.x -= speed
	
	#jump
	if Input.is_action_pressed("up") and is_on_floor():
		curGravity = -jump_strenght
	#detect if player hit the ceiling
	if is_on_ceiling():
		curGravity = 0
	#gradualy increase gravity
	if curGravity <= maxGravity:
			curGravity += 6
	_velocity.y = curGravity

	_velocity = move_and_slide(_velocity, UP_DIRECTION)"""

const JUMP_FORCE = 300
const MOVE_SPEED = 150
const GRAVITY = 15
var pullRate = 0
const MAX_SPEED = 500

const FRICTION_GND = 0.1
const FRICTION_AIR = 0.8

var velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# walking
	var walk = (Input.get_action_strength("right") - Input.get_action_strength("left")) * MOVE_SPEED
	
	# falling
	velocity.y = pullRate
	
	velocity.x += walk
	move_and_slide(velocity, Vector2.UP)
	velocity.x -= walk
	
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)

	if is_on_floor():
		velocity.x *= FRICTION_GND
		if velocity.y >= 50:
			velocity.y = 50
			
	elif is_on_ceiling():
		pullRate = 0
	
	if !is_on_floor():
		#make gradualy falling faster
		if pullRate < 400:
			pullRate += GRAVITY
		
		velocity.x *= FRICTION_AIR
	
	#jumping
	if Input.is_action_just_pressed("up"):
		if is_on_floor():
			pullRate = -JUMP_FORCE
