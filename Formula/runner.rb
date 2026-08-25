# Formula template for the external Homebrew tap
# (original-solutions/homebrew-dowork → Formula/runner.rb).
#
# Install: brew install original-solutions/dowork/runner
# Binary name inside each archive remains: dowork-runner
#
# After each GitHub Release of dowork-runner:
#   1. Set 0.7.1 (no leading "v"; matches GoReleaser {{ .Version }}).
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
  version "0.7.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.7.1/dowork-runner_0.7.1_darwin_arm64.tar.gz"
      sha256 "7c15d020d9f33199e09feb0699dd5edcd4252c272cbdffb7ec317fa1af675036"
    end
    on_intel do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.7.1/dowork-runner_0.7.1_darwin_amd64.tar.gz"
      sha256 "e8cdc1301beadafb016c5ee1505f5eff6a879abc4ad8dd9dac17836430bc2266"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.7.1/dowork-runner_0.7.1_linux_arm64.tar.gz"
      sha256 "02b6971b2cad3f0c792e5aab8ecfab7c7aef41ffc65be8ec6f65bd4dde963777"
    end
    on_intel do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.7.1/dowork-runner_0.7.1_linux_amd64.tar.gz"
      sha256 "b25fa8b19d74315b88910875fa7e55f09d4bc12b98a0de9a1f0c8051c4f5ace0"
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
