require 'tempfile'

class ComplianceCheckTaskExport
  include ERB::Util
  
  require 'zip'
  
  attr_accessor :template, :detailed_errors_template, :request
  attr_reader :compliance_check_task
  
  def initialize(compliance_check_task, request)
    @request = request
    @compliance_check_task = compliance_check_task
    @template = File.open('app/views/compliance_check_tasks/summary_errors_index.csv.erb' ) { |f| f.read }
    @detailed_errors_template = File.open('app/views/compliance_check_tasks/detailed_errors_index.csv.erb' ) { |f| f.read }
  end
  
  def export
    begin
      Dir.mktmpdir("#{I18n.t('compliance_check_results.file.zip_name_prefix')}_#{@compliance_check_task.referential_id}_#{@compliance_check_task.id}_", Dir.tmpdir) { |temp_dir|
        
        File.open(temp_dir + "/#{I18n.t('compliance_check_results.file.summary_errors_file_prefix')}" , "a") do |f|
          f.write(render)
          f.flush
        end
        
        File.open(temp_dir + "/#{I18n.t('compliance_check_results.file.detailed_errors_file_prefix')}" , "a") do |f|
          f.write(detailed_errors_render)
          f.flush
        end
        
        zip_file = Tempfile.new(["#{I18n.t('compliance_check_results.file.zip_name_prefix')}_#{@compliance_check_task.referential_id}_#{@compliance_check_task.id}_", ".zip"])
        
        ::Zip::File.open(zip_file.path, ::Zip::File::CREATE) do |zipfile|
          Dir[File.join(temp_dir, '*.csv')].each do |f|
            zipfile.add(File.basename(f), f)
          end
        end
        return zip_file
      }
    end
  end
  
  def render()
    ERB.new(@template).result(binding)
  end
  
  def detailed_errors_render()
    ERB.new(@detailed_errors_template).result(binding)
  end
  
end
