# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

class Notifier < ActionMailer::Base
  
  def forgot_password( user, confirmation )
    admin = User.find_an_admin
    recipients user.email
    from admin.email
    subject 'Help with R32 Registry Password'
    body :first_name => user.first_name, :last_name => user.last_name, :confirmation_number => confirmation.number
  end
end
