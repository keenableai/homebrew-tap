class KeenableCli < Formula
  desc "Keenable CLI — authenticate, manage API keys, configure MCP, and search the web"
  homepage "https://keenable.ai"
  version "0.1.25"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.1.25/keenable-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9990ad25c5836105c9c9e4219ca2b0e323748e50769eaba666dd0b4c578d6790"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.1.25/keenable-cli-x86_64-apple-darwin.tar.xz"
      sha256 "9a2f2f11c0caf05dc553e729466735c456f9283ae9f3d9eea6975139de270640"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.1.25/keenable-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a58d1548eef7baaa44499e9c8a948b18e5c39de777c5670975978c83676daec2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.1.25/keenable-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a5474516e0a9e127b96ab0c0195b61a980115cf06c7a8680e6a43eb36be9b8b8"
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
