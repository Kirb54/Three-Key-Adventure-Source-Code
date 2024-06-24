extends CharacterBody2D
signal died

const SPEED = 350.0
const JUMP_VELOCITY = -400.0
var direction = 1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var boostnumb = 1
var boostmax = 1
@onready var anim = $AnimatedSprite2D
var wallclinging = false
var wallkick = 300
@onready var dwallkick = $disablewallkick
var bouncemod = 2
@onready var boostcool = $boostcool
var dead = false
@onready var deadtimer = $deathtimer
@onready var guide = preload("res://guide.tscn")
var bluekey = false

func _ready():
	if gm.god:
		increasemod(3)
		bouncenumbchange(3)
		bluekeyed()
func _physics_process(delta):
	if not dead:
		grav(delta)
		jump()
		run(delta)
		boost()
		boostrecharge()
		move_and_slide()
		animations()
		walljump()
		tryspawn()
		reset()


func grav(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
func jump():
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif wallclinging:
			velocity.y = JUMP_VELOCITY
			velocity.x = -direction * wallkick
			wallclinging = false
			direction *= -1
			dwallkick.start()

func run(delta):
	if dwallkick.time_left == 0:
		if Input.is_action_pressed('ui_left'):
			direction = -1
			if velocity.x > direction * SPEED:
				velocity.x = direction * SPEED
		elif Input.is_action_pressed('ui_right'):
			
			direction = 1
			if velocity.x < direction * SPEED:
				velocity.x = direction * SPEED
		else:
			
			velocity.x = move_toward(velocity.x, 0, 30)
	
func boost():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and boostnumb > 0 and boostcool.time_left == 0:
		if not is_on_floor() or bluekey:
			boostnumb -= 1
			boostcool.start()
			var mousepos = get_local_mouse_position()
			var mousex = mousepos.x
			var mousey = mousepos.y
			if mousex > 500:
				mousex = 500
			if mousex < -500:
				mousex = -500
			if mousey > 150:
				mousey = 150
			if mousey < -300:
				mousey = -300
			velocity.x += -mousex * bouncemod
			velocity.y += -mousey * bouncemod



func boostrecharge():
	if is_on_floor():
		boostnumb = boostmax



func animations():
	if velocity.x == 0 and velocity.y == 0 and not wallclinging:
		anim.play('idle')
		if direction == -1:
			anim.flip_h = true
		else:
			anim.flip_h = false
	if velocity.x != 0 and is_on_floor():
		anim.play('run')
		if direction == -1:
			anim.flip_h = true
		else:
			anim.flip_h = false
	if velocity.y != 0 and not is_on_floor() and boostnumb > 0 and not wallclinging:
		if velocity.y > 0:
			anim.play('jump down')
		else:
			anim.play('jump up')
		if direction == -1:
			anim.flip_h = true
		else:
			anim.flip_h = false
	if boostnumb <= 0:
		anim.animation = "boost"
		if direction == -1:
			anim.flip_h = true
		else:
			anim.flip_h = false
	if wallclinging:
		anim.play("walljump")
		if direction == -1:
			anim.flip_h = true
		else:
			anim.flip_h = false
	
func walljump():
	if is_on_wall_only() and dwallkick.time_left == 0:
		wallclinging = true
		boostnumb = boostmax
		velocity.x = 0
		velocity.y = 0
	else: 
		wallclinging = false
	


func _on_disablewallkick_timeout():
	pass # Replace with function body.

func death():
	if not dead:
		dead = true
		anim.play('death')
		deadtimer.start()
		await deadtimer.timeout
		self.queue_free()
		var lvl = get_tree().get_nodes_in_group('lvl')
		for i in lvl:
			i.died()

func spawnguide():
	var inst = guide.instantiate()
	inst.global_position = global_position
	var lvl = get_tree().get_nodes_in_group('lvl')
	for i in lvl:
		i.add_child(inst)
	



func tryspawn():
	
	if get_tree().get_nodes_in_group('guide') == []:
		spawnguide()


func increasemod(n):
	bouncemod = n

func bouncenumbchange(n):
	boostmax = n
func bluekeyed():
	bluekey = true

func reset():
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().reload_current_scene()
