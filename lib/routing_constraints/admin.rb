class AdminConstraint
  def matches?(request)
    return false unless request.cookies.key?(:auth_token)
    User.find_by_auth_token(request.cookies[:auth_token]).admin?
  end
end
