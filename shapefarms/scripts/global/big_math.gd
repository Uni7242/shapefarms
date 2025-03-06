extends Node

var number_suffixes: Dictionary = {
	0:"",
	3:"K",
	6:"M",
	9:"B",
	12:"T",
	15:"Qa",
	18:"Qi",
	21:"Sx",
	24:"Sp",
	27:"Oc",
	30:"No",
	33:"De"
}

#Called thorughout the project
# Takes a notated number vector and returns a formatted string version of the number
func format_number(pair:Vector2) -> String:
	var ret_pair = sanitize_number(pair)
	var multiple = int(ret_pair.y/3)*3
	var suffix = number_suffixes[multiple]
	var ret_str = str(round(ret_pair.x * 100) / 100.0)
	while len(ret_str) > 5:
		ret_str = ret_str.substr(0, ret_str.length() - 1)
	return ret_str + suffix

func sanitize_number(pair:Vector2) -> Vector2:
	var new_pair = pair
	#GlobF.console_message(self,"Sanitizing: " + str(new_pair),"info")
	while new_pair.x >= 1000:
		#GlobF.console_message(self, "Reducing: " + str(new_pair), "info")
		new_pair = Vector2(new_pair.x / 1000, new_pair.y + 3)	
	#GlobF.console_message(self, "Reduced: " + str(new_pair), "info")
	var new_exp = int(new_pair.y)
	var ret_pair = new_pair
	if new_exp % 3 > 0:
		#GlobF.console_message(self, "Rounding: " + str(new_pair), "info")
		ret_pair = Vector2(pair.x * (10 ** (new_exp % 3)), new_exp - (new_exp % 3))
		ret_pair.x = round(ret_pair.x * 10000) / 10000.0
		ret_pair.y = round(ret_pair.y)
	#GlobF.console_message(self, "Final: " + str(ret_pair), "info")
	if ret_pair.x > 0 and ret_pair.y == 0 and ret_pair.x < 1000:
		ret_pair.x = floor(ret_pair.x)
	return ret_pair

#Called by various functions to add base,exp pairs
func add(pair1:Vector2,pair2:Vector2) -> Vector2:
	if pair1.y - pair2.y > 9:
		GlobF.console_message(self, "Difference too large", "warning")
		GlobF.console_message(self, "Pair1: " + str(pair1) + "| Pair2: "+str(pair2), "warning")
		return Vector2(pair1)
	if pair2.y - pair1.y > 9:
		return Vector2(pair2)
	else:
		var high_pair
		var low_pair
		if pair1.y >= pair2.y:
			high_pair = pair1
			low_pair = pair2
		elif pair2.y > pair1.y:
			high_pair = pair2
			low_pair = pair1
		var exp_diff = low_pair.y - high_pair.y
		var ten_multiple = 10 ** exp_diff
		var new_pair = Vector2(low_pair.x * ten_multiple, high_pair.y)
		var ret_pair = Vector2(high_pair.x + new_pair.x, high_pair.y)
		while ret_pair.x >= 1000:
			ret_pair = Vector2(ret_pair.x / 1000, ret_pair.y + 3)
		return ret_pair

#Called by various functions to subtract base,exp pairs
func sub(pair1:Vector2,pair2:Vector2) -> Vector2:
	if pair2.y > pair1.y:
		GlobF.console_message(self, "Result would be negative", "warning")
		return pair1
	elif pair2.y <= pair1.y:
		var high_pair = pair1
		var low_pair = pair2
		var exp_diff = low_pair.y - high_pair.y
		var ten_multiple = 10 ** exp_diff
		var new_amount = pair2.x * ten_multiple
		var ret_pair = Vector2(pair1.x - new_amount, pair1.y)
		if ret_pair.x < 0 or ret_pair.y < 0:
			GlobF.console_message(self, "Result was negative", "warning")
			return Vector2(0,0)
		else:
			while ret_pair.x < 1 and ret_pair.x > 0 and ret_pair.y > 0:
				ret_pair = Vector2(ret_pair.x * 1000, ret_pair.y - 3)
			return ret_pair
	else:
		GlobF.console_message(self, "Error subtracting", "error")
		return pair1

#Called by various functions to multiply base,exp pairs
func mult(pair1:Vector2,pair2:Vector2) -> Vector2:
	#GlobF.console_message(self, "Multiplying: " + str(pair1) + " by " + str(pair2), "info")
	var new_pair = Vector2(pair1.x * pair2.x, pair1.y + pair2.y)
	return new_pair

#Called by various functions to raise base,exp pairs to a power
func exp(pair1:Vector2,pair2:Vector2) -> Vector2:
	var new_pair = Vector2(pair1.x ** pair2.x, pair1.y * pair2.y)
	return new_pair

#Called by various functions to divide base,exp pairs
func div(pair1:Vector2,pair2:Vector2) -> Vector2:
	#GlobF.console_message(self, "Dividing: " + str(pair1) + " by " + str(pair2), "info")
	var new_pair = Vector2(pair1.x / pair2.x, pair1.y - pair2.y)
	return new_pair
