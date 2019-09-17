class ExportsController < ApplicationController
  before_filter :authorize_admin, only: [:stat]

  def stat
    render xlsx: "#{params[:export][:type].capitalize}Report", template: "exports/#{params[:export][:type]}"
  end
end
