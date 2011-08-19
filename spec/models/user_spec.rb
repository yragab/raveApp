require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com" }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  
  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should have a name of less than 50 characters" do
    long_name = "a" * 51;
    too_long_name_user = User.new(@attr.merge(:name => long_name))
    too_long_name_user.should_not be_valid
  end
  
  it "should require a unique email address" do
    valid_user = User.create!(@attr)
    repeated_email_user = User.new(@attr)
    repeated_email_user.should_not be_valid
  end
  
  it "should accept a valid email address" do
    valid_emails = ["yusuf.saber@gmail.com", "yusuf_saber@hot.com", "YUSUF@g.o"]
    valid_emails.each do |email|
      valid_email_user = User.new(@attr.merge(:email => email))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject an invalid email" do
    invalid_emails = ["yusuf.saber.gmail.com", "yusuf_saber@hot", "YUSUF@g.o."]
    invalid_emails.each do |email|
      invalid_email_user = User.new(@attr.merge(:email => email))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject similar emails of different case" do
    valid_user = User.create!(@attr)
    repeated_email = @attr[:email].upcase
    invalid_email_user = User.new(@attr.merge(:email => repeated_email))
    invalid_email_user.should_not be_valid
  end
  
end