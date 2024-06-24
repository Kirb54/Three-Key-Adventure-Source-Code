extends Node2D

@onready var player = preload("res://player.tscn")
var respawnpos : Vector2
var testtext = 'You can give yourself a boost by clicking the screen while midair'
@onready var testarea = $Area2D
var introtext = 'Hello, I will be your guide for today'
@onready var introarea = $Area2D2
var keytext = 'Looks like we need to find 3 keys'
@onready var keyarea = $Area2D3
var pink = false
var white = false
var blue = false
var watertext = 'Doesnt seem like you are a very good swimmer'
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func died():
	var c = get_children()
	for i in c:
		if i.is_in_group('guide'):
			i.queue_free()
	var inst = player.instantiate()
	inst.position = respawnpos
	if pink:
		inst.increasemod(3)
	if white:
		inst.bouncenumbchange(3)
	if blue:
		inst.bluekeyed()
	add_child(inst)



func _on_checky_check(pos):
	respawnpos = pos


func _on_checky_2_check(pos):
	respawnpos = pos

func zdex(g):
	var p
	for i in get_children():
		if i.is_in_group('player'):
			p = i
	print(g.z_index)
	print(p.z_index)
	g.z_index = p.z_index + 1


func _on_area_2d_body_entered(body):
	if body.is_in_group('player'):
		var i = getguide()
		i.displaytext(testtext)
		testarea.queue_free()


func _on_area_2d_2_body_entered(body):
	if body.is_in_group('player'):
		var i = getguide()
		i.displaytext(introtext)
		introarea.queue_free()

func getguide():
	return get_tree().get_first_node_in_group('guide')
	


func _on_area_2d_3_body_entered(body):
	if body.is_in_group('player'):
		var i = getguide()
		i.displaytext(keytext)
		keyarea.queue_free()


func _on_checky_4_check(pos):
	respawnpos = pos



func _on_pink_key_pinkkey():
	pink = true
	$pinkborder.queue_free()


func _on_white_key_whitekey():
	white = true
	$whiteborder.queue_free()



func _on_blue_key_bluekey():
	blue = true
	$blueborder.queue_free()


func _on_door_body_entered(body):
	if body.is_in_group('player'):
		get_tree().change_scene_to_file("res://end.tscn")


func _on_area_2d_4_body_entered(body):
	if body.is_in_group('player'):
		var i = getguide()
		i.displaytext(watertext)
		$Area2D4.queue_free()


func _on_area_2d_5_body_entered(body):
	if body.is_in_group('player'):
		var i = getguide()
		i.displaytext('Yippie, you did it!')
		$Area2D5.queue_free()


func _on_area_2d_6_body_entered(body):
	if body.is_in_group('player'):
		var i = getguide()
		i.displaytext('These saws look dangerous')
		$Area2D6.queue_free()
