# Decomposer

## Installation

### Installing Git
Follow the instructions [here](https://git-scm.com/downloads) to install git.

### Installing Ruby
Follow the instructions [here](https://www.ruby-lang.org/en/documentation/installation/#rubyinstaller) to install the ruby programming language. Install the version 2.7.1

### Download
```
> git pull git@github.com:Julian-Jurai/decomposer.git
```

## Notes:
- Do not use spaces in file names, use underscores
- Use lower case (snake case) naming conventions for file names e.g. `this_is_a_data_file.csv`
- Ensure file is of the csv format

### Overview of File Structure
```
decomposer/
  run.rb
  README.md
  input/
  output/
```

## Usage

1. Place data file/s in the `/input` folder
```
decomposer/
  input/
    data_file_1.csv
```

2. Open terminal/command prompt and execute program

```
> cd path/to/decomposer
> ruby run.rb
```

3. Output should be in the `/output` folder
