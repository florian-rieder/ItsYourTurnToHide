extends Area2D


export(Texture) var texture
export(String) var msg

var coverDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	coverDialog = get_node("..")
	$Sprite.set_texture(texture)
	#generate_collision_polygon_2D(texture)


func _on_Cover_body_entered(body):
	if body.name == "Player":
		body.canInteract(msg,"Cover",self)
		
func _on_Cover_body_exited(body):
	if body.name == "Player":
		body.resetInteract()
		
func try_to_trigger_dialog():
	if coverDialog:
		if coverDialog.has_method("triggerDialog"):
			coverDialog.triggerDialog()

# doesn't work :(
func generate_collision_polygon_2D(texture : Texture):
	var bm = BitMap.new()
	bm.create_from_image_alpha(texture.get_data())
	var rect = Rect2(position.x, position.y, texture.get_width(), texture.get_height())
	var my_array = bm.opaque_to_polygons(rect, 0.0001)
	var my_polygon = Polygon2D.new()
	my_polygon.set_polygons(my_array)
	
	$CollisionPolygon2D.set_polygon(my_polygon.polygons[0])
