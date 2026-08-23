# Formula template for the external Homebrew tap
# (original-solutions/homebrew-dowork → Formula/runner.rb).
#
# Install: brew install original-solutions/dowork/runner
# Binary name inside each archive remains: dowork-runner
#
# After each GitHub Release of dowork-runner:
#   1. Set 0.2.0 (no leading "v"; matches GoReleaser {{ .Version }}).
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
  version "0.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.2.0/dowork-runner_0.2.0_darwin_arm64.tar.gz"
      sha256 "60fe6786c21beb5dc31c18b64d3ddba418aa3a7a962e0d6ea86f224ea899d9a2"
    end
    on_intel do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.2.0/dowork-runner_0.2.0_darwin_amd64.tar.gz"
      sha256 "d6fa6239ab3016c7024622a0366932ca7eb0ddac3c2f6e1cc219a00c1c336b69"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.2.0/dowork-runner_0.2.0_linux_arm64.tar.gz"
      sha256 "f02877cb04cb5b9c59aabfca6a9e3bb0af03a6b9ec305358c13055d035d5e7b7"
    end
    on_intel do
      url "https://github.com/original-solutions/dowork-runner/releases/download/v0.2.0/dowork-runner_0.2.0_linux_amd64.tar.gz"
      sha256 "1316cc0dc05c3192823952d22ffd52fdd719a1882b8f4bb9e1715c8ec622f66f"
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
