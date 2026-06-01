class KeenableCli < Formula
  desc "Keenable CLI — authenticate, manage API keys, configure MCP, and search the web"
  homepage "https://keenable.ai"
  version "0.1.15"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.1.15/keenable-cli-aarch64-apple-darwin.tar.xz"
      sha256 "82a85c60fa916b190dddb83f2809107d71b57a4b25fee65885f0215155a4c924"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.1.15/keenable-cli-x86_64-apple-darwin.tar.xz"
      sha256 "beb7c124cc55e347b0f8fdac10757ad9a374b8bebff7fe749e7a0aa554afcd54"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.1.15/keenable-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2d118423f0facb7dca30da4f930b933089173cd96a6adf0455255147ef28ff13"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.1.15/keenable-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5b69d94e944399b2e1821698912fb617b2bb95db53f9324656689c61e71fcb79"
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
