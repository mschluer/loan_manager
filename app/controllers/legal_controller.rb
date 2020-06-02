# frozen_string_literal: true

class LegalController < ApplicationController
  skip_before_action :redirect_to_index_if_not_logged_in

  def disclaimer; end

  def privacy; end

  def legal_note; end
end
