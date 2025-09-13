class HealthCheckController < ApplicationController
  rescue_from(Exception) { render_down }

  def show
    render_up
  end

  private

  def render_up
    ActiveRecord::Base.connection.execute("SELECT 1")

    respond_to do |format|
      format.html { render html: html_status(color: "green") }
      format.json { render json: { status: "up", timestamp: Time.current.iso8601 } }
    end
  end

  def render_down
    respond_to do |format|
      format.html { render html: html_status(color: "red"), status: 500 }
      format.json { render json: { status: "down", timestamp: Time.current.iso8601 }, status: 500 }
    end
  end

  def html_status(color:)
    %(<!DOCTYPE html><html><body style="background-color: #{color}"></body></html>).html_safe
  end
end
