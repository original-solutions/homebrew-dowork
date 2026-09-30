# Formula template for the external Homebrew tap
# (original-solutions/homebrew-dowork → Formula/runner.rb).
#
# Install: brew install original-solutions/dowork/runner
# Binary name inside each archive remains: dowork-runner
#
# After each GitHub Release of dowork-runner:
#   1. Set 0.15.0 (no leading "v"; matches GoReleaser {{ .Version }}).
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
  version "0.15.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.15.0/dowork-runner_0.15.0_darwin_arm64.tar.gz"
      sha256 "b6c2b6a4cbd96e3262c97b1ca39cf401213571a929fbb990d0322e7f9e1650ff"
    end
    on_intel do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.15.0/dowork-runner_0.15.0_darwin_amd64.tar.gz"
      sha256 "8237d7cb5ed8c0a792f7846818a865e4af73d2a4d0cea42d81e64b822de0b1a3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.15.0/dowork-runner_0.15.0_linux_arm64.tar.gz"
      sha256 "9c058e1666f929f6ac01c5c8199d45fdf6cfbf966dd3e7354108dd574cddd96b"
    end
    on_intel do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.15.0/dowork-runner_0.15.0_linux_amd64.tar.gz"
      sha256 "68ae4d8a218d82b0da94955c461bdedffc8a57d5c433f5a7f90878ec14aa01c0"
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
