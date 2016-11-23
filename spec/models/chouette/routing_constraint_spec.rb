require 'spec_helper'

RSpec.describe Chouette::RoutingConstraint, type: :model do
  describe '#create' do
    context 'when valid' do
      it { create(:routing_constraint) }
    end
  end
end
