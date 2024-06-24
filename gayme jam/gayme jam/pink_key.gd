extends Area2D
signal pinkkey
var keytext = 'This key allows you to boost farther'
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group('player'):
		body.increasemod(3)
		var g = get_tree().get_nodes_in_group('guide')
		g[0].displaytext(keytext)
		pinkkey.emit()
		self.queue_free()
