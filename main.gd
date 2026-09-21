#•  _init(): Called when the node object is first created in memory before it enters the scene tree.
#•  _enter_tree(): Called when the node enters the active scene tree.
#•  _ready(): Called once after all child nodes have also entered the scene tree; ideal for setup.
#•  _process(delta): Called every frame for logic that needs regular updates, where delta is time passed since the last frame.
#•  _physics_process(delta): Called at fixed time intervals; best for physics and movement calculations.
#•  _exit_tree(): Called when the node is about to leave or be removed from the scene tree.


extends Node2D



const PAIRS_LIST = [
	"icone (1).png",
	"icone (2).png",
	"icone (3).png",
	"icone (4).png",
	"icone (5).png",
	"icone (6).png",
	"icone (7).png",
	"icone (8).png",
	"icone (9).png",
	"icone (10).png",
	"icone (11).png",
	"icone (12).png",
	"icone (13).png",
	"icone (14).png",
	"icone (15).png",
	"icone (16).png",
	"icone (17).png",
	"icone (18).png",
	"icone (19).png",
	"icone (20).png",
	"icone (21).png",
	"icone (22).png",
	"icone (23).png",
	"icone (24).png"
]

@onready var input_shield: Control = $InputShield
@onready var grid_container: GridContainer = $ColorRect/GridContainer
@onready var timer: Timer = $Timer
@onready var p_2_points_label: Label = $P2PointsLabel
@onready var p_1_points_label: Label = $P1PointsLabel
@onready var p_2_color_rect: ColorRect = $P2ColorRect
@onready var p_1_color_rect: ColorRect = $P1ColorRect



# Preload your custom button scene
const CARD_SCENE = preload("res://card.tscn")

# Preload the image texture you want to use

const BACK_IMAGE = preload("res://assets/back.png")


var p1_points = 0
var p2_points = 0

var turn = "p1"
var state = "none" #no card is opened, or "first" when one card is opened
var first_card : CardButton



func start():
	print("Game started")
	
	#initializations
	p1_points = 0
	p2_points = 0
	p_1_points_label.text = str(p1_points)
	p_2_points_label.text = str(p2_points)
	turn = "p1"
	p_1_color_rect.color.a = 1.0
	p_2_color_rect.color.a = 0.0
	
	#cards initial arrangements
	var pairs_copy = PAIRS_LIST.duplicate()
	pairs_copy.shuffle() #embaralha
	pairs_copy.resize(6) #reduz tamanho pra 6
	for i in range(pairs_copy.size()-1, -1, -1): #duplicaca todos elementos
		pairs_copy.append(pairs_copy[i])
	pairs_copy.shuffle() #embaralha	
	print("Seis pares de imagens embaralhados")
	print(pairs_copy)
	for child in grid_container.get_children():
		grid_container.remove_child(child)
	for i in range(pairs_copy.size()):
		var image = load("res://assets/"+pairs_copy[i])
		create_button(BACK_IMAGE, image, pairs_copy[i])
	
	
func _ready():
	start()
	
func _on_reset_button_button_up() -> void:
	start()



func create_button(normal_texture_arg: Texture2D, pressed_texture_arg: Texture2D, img_name: String) -> void:
	var button_instance = CARD_SCENE.instantiate()
	button_instance.setup(normal_texture_arg, pressed_texture_arg, img_name)
	button_instance.button_up.connect(func(): _on_button_up(button_instance))
	grid_container.add_child(button_instance)
	
func _on_button_up(clicked_button: CardButton):
	#print("The clicked button was: ", clicked_button.name)
	#print("The clicked button image was: ", clicked_button.get_img_name())
	if state == "none":
		state = "first"
		#clicked_button.disabled = true
		clicked_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		first_card = clicked_button
	elif state == "first":
		#clicked_button.disabled = true
		clicked_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if first_card.get_img_name() == clicked_button.get_img_name():
			if turn == "p1":
				p1_points += 1
				p_1_points_label.text = str(p1_points)
			else:
				p2_points += 1
				p_2_points_label.text = str(p2_points)
				

			input_shield.mouse_filter = Control.MOUSE_FILTER_STOP
			timer.start()
			await timer.timeout	
			input_shield.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
			
			#first_card.visible = false
			first_card.modulate.a = 0.0
			#clicked_button.visible = false
			clicked_button.modulate.a = 0.0
			
		else:
			
			input_shield.mouse_filter = Control.MOUSE_FILTER_STOP
			timer.start()
			await timer.timeout	
			input_shield.mouse_filter = Control.MOUSE_FILTER_IGNORE
			
			first_card.button_pressed  = false
			clicked_button.button_pressed  = false
			
			#first_card.disabled = false
			first_card.mouse_filter = Control.MOUSE_FILTER_STOP
			#clicked_button.disabled = false
			clicked_button.mouse_filter = Control.MOUSE_FILTER_STOP
			
			if turn == "p1":
				turn = "p2"
				p_1_color_rect.color.a = 0.0
				p_2_color_rect.color.a = 1.0
				print("p2 turn")
			else:
				turn = "p1"
				p_1_color_rect.color.a = 1.0
				p_2_color_rect.color.a = 0.0				
				print("p1 turn")				
		
		state = "none"
