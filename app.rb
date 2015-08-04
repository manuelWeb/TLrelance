require 'slim'
require 'htmlbeautifier' 
require 'premailer'

class Slimed
  attr_accessor :src, :out
  def initialize(src,out)
    @src = src
    @out = out
  end
  
  def tohtml
    # puts src # puts out # puts s2h.render
    srcfile = File.open(src, "rb").read
    s2h = Slim::Template.new{srcfile}
    htmlrender = s2h.render  
    # ecriture du fichier out = Slimed.new(src,**out**)
    File.open(out, "w") do |go|
      go.puts htmlrender
    end
    # init class Premailer > ouverure out en ecriture > traitement premailer+beautify > eciture dans out
    premailer = Premailer.new(out)
    File.open(out, "w") do |file|
      premailer = premailer.to_inline_css
      beautiful = HtmlBeautifier.beautify(premailer, tab_stops: 2)
      file.puts beautiful
    end

  end
end

fr = Slimed.new('FR.html.slim', 'FR.html')
fr.tohtml

# rendu alt && || online si img sur serveur http://www.webdesignord.fr/domoti/test/
source = File.read(fr.out).gsub('src="','src="http://www.webdesignord.fr/domoti/test/false')
dest = File.open("alt.html", "w")
dest << source
dest.close