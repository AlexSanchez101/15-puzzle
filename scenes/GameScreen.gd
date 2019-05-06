extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var MATRIX_SIZE = 4



func create_matrix(w, h):
	var matrix = []
	
	for x in range(h):
		var col = []
		col.resize(w)
		matrix.append(col)
	
	return matrix
	
var matrix = create_matrix(MATRIX_SIZE, MATRIX_SIZE)

func swap_squares(square_1, square_2):
	var temp = {}
	temp.index = square_1.index
	temp.text = square_1.text
	temp.disabled = square_1.disabled
	temp.visible = square_1.visible
	
	
	square_1.index = square_2.index
	square_1.text = square_2.text
	square_1.disabled = square_2.disabled
	square_1.visible = square_2.visible
	
	square_2.index = temp.index
	square_2.text = temp.text
	square_2.disabled = temp.disabled
	square_2.visible = temp.visible
	
func shuffle():
	var squares = get_tree().get_nodes_in_group("Squares")
	#i - columns, j - rows
	var i = 0
	var j = 0
	var index = 1
	for square in squares:
		square.disabled = false
		square.index = index
		square.text = str(index)
		square.connect("pressed", self, "_square_pressed", [i,j])
		matrix[i][j] = square
		index += 1
		i += 1
		if i == 4:
			i = 0
			j += 1
	var empty_square_position = { "i": MATRIX_SIZE - 1, "j": MATRIX_SIZE - 1 } #The "empty" square is always last
	matrix[empty_square_position.i][empty_square_position.j].disabled = true
	randomize()
	for count in range(150):
		var direction = randi()%4 #0 - up, 1 - right, 2 - down, 3 - left
		
		if direction == 0 && empty_square_position.j != 0: #up
			swap_squares(matrix[empty_square_position.i][empty_square_position.j], matrix[empty_square_position.i][empty_square_position.j - 1])
			empty_square_position.j = empty_square_position.j - 1
			
		if direction == 1 && empty_square_position.i != MATRIX_SIZE - 1: #right
			swap_squares(matrix[empty_square_position.i][empty_square_position.j], matrix[empty_square_position.i + 1][empty_square_position.j])
			empty_square_position.i = empty_square_position.i + 1
		
		if direction == 3 && empty_square_position.i != 0: #left
			swap_squares(matrix[empty_square_position.i][empty_square_position.j], matrix[empty_square_position.i - 1][empty_square_position.j])
			empty_square_position.i = empty_square_position.i - 1
			
		if direction == 3 && empty_square_position.j != MATRIX_SIZE - 1: #up
			swap_squares(matrix[empty_square_position.i][empty_square_position.j], matrix[empty_square_position.i][empty_square_position.j + 1])
			empty_square_position.j = empty_square_position.j + 1
	

# Called when the node enters the scene tree for the first time.
func _ready():
	shuffle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _square_pressed(i,j): #i - columns, j - rows
	#print(i,";", j)
	if (i != 0) && (matrix[i - 1][j].index == MATRIX_SIZE*MATRIX_SIZE):
		swap_squares(matrix[i][j], matrix[i - 1][j])
		#print("Left")
	elif (i != MATRIX_SIZE - 1) && (matrix[i + 1][j].index == MATRIX_SIZE*MATRIX_SIZE):
		swap_squares(matrix[i][j], matrix[i + 1][j])
		#print("Right")
	elif (j != 0) && (matrix[i][j - 1].index == MATRIX_SIZE*MATRIX_SIZE):
		swap_squares(matrix[i][j], matrix[i][j - 1])
		#print("Top")
	elif (j != MATRIX_SIZE - 1) && (matrix[i][j + 1].index == MATRIX_SIZE*MATRIX_SIZE):
		swap_squares(matrix[i][j], matrix[i][j + 1])
		#print("Bottom")
	
	var victory = true
	var squares = get_tree().get_nodes_in_group("Squares")
	for i in range(len(squares) - 1):
		if squares[i].index > squares[i + 1].index:
			victory = false
	if victory:
		print("Victory!")

func _refresh_called():
	shuffle()