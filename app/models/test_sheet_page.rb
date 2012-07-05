class TestSheetPage

  attr_accessor :slug, :content, :data

  def initialize(slug)
    @slug = slug
    @data = {}.with_indifferent_access
  end

  def filename
    "#{Rails.root}/app/views/test_sheet/#{slug}.html"
  end

  def exists?
    File.exists? filename
  end

  def load
    self.content = File.read(filename)
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
