# UPDATE TERMINAL TITLE
update_terminal_title() {
  if [[ -n "$TMUX" ]]; then
    printf "\033]0;%s\033\\" "${PWD##*/}"
  else
    print -Pn "\e]0;${PWD##*/}\a"
  fi
}
precmd_functions+=(update_terminal_title)


count(){
	local files=( *(N) )
    print ${#files}
}

# Function to open PDF files
function pdf(){
	if [ -z "$1" ]; then
		echo "Usage: pdf <file_path>"
		return 1
	fi

	FILE_PATH="$1"
	
	# Check if the file exists
	if [ ! -f "$FILE_PATH" ]; then
		echo "File not found. Please check the file path. 😢"
		return 1
	fi

	# Check if the file is a PDF
	FILE_EXTENSION="${FILE_PATH##*.}"
	if [ "$FILE_EXTENSION" != "pdf" ]; then
		echo "File is not a PDF. Please check the file path. 😢"
		return 1
	fi
	
	zathura "$FILE_PATH" &
}

# Function to build and install golang project
function gobuild() {
    local current_dir="$(pwd)"
    if [ -z "$1" ]; then
        echo "Usage: gobuild <directory_path>"
        return 1
    fi

    local TARGET_DIR="$1"

    if [ ! -d "$TARGET_DIR" ]; then
        echo "Directory not found: $TARGET_DIR"
        return 1
    fi

    pushd "$TARGET_DIR" > /dev/null || return 1


    local BIN_NAME="${PWD##*/}"

    local BIN_NAME_LOWER

    BIN_NAME_LOWER=$(echo $BIN_NAME | tr '[:upper:]' '[:lower:]')

    echo "Building $BIN_NAME_LOWER..."

    go build -ldflags="-s -w" -o "$BIN_NAME_LOWER" ./cmd

    local INSTALL_PATH=/usr/local/bin/"$BIN_NAME_LOWER"

    if [ ! -f "$INSTALL_PATH" ]; then
        echo "instaling $bin em /usr/local/bin..."
        sudo cp "$BIN_NAME_LOWER" "$INSTALL_PATH"
        sudo chmod 755 "$INSTALL_PATH"
    else
    	echo "$BIN_NAME_LOWER already exists in /usr/local/bin, updating..."
        sudo cp "$BIN_NAME_LOWER" "$INSTALL_PATH"
        sudo chmod 755 "$INSTALL_PATH"
    fi

    popd > /dev/null
    cd "$current_dir" || return 1
}

# Function to create my notes
note() {
	local original_dir
    original_dir="$(pwd)"

    cd ~ || return 1

    [ -d "notes" ] || mkdir "notes"
    cd "notes" || return 1

	if [[ "$1" == "-l" ]]; then
		ls -la
		cd "$original_dir" || return 1
		return 0
	fi

    local filename="$1"
	if [[ -z "$filename" ]]; then
        echo "Usage: note <filename>"
        return 1
	fi

    [[ "$filename" == *.md ]] || filename="${filename}.md"

    [ -f "$filename" ] || touch "$filename"

    nvim "$filename"
}
