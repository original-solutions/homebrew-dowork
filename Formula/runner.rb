# Formula template for the external Homebrew tap
# (original-solutions/homebrew-dowork → Formula/runner.rb).
#
# Install: brew install original-solutions/dowork/runner
# Binary name inside each archive remains: dowork-runner
#
# After each GitHub Release of dowork-runner:
#   1. Set 0.10.0 (no leading "v"; matches GoReleaser {{ .Version }}).
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
  version "0.10.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.10.0/dowork-runner_0.10.0_darwin_arm64.tar.gz"
      sha256 "4fe72073867970b752d3ea8281dc4b61810eba6adf44e86b5b563f59aed8fa7d"
    end
    on_intel do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.10.0/dowork-runner_0.10.0_darwin_amd64.tar.gz"
      sha256 "5a11f6308e94138b9378e795d61050ba44c2b9924ee2edec082db2cfe1c5dee0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.10.0/dowork-runner_0.10.0_linux_arm64.tar.gz"
      sha256 "8af515e73ee4392db9b871f3a9ee9bd8bcd0084a88ef0b5592556e7121869d24"
    end
    on_intel do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.10.0/dowork-runner_0.10.0_linux_amd64.tar.gz"
      sha256 "a68da0ebac932cbdf7b12d9da7d0cc59887b0fafca6af422f534fcf9a40d0c2a"
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
