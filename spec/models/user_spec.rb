require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
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
  
  it "should require a password" do
    blank_password_user = User.new(@attr.merge(:password => "", :password_confirmation => ""))      
    blank_password_user.should be_invalid
  end

  it "should require a matching password confirmation" do
    mismatching_password_confirmation_user = User.new(@attr.merge(:password => "mismatch"))
    mismatching_password_confirmation_user.should_not be_valid
  end

  it "should reject short passwords" do
    short_password = "a" * 5
    short_password_user = User.new(@attr.merge(:password => short_password, :password_confirmation => short_password))
    short_password_user.should_not be_valid
  end

  it "should reject long passwords" do
    long_password = "a" * 41
    long_password_user = User.new(@attr.merge(:password => long_password, :password_confirmation => long_password))
    long_password_user.should_not be_valid
  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
    
  end
  
  describe "has_password? method" do

    it "should be true if the passwords match" do
      @user.has_password?(@attr[:password]).should be_true
    end    

    it "should be false if the passwords don't match" do
      @user.has_password?("invalid").should be_false
    end 
      
  end
  
  describe "authenticate method" do

      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end

      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
  
end