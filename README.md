# dirsplitter
Split large directories into parts of a specified maximum size while maintaining structure. This is a crystal port of my dirsplitter tool.

[Go version](https://github.com/jinyus/dirsplitter) (more binaries available)<br>
[F# Version](https://github.com/jinyus/fs_dirsplitter)<br>
[Nim Version](https://github.com/jinyus/nim_dirsplitter)

How to build:  
- Clone this git repo  
- Install Crystal : [https://crystal-lang.org/install/](https://crystal-lang.org/install/)
- cd into directory and compile with: 
```
crystal build src/dirsplitter.cr --release --no-debug
```

Or download the prebuild binary (linux 64bit) only from: https://github.com/jinyus/cr_dirsplitter/releases


```text
Usage:
   dirsplitter COMMAND

Commands:

  split            Split directories into a specified maximum size
  reverse          Opposite of the main function, moves all files from     
                   part folders to the root

Options:
  -h, --help
  ```
  ## SPLIT USAGE:
  
  ```text
  Splits directory into a specified maximum size

Usage:
  dirsplitter split [options] 

Options:
  -h, --help
  -d, --dir=DIR              Target directory (default: ".")
  -m, --max=MAX              Max part size in GB (default: 5.0)
  -p, --prefix=PREFIX        Prefix for output files of the tar command. 
                             eg: myprefix.part1.tar (default: "")
 ```
  
### example: 
```text
dirsplitter split --dir ./mylarge2GBdirectory --max 0.5

This will yield the following directory structure:

📂mylarge2GBdirectory
 |- 📂part1
 |- 📂part2
 |- 📂part3
 |- 📂part4

with each part being a maximum of 500MB in size.

```

Undo splitting
```
dirsplitter reverse --dir ./mylarge2GBdirectory

```
