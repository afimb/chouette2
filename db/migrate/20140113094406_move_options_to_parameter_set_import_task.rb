class MoveOptionsToParameterSetImportTask < ActiveRecord::Migration
  def up
    ImportTask.all.each do |import|
      import.parameter_set.tap do |parameter_set|
        parameter_set = {} if parameter_set.nil?
        import.resources = "dummy"
        import.update_attribute :format, "Neptune"
        import.update_attribute :no_save, false
        result = import.update_attribute( :parameter_set, {  :no_save => import.attributes[ "no_save"],
                                                      :file_path => import.attributes[ "file_path"],
                                                      :format => import.attributes[ "format"]}.merge( parameter_set))
        raise Exception.new("Echec id=#{import.id}, import.valid? #{import.valid?}, import.erros #{import.errors.inspect}") unless result
      end
    end
  end

  def down
  end
end
