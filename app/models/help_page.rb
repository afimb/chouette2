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
