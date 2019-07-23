class User < ApplicationRecord
    attr_accessor :remember_token
    before_update {self.email = self.email.downcase}
    validates :name, presence: true, length: {maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+\.[a-z]+\z/i
    validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }, allow_blank: true
    # allow blank is for updating user and it does not make the password being saved as '' if password field is blank

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

    # Compare if the given remember token matches with the token digest of the user saved in the database and return true or false
    def authenticated?(remember_token)
        if(!remember_digest.nil?)
            BCrypt::Password.new(remember_digest).is_password?(remember_token)
        else
            return false
        end
    end

    # Forget user to log this user out
    def forget
        update_attribute(:remember_digest, nil)
    end
end
