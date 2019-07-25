class User < ApplicationRecord
    has_many :microposts, dependent: :destroy
    attr_accessor :remember_token, :activation_token, :pw_reset_token
    before_save :downcase_email
    before_create :create_activation_digest
    validates :name, presence: true, length: {maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+\.[a-z]+\z/i
    validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }, allow_blank: true
    # allow blank is for updating user and it does not make the password being saved as '' if password field is blank
    # but allows blank for a password reset

    class << self
        # return a hash digest on a given string
        def digest(string)
            cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
            BCrypt::Password.create(string, cost: cost)
        end

        # Return a random token
        def new_token
            SecureRandom.urlsafe_base64
        end
    end

    # Remember user by creating a new token and save the digest of it in the database for persistent cookie
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    # Compare if the given token matches with the token digest of the user saved in the database and return true or false
    # def authenticated?(remember_token)
    #     if(!remember_digest.nil?)
    #         BCrypt::Password.new(remember_digest).is_password?(remember_token)
    #     else
    #         return false
    #     end
    # end
    def authenticated?(attribute, token)
        digest = self.send("#{attribute}_digest")
        if(!digest.nil?)
            BCrypt::Password.new(digest).is_password?(token)
        else
            return false
        end
    end

    # Forget user to log this user out
    def forget
        update_attribute(:remember_digest, nil)
    end

    def activate
        update_attribute(:activated, true)
        update_attribute(:activated_at, Time.zone.now)
    end

    def send_activation_email
        UserMailer.account_activation(@user).deliver_now
    end

    def create_pw_reset_digest
        self.pw_reset_token = User.new_token
        update_attribute(:pw_reset_digest, User.digest(pw_reset_token))
        update_attribute(:pw_reset_at, Time.zone.now)
    end

    def send_pw_reset_email
        UserMailer.password_reset(self).deliver_now
    end

    def pw_reset_expired?
        pw_reset_at_was < 2.hours.ago 
    end
    # find all posts by a user
    # def feed
    #     Micropost.where("user_id = ?", id)
    # end

    private
    # create token and its digest to save in db
    def create_activation_digest
        self.activation_token = User.new_token
        self.activation_digest = User.digest(activation_token)
        # the digest will be saved when the user record is created
    end
    # downcase email before saving it to db
    def downcase_email
    self.email = email.downcase
    end
end
