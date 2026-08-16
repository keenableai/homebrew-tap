class KeenableCli < Formula
  desc "Keenable CLI — authenticate, manage API keys, configure MCP, and search the web"
  homepage "https://keenable.ai"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.2.1/keenable-cli-aarch64-apple-darwin.tar.xz"
      sha256 "89f19afed988e139967bb2d6eb5504807df3b7a70c88016b5f2086a2d1bf2297"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.2.1/keenable-cli-x86_64-apple-darwin.tar.xz"
      sha256 "6f288ca4a391dec1570b6e53a99c18e6f53930d09c33e41a237a419bdc16000c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.2.1/keenable-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ff6719582734ac3712bee743c73022b66aa00f37209dac963666883eb8186179"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.2.1/keenable-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a85cb2c115149b5e7daea545336fdc2aee3de9a670d8c5c9b1f2b676a4cd81d8"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "keenable"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "keenable"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "keenable"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "keenable"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
