# # The correct method is .before_failure, which runs after a strategy
# # fails but before the failure app is called.
# Warden::Manager.before_failure do |env, opts|
#   scope       = opts[:scope] || :user
#   failure_key = opts[:message]

#   if failure_key.present?
#     i18n_key            = "devise.failure.#{message_key}"
#     authentication_keys = Devise.mappings[scope].to.authentication_keys.join(I18n.t(:'support.array.words_connector'))
#     message             = I18n.t(i18n_key, authentication_keys:)

#     env["app.auth_failure_reason"] =
#   end
#   # The logic inside the block remains the same.

#   # opts[:message] contains the key for the failure, e.g., :invalid
#   # We can get the full i18n message from it.
#   # Note: The original warden opts[:message] might be a string in some cases,
#   # so we use a fallback to prevent errors.
#   message_key = opts[:message] || "unauthenticated"
#   failure_reason = I18n.t(:"devise.failure.#{message_key}", default: message_key.to_s.humanize)

#   # Store the failure reason directly in the request's environment hash.
#   # This is a reliable way to pass data through a single request.
#   env["app.auth_failure_reason"] = failure_reason
# end
