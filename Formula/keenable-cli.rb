class KeenableCli < Formula
  desc "Keenable CLI — authenticate, manage API keys, configure MCP, and search the web"
  homepage "https://keenable.ai"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.1.7/keenable-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6807cce6bffe487599570c0d8cc454f57ee7335fc693e150c0f1ef9d68de26fe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.1.7/keenable-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0edef32b88ce600f902c200dcb9804b36070c462e8b728cd8b9b01402ca8574c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.1.7/keenable-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8e28f42d67c68320bab27eccdfa5f3ec4852bdfb7931e6b4381b04026259d4d5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.1.7/keenable-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4e7002d21feb00e63811165a779e350c499bf18a872a102836e1395d2b67c880"
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
