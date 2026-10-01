# Formula template for the external Homebrew tap
# (original-solutions/homebrew-dowork → Formula/runner.rb).
#
# Install: brew install original-solutions/dowork/runner
# Binary name inside each archive remains: dowork-runner
#
# After each GitHub Release of dowork-runner:
#   1. Set 0.16.1 (no leading "v"; matches GoReleaser {{ .Version }}).
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
  version "0.16.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.16.1/dowork-runner_0.16.1_darwin_arm64.tar.gz"
      sha256 "52e4caea790df96c43cf0ab2da1a2239e6ba71223fc7603148aa4389b13bc436"
    end
    on_intel do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.16.1/dowork-runner_0.16.1_darwin_amd64.tar.gz"
      sha256 "eee0398b904b0921dfe07b37e01bd26f2063b431ff5204056cd72c5a1c41ab4d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.16.1/dowork-runner_0.16.1_linux_arm64.tar.gz"
      sha256 "5a494f4873a1ecb422447fd5b7e1cba8e5b8d781fb860a78275118d83c788e8a"
    end
    on_intel do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.16.1/dowork-runner_0.16.1_linux_amd64.tar.gz"
      sha256 "2720436f91b5795b377c07d8e2ea73975b07bd71f23bd5c5d12d84840d34e468"
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
