class SignedInConstraint < Struct.new(:value)
  def matches?(request)
    request.cookies.key?(:auth_token) == value
  end
end
