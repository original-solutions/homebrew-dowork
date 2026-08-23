# Formula template for the external Homebrew tap
# (original-solutions/homebrew-dowork → Formula/runner.rb).
#
# Install: brew install original-solutions/dowork/runner
# Binary name inside each archive remains: dowork-runner
#
# After each GitHub Release of dowork-runner:
#   1. Set 0.1.0 (no leading "v"; matches GoReleaser {{ .Version }}).
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
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.1.0/dowork-runner_0.1.0_darwin_arm64.tar.gz"
      sha256 "a7e3f96e45631187d711fef6c145d3c24607ffdfc7680fb3342cd5b98eb03c6c"
    end
    on_intel do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.1.0/dowork-runner_0.1.0_darwin_amd64.tar.gz"
      sha256 "254a4cb5b98b51cc6e4187e660522138c8318bb2124a02941a62b2ba8622c401"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.1.0/dowork-runner_0.1.0_linux_arm64.tar.gz"
      sha256 "caa0bcbe72ffff5395298c65be56396437fb604c82e2d8f0dd4b8da763f8e2d9"
    end
    on_intel do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.1.0/dowork-runner_0.1.0_linux_amd64.tar.gz"
      sha256 "bebdbf032a3171626cb53e8b94eff4cc66e0a629ad3d102583197e1632b313f9"
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
      From-source / launchd (dev):
        make agent-install
      Do not use `brew services` for this formula — launchd is owned by make agent-install.
    EOS
  end

  # Optional Homebrew service (alternate). Product path is preferred:
  #   make agent-install
  # Do not enable both brew services and io.dowork.runner on the same machine.
  # service do
  #   run [opt_bin/"dowork-runner", "run"]
  #   keep_alive true
  # end

  test do
    assert_match version.to_s, shell_output("#{bin}/dowork-runner version")
  end
end
