module LoginHelpers
  def log_in_as(user)
    post user_session_path, params: { session: { email: user.email, password: user.password } }
  end
end
