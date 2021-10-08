extends TextureRect

export var rate : float = 1

func _process(delta):
	if(abs(margin_left) < texture.get_size().x):
		margin_left -= delta * rate
	else:
		margin_left = 0
