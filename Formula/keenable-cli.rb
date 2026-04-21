class KeenableCli < Formula
  desc "Keenable CLI — authenticate, manage API keys, configure MCP, and search the web"
  homepage "https://keenable.ai"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.1.0/keenable-cli-aarch64-apple-darwin.tar.xz"
      sha256 "65ad1bffe433e42fc6fc61e14c275d71d8adad6e6de1bc0b8a3456a9c3ddd713"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.1.0/keenable-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0058976c7514ea41c4532a0cb2917c901a5d6852f843b19ae034459229f2834a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.1.0/keenable-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "480e733ad25b55b813e6b518a56848925a839c5a3bba971a571c8177d922d84e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.1.0/keenable-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cdd16b7db898f5f3282e1028b0c5e0356027b5ee5a37a2297d60bc00c6809561"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
