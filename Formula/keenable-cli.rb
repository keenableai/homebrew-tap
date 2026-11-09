class KeenableCli < Formula
  desc "Keenable CLI — authenticate, manage API keys, configure MCP, and search the web"
  homepage "https://keenable.ai"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.3.0/keenable-cli-aarch64-apple-darwin.tar.xz"
      sha256 "186be1919dc97b1aac03f5cc3a9eed035f03d8438745fa212611874ab48adf94"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.3.0/keenable-cli-x86_64-apple-darwin.tar.xz"
      sha256 "36ac8b945f655c1fa289718a57b9750cbfa48c7d2d7e4c459fc202ae6a2de09e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.3.0/keenable-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ab7aefde001c6fa7b448beec37fa88a4aa4db2351b239f556344a09078c7f710"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.3.0/keenable-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3ab9234644679e6c70ece32e083e3d5f59b56e12b4032d72e041af7c4c3baa90"
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
