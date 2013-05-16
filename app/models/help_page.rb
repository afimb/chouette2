#encoding: utf-8
class HelpPage

  attr_accessor :slug, :content, :data

  def initialize(slug)
    @slug = slug
    @data = {}.with_indifferent_access
  end

  def filename
    "#{Rails.root}/app/views/help/#{slug}.textile"
  end

  def exists?
    File.exists? filename
  end

  def load
    self.content = File.read(filename)
    self.data ||= {}

    if self.content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
      self.content = $POSTMATCH
      self.data.merge! YAML.load($1)
    end
    
    # workaround for special chars
    self.content = self.content.gsub('é','&eacute;')
    self.content = self.content.gsub('è','&egrave;')
    self.content = self.content.gsub('à','&agrave;')
    self.content = self.content.gsub('ù','&ugrave;')
    self.content = self.content.gsub('É','&Eacute;')
    self.content = self.content.gsub('È','&Egrave;')
    self.content = self.content.gsub('Ê','&Ecirc;')
    self.content = self.content.gsub('À','&Agrave;')
    self.content = self.content.gsub('Ù','&Ugrave;')
    self.content = self.content.gsub('â','&acirc;')
    self.content = self.content.gsub('ê','&ecirc;')
    self.content = self.content.gsub('ô','&ocirc;')
    self.content = self.content.gsub('î','&icirc;')
    self.content = self.content.gsub('û','&ucirc;')
    self.content = self.content.gsub('ë','&eumlc;')
    self.content = self.content.gsub('ï','&iuml;')
    self.content = self.content.gsub('ç','&ccedil;')
    self.content = self.content.gsub('oe','&oelig;')
    self.content = self.content.gsub('<<','&laquo;')
    self.content = self.content.gsub('«','&laquo;')
    self.content = self.content.gsub('>>','&raquo;')
    self.content = self.content.gsub('»','&raquo;')
    self.content = self.content.gsub('°','&ordm;')
	self.content = self.content.gsub('’',"'")
    self.content = self.content.gsub(' '," ")
  end

  def method_missing(method, *arguments)
    if arguments.empty? and data.has_key?(method)
      data[method]
    else
      super
    end
  end

  def self.find(slug)
    new(slug).tap do |page|
      if page.exists?
        page.load
      else
        raise ActiveRecord::RecordNotFound 
      end
    end
  end

end
