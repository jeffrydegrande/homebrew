require 'formula'

class Macvim <Formula
  head 'git://repo.or.cz/MacVim.git'
  homepage 'http://code.google.com/p/macvim'

 def install
  # LTO takes forever due to vim's link.sh
  ENV.O3
  # MacVim's Xcode project gets confused by $CC, disable it until someone
  # figures out why it fails

  ENV['CC'] = nil
  ENV['CXX'] = nil

  ENV.remove_from_cflags '-march=core2'
  ENV.remove_from_cflags '-mmmx'

  system "./configure",
         # Add some features
         "--with-features=huge",
         "--enable-pythoninterp",
         "--enable-rubyinterp"

  system "make"

  libexec.install "src/MacVim/build/Release/MacVim.app"
  inreplace "src/MacVim/mvim", /^# VIM_APP_DIR=\/Applications$/, "VIM_APP_DIR=#{libexec}"
  bin.install "src/MacVim/mvim"



  # Create MacVim vimdiff, view, ex equivalents
  %w[mvimdiff mview mvimex].each do |f|
    (bin + f).make_symlink("#{bin}/mvim")
  end
end



  def caveats
    "MacVim.app installed to #{libexec}."
  end
end