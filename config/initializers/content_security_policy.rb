Rails.application.configure do
  config.content_security_policy do |policy|
    cdn_host = "cdn.tongkat.fitness"

    policy.default_src :self, :https, cdn_host
    policy.font_src    :self, :https, :data, cdn_host
    policy.img_src     :self, :https, :data, :blob, cdn_host
    policy.object_src  :none
    policy.script_src  :self, :https, :unsafe_inline, :blob, cdn_host
    policy.worker_src  :self, :blob
    policy.style_src   :self, :https, :unsafe_inline, cdn_host
    policy.connect_src :self, :https, cdn_host

    policy.connect_src :self, :https, :blob, cdn_host
  end

  config.content_security_policy_nonce_generator  = ->(request) { request.session.id.to_s }
  config.content_security_policy_nonce_directives = %w[unsafe-inline]
end
