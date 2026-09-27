# Formula template for the external Homebrew tap
# (original-solutions/homebrew-dowork → Formula/runner.rb).
#
# Install: brew install original-solutions/dowork/runner
# Binary name inside each archive remains: dowork-runner
#
# After each GitHub Release of dowork-runner:
#   1. Set 0.11.0 (no leading "v"; matches GoReleaser {{ .Version }}).
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
  version "0.11.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.11.0/dowork-runner_0.11.0_darwin_arm64.tar.gz"
      sha256 "58fc1549705fc32a105dfcb5dcf9466c7cbea306528573bf7ad6b29917ddf631"
    end
    on_intel do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.11.0/dowork-runner_0.11.0_darwin_amd64.tar.gz"
      sha256 "be4c50c2f5faa97f1a0c1fe1ce3b4391d2c3ddbeca46b032fc4d75c989513d13"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.11.0/dowork-runner_0.11.0_linux_arm64.tar.gz"
      sha256 "1b388b5b84200a540569a5fea970f2516256aa10aacdba6898299af7d433eacc"
    end
    on_intel do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.11.0/dowork-runner_0.11.0_linux_amd64.tar.gz"
      sha256 "bc39553c30dcf147895cfbac95e569f85c9bc945dec7369427166bf364962b4e"
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
