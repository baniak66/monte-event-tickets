# frozen_string_literal: true

RSpec.shared_context "user_token_authentication", shared_context: :metadata do
  let(:user) { create :user }

  def user_auth_headers
    post user_session_path,
         params:  { email: user.email, password: user.password }.to_json,
         headers: { 'CONTENT_TYPE' => 'application/json' }

    response.headers.slice('access-token', 'client', 'uid', 'expiry', 'token_type')
  end
end
