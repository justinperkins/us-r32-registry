class Notifier < ActionMailer::Base
  
  def forgot_password( user, confirmation )
    admin = User.find_an_admin
    recipients user.email
    from admin.email
    subject 'Help with R32 Registry Password'
    body :first_name => user.first_name, :last_name => user.last_name, :confirmation_number => confirmation.number
  end
end
