extends Node

func console_message(source, message, type):
	match type:
		"error":
			print_rich("[color=orange]" + str(source.name) + ":[/color] [color=red]" + message + "[/color]")
		"warning":
			print_rich("[color=orange]" + str(source.name) + ":[/color] [color=yellow]" + message + "[/color]")
		"info":
			print_rich("[color=orange]" + str(source.name) + ":[/color] [color=white]" + message + "[/color]")
		"default":
			print_rich(str(source.name) + ": " + message)

func name_node(node: Node,base: String,type: String):
	node.name = base + "_" + type + str(node.get_instance_id())