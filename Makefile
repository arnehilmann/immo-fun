SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: debug release update-rust

	# Check for openssl references
	# cargo tree --target=x86_64-unknown-linux-gnu -i openssl-sys

	# Cross Compile to linux gnu
	# https://github.com/messense/homebrew-macos-cross-toolchains
	#
	# export CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER=x86_64-linux-gnu-gcc
	# cargo build --release --target x86_64-unknown-linux-gnu
	# file target/x86_64-unknown-linux-gnu/release/json2zola-rs
	# cp target/x86_64-unknown-linux-gnu/release/json2zola-rs ../git-pocket/extract

debug:
	time cargo run

release:
	time cargo build --release
	target/release/json2zola-rs

workflow:
	export CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER=x86_64-linux-gnu-gcc
	cargo build --release --target x86_64-unknown-linux-gnu
	file target/x86_64-unknown-linux-gnu/release/archive
	cp target/x86_64-unknown-linux-gnu/release/archive bin/

update-rust:
	rustup self update
	rustup update
	cargo clean
	cargo update

	# brew tap SergioBenitez/osxct	# no update since 4 years?!
	# from https://github.com/messense/homebrew-macos-cross-toolchains
	brew tap messense/macos-cross-toolchains
	brew upgrade x86_64-unknown-linux-gnu || brew install x86_64-unknown-linux-gnu
	rustup target add x86_64-unknown-linux-gnu
	brew upgrade x86_64-unknown-linux-musl || brew install x86_64-unknown-linux-musl
	rustup target add x86_64-unknown-linux-musl

	brew upgrade mingw-w64 || brew install mingw-w64
	rustup target add x86_64-pc-windows-gnu
