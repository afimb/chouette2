require 'spec_helper'

shared_examples_for TypeIdsModelable do
  context 'class methods' do
    it 'should be a TypeIdsModelable class' do
      expect(described_class.type_ids_modelable_class?).to be_truthy
    end
    describe ".references_relation" do
      it "shoud demodulize, underscore and puralize" do
        expect(described_class.references_relation( Chouette::StopArea)).to eq("stop_areas")
      end
    end
  end

  context 'with an instance' do
    describe "#references" do
      it "should be empty if references_type is nil" do
        type_ids_model.references_type = nil
        expect(type_ids_model.references).to be_empty
      end
      it "should be empty if reference_ids is blank" do
        type_ids_model.reference_ids = ""
        expect(type_ids_model.references).to be_empty
      end
    end
    describe "#references=" do
      let(:lines) { create_list :line, 3 }

      context "when references defined" do
        before(:each) do
          type_ids_model.references = lines
        end
        it "should set reference_ids to [data_a.id]" do
          expect(type_ids_model.reference_ids).to eq(lines.map(&:id))
        end
        it "should set references_type to EffectiveDataTypeA" do
          expect(type_ids_model.references_type).to eq('Chouette::Line')
        end
      end
      context "when references blank" do
        before(:each) do
          type_ids_model.references = ""
        end
        it "should set reference_ids to []" do
          expect(type_ids_model.reference_ids).to eq([])
        end
        it "should set references_type to nil" do
          expect(type_ids_model.references_type).to be_nil
        end
      end
    end

    describe "#references_relation" do
      it "should be 'lines' when relation_type is 'Chouette::Line'" do
        type_ids_model.references_type = "Chouette::Line"
        expect(type_ids_model.references_relation).to eq("lines")
      end

      it "should be 'networks' when relation_type is 'Chouette::Network'" do
        type_ids_model.references_type = "Chouette::Network"
        expect(type_ids_model.references_relation).to eq("networks")
      end

      it "should be nil when relation_type is blank" do
        type_ids_model.references_type = ""
        expect(type_ids_model.references_relation).to be_nil
      end

      it "should be nil when relation_type is 'dummy'" do
        type_ids_model.references_type = "dummy"
        expect(type_ids_model.references_relation).to be_nil
      end
    end

    describe "#reference_ids" do
      it "should parse raw_reference_ids and returns ids" do
        allow(type_ids_model).to receive_messages :raw_reference_ids => "1,2,3"
        expect(type_ids_model.reference_ids).to eq([1,2,3])
      end

      it "should be empty if raw_reference_ids is blank" do
        allow(type_ids_model).to receive_messages :raw_reference_ids => ""
        expect(type_ids_model.reference_ids).to be_empty
      end
    end

    describe "#reference_ids=" do
      it "should join ids with comma" do
        type_ids_model.reference_ids = [1,2,3]
        expect(type_ids_model.raw_reference_ids).to eq("1,2,3")
      end
      it "should be nil if records is blank" do
        type_ids_model.reference_ids = []
        expect(type_ids_model.raw_reference_ids).to be_nil
      end
    end
  end


end
