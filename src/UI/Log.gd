extends TextEdit

const MAX_LINES = 5

var log_text = []

func _ready():
	text = ""
	
	for child in get_children():
		if child is VScrollBar:
			remove_child(child)
		elif child is HScrollBar:
			remove_child(child)  
	pass
	

func clear_log():
	text = ""
	log_text.clear()
	#append_to_log(" ", true)
	pass
	
	
func append_to_log(s:String, clear:bool = false):
	if clear:
		log_text.clear()
	else:
		if log_text.size() > 0:
			if log_text.back() == s:
				# Dupe entry!
				return
				
		while log_text.size() >= MAX_LINES-1:
			log_text.remove(0)
		
	log_text.append(s)

	text = ""
	var line_num: int = 0
	for line in log_text:
		text += line# + "\n"
		line_num += 1
		if line_num <= MAX_LINES-1:
			text += "\n"
	pass
	
