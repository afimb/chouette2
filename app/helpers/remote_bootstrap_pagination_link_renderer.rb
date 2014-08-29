# remote link for will paginate, using bootstrap as renderer
class RemoteBootstrapPaginationLinkRenderer < BootstrapPagination::Rails
  def link (text,target, attributes = {})
    attributes["data-remote"] = true
    super
  end

end
