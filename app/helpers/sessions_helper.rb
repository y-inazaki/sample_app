module SessionsHelper

  def sign_in(user)
    # permanent : expire => 20.years.from_now
    # signed : make cookie secure. all cookie value is encrypted.
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end


  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def user_from_remember_token
    User.authenticate_with_salt(*remember_token) # *: split 2 element array to 2 args
    # User.authenticate_with_salt(remember_token[0], remember_token[1])
  end

  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end
end
