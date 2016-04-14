require 'spec_helper'

describe Chouette::Timeband, :type => :model do

  describe '#create' do
    context 'when valid' do
      it { create(:timeband) }
    end

    context 'when not valid' do
      it 'fails validation with end_time before start_time' do
        timeband = build(:timeband_invalid)
        expect(timeband).to be_invalid
      end
    end
  end

end
