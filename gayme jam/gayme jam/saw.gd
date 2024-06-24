extends CharacterBody2D

@onready var leftmost = getleftmost()
@onready var rightmost = getrightmost()
var direction = 1

func _ready():
	$AnimatedSprite2D.play('default')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if direction == 1:
		velocity.x = 300
	if direction == -1:
		velocity.x = -300
	if global_position.x >= rightmost and direction == 1:
		direction = -1
	if global_position.x <= leftmost and direction == -1:
		direction = 1
	move_and_slide()


func getleftmost():
	var pos = global_position.x
	return pos - 300

func getrightmost():
	var pos = global_position.x
	return pos + 300


func _on_area_2d_body_entered(body):
	if body.is_in_group('player'):
		body.death()
