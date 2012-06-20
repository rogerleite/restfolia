require "test_helper"

describe Restfolia::Resource do

  let(:subject) { Restfolia::Resource }

  describe "#initialize" do

    it "accept only hash object as parameter" do
      lambda { subject.new(nil) }.must_raise(ArgumentError)
    end

  end

  describe "#initialize - look_for_resource" do

    it "transforms hash keys in attributes" do
      resource = subject.new(:attr_test => "test")

      resource.must_respond_to(:attr_test)
      resource.attr_test.must_equal("test")
    end

    it "should support id attribute" do
      resource = subject.new(:id => "123abc")

      resource.id.must_equal("123abc")
    end

  end

  describe "#links" do

    let(:hash_link) do
      {:href => "http://service.com", :rel => "rel", :type => "type"}
    end

    let(:array_links) do
      link2 = hash_link
      link2[:rel] = "rel2"

      [hash_link, link2]
    end

    it "returns empty Array for no links" do
      resource = subject.new(:attr_test => "test")
      resource.links.must_be_empty
    end

    it "returns Array for one link" do
      resource = subject.new(:links => hash_link)
      resource.links.must_be_instance_of(Array)
      resource.links[0].must_be_instance_of(Restfolia::EntryPoint)
    end

    it "returns Array for many links" do
      resource = subject.new(:links => array_links)
      resource.links.must_be_instance_of(Array)
      resource.links[0].must_be_instance_of(Restfolia::EntryPoint)
      resource.links.size.must_equal(2)
    end

    it "understand 'link' node too" do
      resource = subject.new(:link => array_links)
      resource.links.must_be_instance_of(Array)
      resource.links[0].must_be_instance_of(Restfolia::EntryPoint)
    end

    it "raises Error for invalid link" do
      resource = subject.new(:links => {:invalid => "invalid"})
      lambda { resource.links }.must_raise(RuntimeError)
    end

    describe "rel search" do

      it "returns nil for rel not found (without link)" do
        resource = subject.new(:attr_test => "test")
        resource.links("notexist").must_be_nil
      end

      it "returns nil for rel not found (with links)" do
        resource = subject.new(:links => array_links)
        resource.links("notexist").must_be_nil
      end

      it "returns EntryPoint for rel found" do
        resource = subject.new(:links => array_links)
        resource.links("rel2").must_be_instance_of(Restfolia::EntryPoint)
      end

    end

  end

end
