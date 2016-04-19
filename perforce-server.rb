class PerforceServer < Formula
  desc "Server for the Perforce revision control system"
  homepage "http://www.perforce.com/"
  version "2015.2.1366233"

  if MacOS.prefer_64_bit?
    url "http://filehost.perforce.com/perforce/r15.2/bin.darwin90x86_64/p4d"
    sha256 "c8c4eb1b9063e16dc0a11aed7801fdfa648610fd2797c6262c02ac7f0b20da98"
  else
    url "http://filehost.perforce.com/perforce/r15.2/bin.darwin90x86/p4d"
    sha256 "f8b3d200ee1ba4734f972193e8c7f8a49e6ae5ed4ee82c164f94d2090772ae9f"
  end

  bottle :unneeded

  def install
    bin.install "p4d"
    (var+"p4root").mkpath
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/p4d</string>
        <string>-p</string>
        <string>1666</string>
        <string>-r</string>
        <string>#{var}/p4root</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}/p4root</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/p4d.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/p4d.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    os_tag = (MacOS.prefer_64_bit? ? "P4D/DARWIN90X86_64" : "P4D/DARWIN90X86")
    (version_year, version_minor, version_build) = version.to_s.split(".")
    assert_match(
      %r{#{os_tag}/#{version_year}\.#{version_minor}/#{version_build} },
      shell_output("#{bin}/p4d -V"))
  end
end
