extends Node2D

signal ball_out_of_room

var level = 1

func _ready():
	connect("ball_out_of_room", self, "ball_out_of_room")

func _process(delta):
	if Input.is_action_just_released("enter"):
		$StartButton.emit_signal("pressed")


func _on_StartButton_pressed():
	#emit_signal("start_game")
	$StartButton.hide()
	print("start Game")
	$ball.direction = 45
	$ball.speed = 250
	$ball.start = true
	
func load_new_bricks():
	var bricks = get_tree().get_nodes_in_group("bricks")
	for brick in bricks:
		brick.free()
	
	var resource = "res://scenes/level%d.tscn" % level
	var scene = load(resource)
	var node = scene.instance()
	node.position = $bricks.position
	node.z_index = -1
	add_child(node)
	
	
func next_level():
	level += 1
	$ball.reset_ball()
	$pad.set_start_position()
	$ControlPanel/lives.add_live()
	load_new_bricks()
	
	
func show_game_over():
	var image = Image.new()
	image.load("res://images/game_over.png")
	var sprite = Sprite.new() 
	sprite.position = get_viewport().get_texture().get_size()/2
	sprite.texture = ImageTexture.new()
	sprite.texture.create_from_image(image)
	add_child(sprite) 

func ball_out_of_room():
	$ControlPanel/lives.remove_live()
	if $ControlPanel/lives.get_lives_num() <= 0:
		show_game_over()
		$ball.free()
	else:
		$ball.reset_ball()
		$pad.set_start_position()
		load_new_bricks()
