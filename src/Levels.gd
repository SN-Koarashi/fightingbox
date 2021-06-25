extends Node2D

func _ready():
	$BossArea.connect("body_entered", $Player, "_on_BossArea_body_entered")
	pass
