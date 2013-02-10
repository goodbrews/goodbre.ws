class User < ActiveRecord::Base
  has_secure_password

  before_create { generate_token(:auth_token) }
  after_create { send_welcome_email }

  validate :password, length: { minimum: 6, on: :create }

  validate :username, exclusion: { 
                        in: %w(admin superuser root goodbrews guest),
                        message: 'is reserved'
                      },
                      format: {
                        with: /\A\w+\Z/,
                        message: 'can only contain letters, numbers, and underscores'
                      },
                      uniqueness: {
                        case_sensitive: false,
                        message: 'has already been taken'
                      },
                      length: { within: 1..20 },
                      presence: true

  validate :email, format: { with: /@/ },
                   uniqueness: { 
                     case_sensitive: false,
                     message: 'is already in use'
                   },
                   presence: true

  # I mean, I AM the only one right now.
  def admin?
    username == 'davidcelis'
  end

  def to_param
    username.parameterize
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def send_welcome_email
    UserMailer.welcome(self).deliver
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def self.from_param(param)
    where('username ILIKE ?', param).first
  end

  def self.find_by_login(login)
    where('username ILIKE ? OR email ILIKE ?', login, login).first
  end

  def self.paginate(options = {})
    page(options[:page]).per(options[:per_page])
  end
end
