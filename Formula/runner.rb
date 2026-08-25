# Formula template for the external Homebrew tap
# (original-solutions/homebrew-dowork → Formula/runner.rb).
#
# Install: brew install original-solutions/dowork/runner
# Binary name inside each archive remains: dowork-runner
#
# After each GitHub Release of dowork-runner:
#   1. Set 0.6.0 (no leading "v"; matches GoReleaser {{ .Version }}).
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
  version "0.6.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.6.0/dowork-runner_0.6.0_darwin_arm64.tar.gz"
      sha256 "517a747902890535b38a86e1577811ada31dc42db332b85cf00e3d95548f4106"
    end
    on_intel do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.6.0/dowork-runner_0.6.0_darwin_amd64.tar.gz"
      sha256 "ef4b4a251b59e3cdacf21256fe32110d0d293e7876542452a9452887fa41be9d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.6.0/dowork-runner_0.6.0_linux_arm64.tar.gz"
      sha256 "8c8dd19cd9917413b88db0f19a1b68a92056365d228eae7af64646b2d0126fc1"
    end
    on_intel do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.6.0/dowork-runner_0.6.0_linux_amd64.tar.gz"
      sha256 "1e6ef4b172c1bf4b98a23bae0b28c1c0df9958edca650f90612fbea2ae2057aa"
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
