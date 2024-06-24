extends CharacterBody2D
signal finished
@onready var player = getplayer()
var pdist : Vector2
@onready var timer = $textbox/Timer
@onready var endtimer = $endtimer
@onready var textlabel = $textbox/MarginContainer/Label
@onready var textbox = $textbox
var newtext = ''
func _ready():
	textbox.hide()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	movement()
	pdist = getplayerdistance()
	move_and_slide()

func getplayer():
	var p = get_tree().get_nodes_in_group('player')
	
	return p[0]


func getplayerdistance():
	if player != null:
		var xdist = player.global_position.x - global_position.x
		var ydist = global_position.y - player.global_position.y
		return Vector2(xdist,ydist)
	else:
		return Vector2(0,0)

func movement():
	velocity.x = pdist.x * 1.5
	velocity.y = -pdist.y * 1.5


func displaytext(text):
	endtimer.stop()
	textlabel.text = ''
	textbox.show()
	newtext = text
	for i in newtext:
		textlabel.text = textlabel.text + i
		timer.start(.05)
		await timer.timeout
	endtimer.start(3)



func _on_endtimer_timeout():
	textbox.hide()
