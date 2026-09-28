# Formula template for the external Homebrew tap
# (original-solutions/homebrew-dowork → Formula/runner.rb).
#
# Install: brew install original-solutions/dowork/runner
# Binary name inside each archive remains: dowork-runner
#
# After each GitHub Release of dowork-runner:
#   1. Set 0.13.0 (no leading "v"; matches GoReleaser {{ .Version }}).
#   2. Fill the four SHA256 placeholders from release checksums.txt.
#   3. Copy this file into the tap repo as Formula/runner.rb (strip this header if desired).
#
# Archive names match monorepo .goreleaser.yaml:
#   dowork-runner_{Version}_{Os}_{Arch}.tar.gz
#
# Supervisor: prefer product `make agent-install` / launchd io.dowork.runner
# over `brew services` so units stay under product control (avoids double registration).

class Runner < Formula
  desc "do-work.io machine runner — claim, heartbeat, spawn factory sandboxes"
  homepage "https://do-work.io"
  version "0.13.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.13.0/dowork-runner_0.13.0_darwin_arm64.tar.gz"
      sha256 "85503b59332b7d4f034b32b03739392e911151d3b759023d94844c3d0678122f"
    end
    on_intel do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.13.0/dowork-runner_0.13.0_darwin_amd64.tar.gz"
      sha256 "de387976855b81316c4f375b3e179b0630c091fd457ae181ff21f620535ce9d1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.13.0/dowork-runner_0.13.0_linux_arm64.tar.gz"
      sha256 "b3e529c56bbe70e609259b3c54aaf82e593c04cd349f4c96f4a5409bfeb2220d"
    end
    on_intel do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.13.0/dowork-runner_0.13.0_linux_amd64.tar.gz"
      sha256 "3c77ac3d5f08aa7f6bdc76c61f55d1a1d81f1fdd8114a2737cc44eddf6390e00"
    end
  end

  def install
    bin.install "dowork-runner"
  end

  def caveats
    <<~EOS
      The Homebrew formula is original-solutions/dowork/runner (binary: dowork-runner).
      Packaged install:
        brew tap original-solutions/dowork
        brew trust original-solutions/dowork
        brew install original-solutions/dowork/runner
      Pair, then start the LaunchAgent (not brew services):
        dowork-runner claim --server https://api.do-work.io
        dowork-runner install-service
      Foreground instead of a service:
        dowork-runner run
      Reload an existing unit:
        dowork-runner restart
      From-source build (this clone):
        make agent-install
      Do not use `brew services` for this formula — launchd is io.dowork.runner.
    EOS
  end

  # Optional Homebrew service (alternate). Product path is preferred:
  #   dowork-runner install-service
  # Do not enable both brew services and io.dowork.runner on the same machine.
  # service do
  #   run [opt_bin/"dowork-runner", "run"]
  #   keep_alive true
  # end

  test do
    assert_match version.to_s, shell_output("#{bin}/dowork-runner version")
  end
end
