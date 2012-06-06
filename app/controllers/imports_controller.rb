class ImportsController < ChouetteController
  respond_to :html, :xml, :json
  belongs_to :referential

  def new
    new! do
      available_imports
    end
  end

  def create
    create! do |success, failure|
      available_imports
      success.html { redirect_to referential_imports_path(@referential) }
    end
  end

  protected

  def available_imports
    @available_imports ||= Import.types.collect do |type|
      unless @import.type == type
        @referential.imports.build :type => type
      else
        @import
      end
    end
  end

  # FIXME why #resource_id is nil ??
  def build_resource
    super.tap do |import|
      import.referential_id = @referential.id
    end
  end

  def collection
    @imports ||= end_of_association_chain.paginate(:page => params[:page])
  end

end
