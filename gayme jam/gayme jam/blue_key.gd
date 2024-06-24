extends Area2D
signal bluekey
var keytext = 'This key allows you to use your boost on the ground'
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group('player'):
		body.bluekeyed()
		var g = get_tree().get_first_node_in_group('guide')
		g.displaytext(keytext)
		bluekey.emit()
		self.queue_free()
