# frozen_string_literal: true

DatabaseCleaner.clean_with :truncation, except: %w[ar_internal_metadata]
