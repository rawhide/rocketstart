module Authentication
  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      include InstanceMethods
    end
  end
  
  module ClassMethods
    def authenticate(login, password)
      return nil if login.blank? || password.blank?
      u = find_by_email(login.downcase)
      u && u.authenticated?(password) ? u : nil
    end
    
    def password_digest(password, salt)
      digest = REST_AUTH_SITE_KEY
      REST_AUTH_DIGEST_STRETCHES.times do
        digest = secure_digest(digest, salt, password, REST_AUTH_SITE_KEY)
      end
      digest
    end
    
    def secure_digest(*args)
      Digest::SHA1.hexdigest(args.flatten.join('--'))
    end
    
    def make_token
      secure_digest(Time.now, (1..10).map{ rand.to_s })
    end
  end

  module InstanceMethods
    def encrypt(password)
      self.class.password_digest(password, salt)
    end
    
    def authenticated?(password)
      crypted_password == encrypt(password)
    end
    
    def encrypt_password
      return if password.blank?
      self.salt = self.class.make_token if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
  end
end
