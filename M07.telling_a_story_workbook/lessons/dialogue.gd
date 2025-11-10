extends Control

@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var next_button: Button = %NextButton
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var body: TextureRect = %Body
@onready var expression: TextureRect = %Expression

var expressions := {
	"happy": preload("res://assets/emotion_happy.png"),
	"regular": preload("res://assets/emotion_regular.png"),
	"sad": preload("res://assets/emotion_sad.png"),
}

var bodies := {
	"sophia": preload("res://assets/sophia.png"),
	"pink": preload("res://assets/pink.png")
}

var dialogue_items: Array[Dictionary] = [
	{
		"expression": expressions["happy"],
		"text": "[wave][b]Hey![/b][/wave] Its been forver since we last met!!",
		"character": bodies["sophia"],
	},
	{
		"expression": expressions["sad"],
		"text": "Yeah, Ive been busy trying to catch up on my classwork.",
		"character": bodies["pink"],
	},
	{
		"expression": expressions["regular"],
		"text": "oh, what is it about?",
		"character": bodies["sophia"],
	},
	{
		"expression": expressions["regular"],
		"text": "Right now, we're learning about [shake][i]Arrays.[/i][/shake]",
		"character": bodies["pink"],
	},
	{
		"expression": expressions["happy"],
		"text": "Oooo that sounds [wave]interesting![/wave]",
		"character": bodies["sophia"],
	},
	{
		"expression": expressions["sad"],
		"text": "It is, its just that it can sometimes be a little [shake]challenging.[shake]",
		"character": bodies["pink"],
	},
	{
		"expression": expressions["happy"],
		"text": "[wave][rainbow val=1.0]You got this![/rainbow][/wave] Learning new things always has its challenges but I know you will be able to overcome them!",
		"character": bodies["sophia"],
	},
	{
		"expression": expressions["happy"],
		"text": "Thanks I really needed that. Nevertheless, I know this will help me become a better [tornado freq=3.0] [rainbow val=1.0]coder!![/rainbow][/tornado]",
		"character": bodies["pink"],
	},
]

var current_item_index := 0 

func _ready() -> void:
	show_text()
	next_button.pressed.connect(advance)

func show_text() -> void:
	var current_item := dialogue_items[current_item_index]
	rich_text_label.text = current_item["text"]
	expression.texture = current_item["expression"]
	rich_text_label.visible_ratio = 0.0
	var tween := create_tween()
	var text_appearing_duration : float = current_item["text"].length() / 30.0 
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)
	var sound_max_offset := audio_stream_player.stream.get_length() - text_appearing_duration
	var sound_start_position := randf() * sound_max_offset
	audio_stream_player.play(sound_start_position)
	tween.finished.connect(audio_stream_player.stop)
	slide_in()
	body.texture = current_item["character"]
	next_button.disabled = true
	tween.finished.connect(func() -> void:
		next_button.disabled = false
		)
	 
func advance() -> void:
	current_item_index += 1
	if current_item_index == dialogue_items.size():
		get_tree().quit()
	else:
		show_text()
		
func slide_in() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	body.position.x = 200.0
	tween.tween_property(body, "position:x", 0.0, 0.85)
	body.modulate.a = 0.0
	tween.parallel().tween_property(body, "modulate:a", 1.0, 0.2)
	
