require 'spec_helper'

describe ImportTask do

  subject { build :import_task }

  describe ".new" do

    it "should use type attribute to create a subclass" do
      ImportTask.new(:format => "Neptune").should be_an_instance_of(NeptuneImport)
      ImportTask.new(:format => "Gtfs").should be_an_instance_of(GtfsImport)
      ImportTask.new(:format => "Netex").should be_an_instance_of(NetexImport)
      ImportTask.new(:format => "Csv").should be_an_instance_of(CsvImport)

      NeptuneImport.new.should be_an_instance_of(NeptuneImport)
      GtfsImport.new.should be_an_instance_of(GtfsImport)
      NetexImport.new.should be_an_instance_of(NetexImport)
      CsvImport.new.should be_an_instance_of(CsvImport)
    end

  end

  describe "#delayed_import" do
    before(:each) do
      subject.stub!( :delay => mock( :import => true))
    end
    it "should call delay#import" do
      subject.delay.should_receive( :import)
      subject.send :delayed_import
    end
  end

  describe ".create" do
    before(:each) do
      subject.stub!( :save_resources => true )
    end
    it "should call save_resource" do
      subject.should_receive( :save_resources)
      subject.send :save
    end
    it "should update file_path with #saved_resources" do
      subject.send :save
      ImportTask.find( subject.id).file_path.should == subject.send( :saved_resources)
    end
    it "should have a compliance_check_task" do
      subject.send :save
      ImportTask.find( subject.id).compliance_check_task.should_not be_nil
    end
  end

  describe "#compliance_check_task" do
    let(:rule_parameter_set){ Factory( :rule_parameter_set) }
    let(:import_task){ Factory(:import_task, :rule_parameter_set_id => rule_parameter_set.id) }
    let(:compliance_check_task){ import_task.compliance_check_task }

    it "should have same #referential as import_task" do
      compliance_check_task.referential.should == import_task.referential
    end

    it "should have same #rule_parameter_set_id as import_task" do
      compliance_check_task.rule_parameter_set_id.should == import_task.rule_parameter_set_id
    end

    it "should have same #user_id as import_task" do
      compliance_check_task.user_id.should == import_task.user_id
    end

    it "should have same #user_name as import_task" do
      compliance_check_task.user_name.should == import_task.user_name
    end
  end

  describe "#file_path_extension" do
    let(:import_task){ Factory(:import_task) }
    context "zip file to import" do
      before(:each) do
        import_task.file_path = "aaa/bbb.zip"
      end
      it "should return zip" do
        import_task.file_path_extension.should == "zip"
      end
    end
    context "xml file to import" do
      before(:each) do
        import_task.file_path = "aaa/bbb.xml"
      end
      it "should return xml" do
        import_task.file_path_extension.should == "xml"
      end
    end
    context "csv file to import" do
      before(:each) do
        import_task.file_path = "aaa/bbb.csv"
      end
      it "should return csv" do
        import_task.file_path_extension.should == "basic"
      end
    end

  end

  context "options attributes" do
    let(:import_task){ Factory(:import_task) }
    describe "#no_save" do
      it "should read parameter_set['no_save']" do
        import_task.parameter_set[ "no_save"] = "dummy"
        import_task.no_save.should == "dummy"
      end
    end
    describe "#format" do
      it "should read parameter_set['format']" do
        import_task.parameter_set[ "format"] = "dummy"
        import_task.format.should == "dummy"
      end
    end
    describe "#file_path" do
      it "should read parameter_set['file_path']" do
        import_task.parameter_set[ "file_path"] = "dummy"
        import_task.file_path.should == "dummy"
      end
    end
    describe "#no_save=" do
      it "should read parameter_set['no_save']" do
        import_task.no_save = "dummy"
        import_task.parameter_set[ "no_save"].should == false
      end
    end
    describe "#format=" do
      it "should read parameter_set['format']" do
        import_task.format = "dummy"
        import_task.parameter_set[ "format"].should == "dummy"
      end
    end
    describe "#file_path=" do
      it "should read parameter_set['file_path']" do
        import_task.file_path = "dummy"
        import_task.parameter_set[ "file_path"].should == "dummy"
      end
    end
  end

  describe "#chouette_command" do
    it "should be a Chouette::Command instance" do
      subject.send( :chouette_command).class.should == Chouette::Command
    end
    it "should have schema same as referential.slug" do
      subject.send( :chouette_command).schema.should == subject.referential.slug
    end
  end

  describe "#import" do
    let(:import_task){ Factory(:import_task) }
    let(:chouette_command) { "dummy" }
    context "for failing import" do
      before(:each) do
        chouette_command.stub!( :run!).and_raise( "dummy")
        import_task.stub!( :chouette_command => chouette_command)
      end
      it "should have status 'failed'" do
        import_task.import
        import_task.status.should == "failed"
      end
      it "should have status 'failed' for compliance_check_task" do
        import_task.import
        import_task.compliance_check_task.status.should == "failed"
      end
    end
    context "for successful import" do
      before(:each) do
        import_task.stub!( :chouette_command => mock( :run! => true ))
      end
      it "should have status 'completed'" do
        import_task.import
        import_task.status.should == "completed"
      end
      it "should have status 'completed' for compliance_check_task" do
        import_task.import
        import_task.status.should == "completed"
      end
    end
  end

  describe "#import" do
    let(:import_task){ Factory(:import_task) }
    let(:command_args){ "dummy" }
    before(:each) do
      import_task.stub!( :chouette_command => mock( :run! => true ))
      import_task.stub!( :chouette_command_args => command_args)
    end
    it "should call chouette_command.run! with :c => 'import', :id => id" do
      import_task.send( :chouette_command).should_receive( :run! ).with(  command_args)
      import_task.import
    end
  end

end
