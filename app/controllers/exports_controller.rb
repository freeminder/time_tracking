# frozen_string_literal: true

# Exports controller
class ExportsController < ApplicationController
  before_action :authorize_admin, only: :stat

  def stat
    render xlsx: "#{params[:export][:type].capitalize}Report",
           template: "exports/#{params[:export][:type]}"
  end
end
