extends Control

@onready var label: RichTextLabel = $VSplitContainer/RichTextLabel
@onready var edit: LineEdit = $VSplitContainer/TextEdit

func _on_text_edit_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if Globals.vars.has(edit.text):
			label.text = "Var '%s' changed to '%s'." % [edit.text, !Globals.vars[edit.text]]
			Globals.vars[edit.text] = !Globals.vars[edit.text]
			return
			
		label.text = "Var '%s' doesn't exist." % edit.text
		print(label.text)
