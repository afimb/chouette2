class ApiKeysController < ChouetteController
  before_action :check_authorize, except: [:show, :index]

  defaults :resource_class => Api::V1::ApiKey

  belongs_to :referential

  def create
    create! { referential_path(@referential) }
  end
  def update
    update! { referential_path(@referential) }
  end
  def destroy
    destroy! { referential_path(@referential) }
  end

  private
  def api_key_params
    params.require(:api_key).permit( :name )
  end

end

