extends CanvasLayer

const heart_row_size = 8
const heart_offset = 16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in Global.health:
		var new_heart = Sprite2D.new()
		new_heart.texture = $heart.texture
		new_heart.hframes = $heart.hframes
		$heart.add_child(new_heart)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for heart in $heart.get_children():
		var index = heart.get_index()
		var x = (index % heart_row_size) * heart_offset
		var y = (index / heart_row_size) * heart_offset
		heart.position = Vector2(x,y)
		
		var last_heart = floor(Global.health)
		if index > last_heart:
			heart.frame = 0
		if index == last_heart:
			heart.frame = (Global.health - last_heart) * 4
		if index < last_heart:
			heart.frame = 4
