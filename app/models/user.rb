
class User < ActiveRecord::Base
  
  attr_accessor :password, :password_confirmation
  attr_accessible :name, :email, :password, :password_confirmation
  
  # Delete the microposts if user is deleted
  has_many :microposts, :dependent => :destroy
  # The user's relationships following and followers. Tells that in the relationships table, I am the follower_id.
  has_many :follower_relationships, :foreign_key => "follower_id", 
                                    :class_name => "Relationship",
                                    :dependent => :destroy
  # To get to the followed users directly. Tells that in the relationships table, the other guy is the followed id. Source is to override pluralization i.e. to have following not followeds
  has_many :following, :through => :follower_relationships, 
                       :source => :followed
  
  has_many :followed_relationships, :foreign_key => "followed_id",
                                    :class_name => "Relationship",
                                    :dependent => :destroy
                                   
  has_many :followers, :through => :followed_relationships,
                       :source => :follower
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name,     :presence => true, 
                       :length => {:maximum => 50}
                   
  validates :email,    :presence => true, 
                       :uniqueness => { :case_sensitive => false },
                       :format => {:with => email_regex}
  
  validates :password, :presence => true,
                       :length => {:within => 6..40},   
                       :confirmation => true                 
                    
  before_save :encrypt_password
  
  public
  
    def has_password?(submitted_password)
      encrypted_password == encrypt(submitted_password)
    end
    
    def User.authenticate(email, submitted_password)
      user = find_by_email(email)
      return nil  if user.nil?
      return user if user.has_password?(submitted_password)
   end
   
   def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def following?(followed)
    follower_relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    self.follower_relationships.create!(:followed_id => followed.id)
  end
  
  def unfollow!(followed)
    follower_relationships.find_by_followed_id(followed).destroy
  end
  
  def feed
    Micropost.from_users_followed_by(self)
  end

  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
    
end