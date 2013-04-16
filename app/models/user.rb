class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :confirmable
  devise :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :provider, :uid
  # attr_accessible :title, :body

  def self.find_for_omniauth(auth)
    user = User.find_by_email(auth.info.email)

    if user
      user.update_attributes!(
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email,
        password: Devise.friendly_token[0,20]
      )
    else
      user = User.create!(
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email,
        password: Devise.friendly_token[0,20]
      )

      # user.skip_confirmation!
      # user.send_reset_passoword_instructions
    end

    user
  end

  def self.find_for_google_oauth(auth)
    find_for_omniauth(auth)
  end

  def self.find_for_dropbox_oauth(auth)
    user = find_for_omniauth(auth)

    user.update_attributes!(
      dropbox_token: auth.extra.access_token.token,
      dropbox_secret: auth.extra.access_token.secret
    )

    user
  end
end
