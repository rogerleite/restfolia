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
  
  describe "#initialize - setter method" do

    it "should support attribution" do
      resource = subject.new(:id => "123abcd",:dummy_value => "test test")
      resource.dummy_value = "test 321 321"
      resource.dummy_value.must_equal("test 321 321")
    end

    it "should support attribution of hash key" do
      resource = subject.new({:id => "123abcd", 
        :dummy_value => "test 123 123", 
        :dummy_hash => { :another_key => "lorem ipsum", :another_one_key => "dolor sit" }
      })
      resource.dummy_hash[:another_key] = "changing another_key value"
      resource.dummy_hash[:another_key].must_equal("changing another_key value")
    end

    it "should support attribution of the entire hash" do
      resource = subject.new({:id => "123abcd", 
        :dummy_value => "test 123 123", 
        :dummy_hash => { :another_key => "lorem ipsum", :another_one_key => "dolor sit" }
      })
      resource.dummy_hash = { :a_key => "a new key" }
      resource.dummy_hash.must_equal({ :a_key => "a new key" })
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

    it "understand 'links' as string hash key" do
      resource = subject.new('links' => array_links)
      resource.links.must_be_instance_of(Array)
      resource.links[0].must_be_instance_of(Restfolia::EntryPoint)
    end

    it "understand 'link' as string hash key" do
      resource = subject.new('link' => array_links)
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

      it "returns EntryPoint even when hash key is string" do
        resource = subject.new('link' => {'rel' => 'rel2', 'href' => 'http://localhost/'})
        resource.links("rel2").must_be_instance_of(Restfolia::EntryPoint)
      end

    end

  end

end
