# frozen_string_literal: true

module Credentials
  extend self

  # Look up an encrypted credentials, optionally by environment
  #
  #   # Find the specific "development" value:
  #   Config.fetch(:friendspace_token, env: :development)
  #
  #   # Check if there's an env-specific value, or fall back to a global one:
  #   Config.fetch(:friendspace_token)
  #
  # Edit encrypted credentials by
  #   EDITOR=vim ./bin/rails credentials:edit
  def fetch(key, env: nil)
    if env
      Rails.application.credentials.fetch(env).fetch(key)
    else
      value = Rails.application.credentials.dig(Rails.env.to_sym, key)
      value ||= Rails.application.credentials[key]
      value || raise("Couldn't find '#{key}' in encrypted fetchs")
    end
  end

  def github_pat_token
    fetch(:github_pat_token)
  end
end
