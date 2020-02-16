> This file is just me documenting the steps from following https://rustwasm.github.io/docs/book/game-of-life/, so I don't have to read through it all again to install it on a different machine.

Install a working wasm web project

```bash
# Install rustup toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Run rustup update (not in tutorial) to get a newer version of rust
# This avoids build errors in the cargo-generate step
rustup update

# Install wasm-pack
# Interface between rust and wasm
curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh

# Install cargo-generate
# Cargo-generate will allow us to quickly create new projects
cargo install cargo-generate

# Update npm
npm install npm@latest -g

# Go to a folder where you want to create your wasm project
cd <my_project_folder>

# Make a new template project (choose wasm-game-of-life as project name)
cargo generate --git https://github.com/rustwasm/wasm-pack-template
cd wasm-game-of-life

# Build the wasm project
wasm-pack build

# Build the web directory
npm init wasm-app www
cd www

# Install website dependencies
npm install
```

Now we have a working project, change the code following [the steps in the tutorials](https://rustwasm.github.io/docs/book/game-of-life/hello-world.html#using-our-local-wasm-game-of-life-package-in-www).
