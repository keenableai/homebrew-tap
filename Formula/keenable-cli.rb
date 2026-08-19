class KeenableCli < Formula
  desc "Keenable CLI — authenticate, manage API keys, configure MCP, and search the web"
  homepage "https://keenable.ai"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.2.2/keenable-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b3a250ff7f137e9b9bc6c39864f14ef095e943c51b83bc61d91535d3f9678482"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.2.2/keenable-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b711277446e00043092bdde9d756e142482d70a65fe6a3e3ff026e898487bf88"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.2.2/keenable-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "254be2e15d0c9efcf6a047ace25420d6e35715a3086a8f4fe9c95289cc6ccba6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenableai/keenable-cli/releases/download/v0.2.2/keenable-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e2e5eb64ac57790ca2423e18dd03e26eb4ee23da9b2fbc38f5281f25e0b493b9"
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
