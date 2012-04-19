require 'spec_helper'

describe "Lines" do
  login_user

  let!(:referential) { create(:referential).switch }
  let!(:lines) { referential; Array.new(2) { create(:line) } }

  describe "GET /lines" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit referential_lines_path(referential)
      page.should have_content(lines.first.name)
    end
  end

end
