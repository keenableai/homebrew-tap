class KeenableCli < Formula
  desc "Keenable CLI — authenticate, manage API keys, configure MCP, and search the web"
  homepage "https://keenable.ai"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.2.0/keenable-cli-aarch64-apple-darwin.tar.xz"
      sha256 "0639d03c5927cda7c2d7663e3e52f5c29e0db76099b68dde5b7a495595c72f22"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.2.0/keenable-cli-x86_64-apple-darwin.tar.xz"
      sha256 "28e4bb0101770d5a2390700c1265a4a537ddf0bf4d1211f4b98a05c1f0cadcc5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.2.0/keenable-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4e85170c134b8e69d3349ee6ca2b4544381566616f044af550eb40187616aa01"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.2.0/keenable-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "180d38db84674452e54209bbec518d68e227ecc4810b1a002fe555470149dbf8"
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
