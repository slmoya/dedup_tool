# Deduplication Tool

This bash script efficiently removes duplicate lines from large datasets of `email:password` pairs, leveraging multiple CPU cores for parallel processing. It supports hierarchical directory structures and prevents file naming conflicts during the deduplication process.

## Features

- **Parallel Processing:** Utilize multiple CPU cores to speed up deduplication.
- **Hierarchical Support:** Handles files stored in nested directory structures.
- **Memory Efficient:** Processes files line-by-line without loading entire files into memory.
- **Duplicate Count:** Tracks and displays the total number of duplicates removed.

## Prerequisites

- **GNU Parallel:** This script relies on `parallel` for parallel processing. Install it using your package manager:

  - **Debian/Ubuntu:**
    ```bash
    sudo apt-get install parallel
    ```
  - **Fedora:**
    ```bash
    sudo dnf install parallel
    ```
  - **macOS:**
    ```bash
    brew install parallel
    ```

## Usage

### 1. Clone the Repository

```
git clone https://github.com/slmoya/dedup_tool
cd dedup_tool
```

### 2. Make the Script Executable

```
chmod +x dedup.sh
```

### 3. Run the Script
```
./dedup.sh <source_directory> <temp_directory> <num_cores>
```
- <source_directory>: Path to the directory containing your data.
- <temp_directory>: Path to the directory where temporary files will be stored.
- <num_cores>: Number of CPU cores to use for parallel processing.

## Example
```
./dedup.sh /path/to/data /path/to/temp_data 8
```

This example uses 8 CPU cores to deduplicate all files in /path/to/data, storing temporary files in /path/to/temp_data.

## Output
- Progress: The script displays the current file being processed.
- Duplicate Count: After processing, the script prints the total number of duplicates removed across all files.

## How It Works
- Unique Temp Files: The script creates a uniquely named temporary file for each original file by converting the file's relative path to a flat name, avoiding conflicts during parallel processing.
- Atomic Operations: Each core processes files independently, writing results to uniquely named temporary files, which are then moved back to their original locations.
- Efficiency: By processing files line-by-line and utilizing multiple cores, the script handles large datasets efficiently, even when working with limited memory.

## Notes
- Ensure that the temporary directory (<temp_directory>) has sufficient space to hold temporary files during processing.
- The script does not alter the content of individual lines—only duplicate lines are removed.

### License
This tool is licensed under the MIT License. See the LICENSE file for more information.

### Contributions
Contributions, issues, and feature requests are welcome! Feel free to check out the issues page.
