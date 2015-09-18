require 'spec_helper'

describe Petition do

  before(:each) do
    @attr = {
      :title => "Save Kittens",
      :description => "Save kittens in great detail",
      :goal => 10
    }
  end

  it "should create a new instance given a valid attribute" do
    Petition.create!(@attr)
  end

end
