extends TextureButton

class_name CardButton

var img_name

# Custom function that receives the texture asset
func setup(normal_texture_arg: Texture2D, pressed_texture_arg: Texture2D, img_name_arg: String) -> void:
	if normal_texture_arg and pressed_texture_arg:
		# Assigns the image to the default "Normal" state of the button
		texture_normal = normal_texture_arg
		texture_pressed = pressed_texture_arg
		img_name = img_name_arg
	
	else:
		push_warning("Attempted to assign a null texture to TextureButton")
		
func get_img_name() -> String:
	return img_name
