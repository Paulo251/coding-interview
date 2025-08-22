class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome_email.subject
  #
  def welcome_email(user)
    @user = user
    @login_url = 'http://localhost:3000/login'

    mail(
      to: @user.email,
      subject: "Bem-vindo! #{@user.display_name}!"
    )
  end
end
