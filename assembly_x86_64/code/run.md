# Create Assembly Compile Script
1. Create `run`:
  ```bash
  # compile object file
  nasm -f elf64 -o ${1}.o ${1}.asm 
  # create executable
  ld ${1}.o -o ${1}
  # run executable
  ./${1}
  # clean up
  rm ${1}.o ${1}
  ```
2. Enable `run`:
  ```bash
  chmod +x run
  ```
3. Run (ex: run hello.asm):
  ```bash
  ./run hello
  ```
