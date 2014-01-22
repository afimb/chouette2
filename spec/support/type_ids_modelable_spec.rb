require 'spec_helper'

shared_examples_for TypeIdsModelable do
  context 'class methods' do
    it 'should be a TypeIdsModelable class' do
      described_class.type_ids_modelable_class?.should be_true
    end
    describe ".references_relation" do
      it "shoud demodulize, underscore and puralize" do
        described_class.references_relation( Chouette::StopArea).should == "stop_areas"
      end
    end
  end

  context 'with an instance' do
    describe "#references" do
      it "should be empty if references_type is nil" do
        type_ids_model.references_type = nil
        type_ids_model.references.should be_empty
      end
      it "should be empty if reference_ids is blank" do
        type_ids_model.reference_ids = ""
        type_ids_model.references.should be_empty
      end
    end
    describe "#references=" do
      let(:lines) { create_list :line, 3 }

      context "when references defined" do
        before(:each) do
          type_ids_model.references = lines
        end
        it "should set reference_ids to [data_a.id]" do
          type_ids_model.reference_ids.should == lines.map(&:id)
        end
        it "should set references_type to EffectiveDataTypeA" do
          type_ids_model.references_type.should == 'Chouette::Line'
        end
      end
      context "when references blank" do
        before(:each) do
          type_ids_model.references = ""
        end
        it "should set reference_ids to []" do
          type_ids_model.reference_ids.should == []
        end
        it "should set references_type to nil" do
          type_ids_model.references_type.should be_nil
        end
      end
    end

    describe "#references_relation" do
      it "should be 'lines' when relation_type is 'Chouette::Line'" do
        type_ids_model.references_type = "Chouette::Line"
        type_ids_model.references_relation.should == "lines"
      end

      it "should be 'networks' when relation_type is 'Chouette::Network'" do
        type_ids_model.references_type = "Chouette::Network"
        type_ids_model.references_relation.should == "networks"
      end

      it "should be nil when relation_type is blank" do
        type_ids_model.references_type = ""
        type_ids_model.references_relation.should be_nil
      end

      it "should be nil when relation_type is 'dummy'" do
        type_ids_model.references_type = "dummy"
        type_ids_model.references_relation.should be_nil
      end
    end

    describe "#reference_ids" do
      it "should parse raw_reference_ids and returns ids" do
        type_ids_model.stub :raw_reference_ids => "1,2,3"
        type_ids_model.reference_ids.should == [1,2,3]
      end

      it "should be empty if raw_reference_ids is blank" do
        type_ids_model.stub :raw_reference_ids => ""
        type_ids_model.reference_ids.should be_empty
      end
    end

    describe "#reference_ids=" do
      it "should join ids with comma" do
        type_ids_model.reference_ids = [1,2,3]
        type_ids_model.raw_reference_ids.should == "1,2,3"
      end
      it "should be nil if records is blank" do
        type_ids_model.reference_ids = []
        type_ids_model.raw_reference_ids.should be_nil
      end
    end
  end


end
