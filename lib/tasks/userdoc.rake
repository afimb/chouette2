#encoding: utf-8 
if Rails.env != 'production'
require 'fileutils'
require 'nokogiri'

namespace :doc do
  desc "doc production"
  task :user  do
    puts "Produce user documentation"
    
    abort("Missing commands: please install them before processing") unless command?("pandoc") && command?("unzip") && command?("zip")

    FileUtils.rm_r("tmp/doc") if File.exist?("tmp/doc")
    FileUtils.rm_r("word") if File.exist?("word")
    File.delete("userdoc.docx") if File.exists?("userdoc.docx")
 
    Dir.mkdir("tmp/doc");
    # merge all textile files in one
    merge_textiles
    
    # copy images in temp dir
    puts "add images"
    FileUtils.cp_r Dir.glob("public/help/*.png"), "tmp/doc"
    
    # call pandoc to build docx
    puts "build docx"
    Dir.chdir "tmp/doc"
    system "pandoc -s -o ../../userdoc.docx temp.textile"
    
    # clean working directory
    puts "clean temp files"
    Dir.chdir "../.."
    FileUtils.rm_r("tmp/doc") if File.exist?("tmp/doc")
    
    # patch docx
    patch_docx "userdoc.docx"
    
    # end job
    puts "User doc completed"
  end
  
  def merge_textiles
    puts "parsing app/views/help/toc.textile"
    File.open('tmp/doc/temp.textile','w') { |f| 
      File.open('app/views/help/toc.textile','r').each_line do |line|
        line.chomp!
        if line.start_with?("#")
          title=""
          file=""
          if line.include? ":"
            title=line.scan(/"([^"]*)"/).last.first
            file=line.split(":").last
          else
            title=line.split.last
          end
          if line.start_with?("##")
            f.puts "h2. "+title
          elsif line.start_with?("#")
            f.puts "h1. "+title
          end
          f.puts ""
          if !file.empty?
            parse_textile "app/views/help/#{file}.textile",f
          end
        end
      end
    }
  end
  
  def command?(command)
       puts "command #{command} missing" unless system("which #{command} > /dev/null 2>&1")  
       system("which #{command} > /dev/null 2>&1")
  end
  
  def parse_textile (file,out)
    puts "  parsing #{file}"
    File.open(file,"r").each_line do |l|
      l.chomp!
      next if l.start_with? "---" 
      next if l.start_with? "layout:" 
      next if l.start_with? "title:"
      next if !l.scan(/^\* ".*":#/).empty?
      l=l.gsub("->","→").gsub("<<","«").gsub(">>","»").gsub("oe","œ").gsub("p=.","p.")
      clean_local_links l
      out.puts l 
    end
    out.puts ""
  end

  def clean_local_links (line)
    if line.include? '":'
      check_and_remove_link line,0
    end
  end
  
  def check_and_remove_link (line,pos)
      link_pos = line.index '":',pos
      return if link_pos.nil? 
      title_pos = line[0..link_pos-1].rindex '"'
      title=line[title_pos+1..link_pos-1]
      if !line[link_pos+2..-1].start_with? "http"
        end_link = line.index(/[^a-z_]/, link_pos+2)
        end_link = line.length if end_link.nil? 
        end_link = end_link - 1
        link=line[link_pos+1..end_link]
        # remove link syntax
        line.sub!(link,'')
        line.sub!('"'+title+'"',title)
      end
      check_and_remove_link line,link_pos+1
  end  
  
  def patch_docx file
    system "unzip #{file} word/document.xml > /dev/null 2>&1"
    
    f=File.open("word/document.xml","r+")
    doc = Nokogiri::XML(f)
    doc.xpath("//w:t").each do |tag|
      if tag.to_s.include? '&amp;#95;'
        tag.child.content = tag.child.content.gsub '&#95;','_'
      end
    end
    f.rewind
    f.write(doc.to_xml(:save_with => Nokogiri::XML::Node::SaveOptions::AS_XML))
    f.close
    
    system "zip -r #{file} word/document.xml > /dev/null 2>&1"
    FileUtils.rm_r("word") if File.exist?("word")
  end
  
end

end

