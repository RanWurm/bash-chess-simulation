#!/bin/bash


if [ ! -f "$1" ]; then
    echo "File does not exist: $1"
    exit 1
fi

input_pgn_file="$1"
input_len=0


while IFS= read -r line
do
  # Increment line counter for each line read
  input_len=$((input_len + 1))
done < "$input_pgn_file"


meta_data=$(grep -e "^\[.*\]"  "$input_pgn_file")
meta_len=$[$(wc -l <<< $meta_data)+1]
game_moves_len=$[$input_len-$meta_len]
game_moves=$(tail -n $game_moves_len "$input_pgn_file")
total_moves=0
moves_made=0

in_uci_game_moves=$(python3 parse_moves.py "$game_moves")

read -a uci_array <<< "$in_uci_game_moves"

#initial the total game moves
for move in "${uci_array[@]}"; do
#     printf " %s\n" "${uci_array[total_moves]}"
     ((total_moves++))

done

# Declare an associative array
declare -A chess_board

# Define initial setup for chess board
initial_board(){
rows=('rnbqkbnr' 'pppppppp' '........' '........' '........' '........' 'PPPPPPPP' 'RNBQKBNR')

# Populate the array using the defined rows
for (( i=0; i<${#rows[@]}; i++ )); do
    row=${rows[$i]}
    for (( j=0; j<${#row}; j++ )); do
        key="$(echo {a..h} | cut -d' ' -f$((j+1)))$((8-i))"
        value="${row:$j:1}"
        chess_board[$key]=$value
    done
done

}

initial_board

# Function to print the chess board
print_chess_board() {
    echo "Move $moves_made/$total_moves"
    echo "  a b c d e f g h"
    for (( i=8; i>=1; i-- )); do
        echo -n "$i "
        for col in {a..h}; do
            key="${col}${i}"
            # Use a single space between pieces for all columns
            echo -n "${chess_board[$key]} "
        done
        echo "$i"
    done
    echo "  a b c d e f g h"
}
# Define the standard chess board configuration
declare -a display_board=(
    "rnbqkbnr"
    "pppppppp"
    "........"
    "........"
    "........"
    "........"
    "PPPPPPPP"
    "RNBQKBNR"
)

make_move() {
    local from=${1:0:2}  # Extract starting position (e.g., "e2")
    local to=${1:2:2}    # Extract ending position (e.g., "e4")

    # Move the piece
    chess_board[$to]=${chess_board[$from]}
    chess_board[$from]='.'  # Clear the original square

}

do_prev_step(){
    local cnt=$moves_made
    ((cnt--))
    moves_made=0
    initial_board
    while ((moves_made < cnt)); do
        current_move="${uci_array[$moves_made]}"
        make_move "$current_move"
        ((moves_made++))
    done
    print_chess_board

}

do_next_step() {
    current_move="${uci_array[$moves_made]}"
    make_move "$current_move"
    ((moves_made++))
    print_chess_board

}



go_to_end(){
    while ((moves_made < total_moves)); do
        current_move="${uci_array[$moves_made]}"
        make_move "$current_move"
        ((moves_made++))
    done
    print_chess_board
}

go_to_start(){
    initial_board
    moves_made=0
    print_chess_board
}

echo "Metadata from PGN file:"
echo "$meta_data"
echo 
print_chess_board


while true; do
    echo -n "Press 'd' to move forward, 'a' to move back, 'w' to go to the start, 's' to go to the end, 'q' to quit:"
    read -n 1 key
    echo   # add an echo to move to the new line after input

    # Wait for the user to press Enter
    read -r _  # This reads the rest of the line, including the Enter key press.

    case "$key" in
        "d")
            if [ "$moves_made" -eq "$total_moves" ]; then
               echo "No more moves available."
            else
                do_next_step
            fi
            ;;
        "s")
            go_to_end
            ;;
        "w")
            go_to_start
            ;;
        "a")
            do_prev_step
            ;;
        "q")
            echo "Exiting."
            echo "End of game."
            break
            ;;
        *)
            echo "Invalid key pressed: $key"
            ;;
    esac

done
