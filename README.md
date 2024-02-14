# File-Name-Modifier-Script

## Features

- **Convert to Uppercase/Lowercase**: Easily change file names to all uppercase or lowercase.
- **Apply Sed Patterns**: Use sed patterns to modify file names.
- **Recursive Operation**: Optionally, perform operations on directories and their contents recursively.
- **Help Option**: Display usage information with the `-h` option.

## Usage

To use the script, you have several options:

```bash
./modify.sh [-r] [-l|-u] <dir/file names...>
./modify.sh [-r] <sed pattern> <dir/file names...>
./modify.sh [-h]
```

### Options

- `-r` Operate on directories and their contents recursively
- `-l` Convert file names to lowercase
- `-u` Convert file names to uppercase
- `-h` Print this usage information

### Examples

Convert all file names in the current directory to uppercase:

```bash
./modify.sh -u *
```

Convert file names to lowercase recursively in a specified directory:

```bash
./modify.sh -r -l /path/to/directory
```

Apply a sed pattern to file names within a directory:

```bash
./modify.sh -r 's/old/new/' /path/to/directory
```

## Installation

1. Clone this repository or download the `modify.sh` script directly.
2. Make the script executable:
   ```bash
   chmod +x modify.sh
   ```
3. Run the script following the usage instructions above.

