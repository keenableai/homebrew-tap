class KeenableCli < Formula
  desc "Keenable CLI — authenticate, manage API keys, configure MCP, and search the web"
  homepage "https://keenable.ai"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.6.0/keenable-cli-aarch64-apple-darwin.tar.xz"
      sha256 "7b72cfd1e708a9e416d57ee6e6019df454dd83f1e5f99ccdb6e941be71a1191e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.6.0/keenable-cli-x86_64-apple-darwin.tar.xz"
      sha256 "877cdf042555acdbbbdfa954913c76bab420efd089f0378c1fc0d4174a0abc5b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.6.0/keenable-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7e10495aafa00d0e6a2938ff1d679a0b7dac9073e4465da5f2af38b84641e40c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.6.0/keenable-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "764325d5ef2ba62b42b81e1dc3926cbc5fd0017b477ebcc5608cad3e6901b533"
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
