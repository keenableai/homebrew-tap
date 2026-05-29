class KeenableCli < Formula
  desc "Keenable CLI — authenticate, manage API keys, configure MCP, and search the web"
  homepage "https://keenable.ai"
  version "0.1.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.1.13/keenable-cli-aarch64-apple-darwin.tar.xz"
      sha256 "7de8a03bd6f33d3e3bf4a57480e9664800c92a7669258fcaf8da08c1e1fb8bf7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.1.13/keenable-cli-x86_64-apple-darwin.tar.xz"
      sha256 "74a59b7bfce44f6fab2a48e396731a8b895b434c5532433daea3849734b7e938"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.1.13/keenable-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e74fc1ba7dc168b7489994ae764aa8b02cc57672b77c97d37b636940d5a4d667"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.1.13/keenable-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a63027214de355b5240fc9bf061ac51f9194dccc8c91e07fab78f115967e4def"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "keenable" if OS.mac? && Hardware::CPU.arm?
    bin.install "keenable" if OS.mac? && Hardware::CPU.intel?
    bin.install "keenable" if OS.linux? && Hardware::CPU.arm?
    bin.install "keenable" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
