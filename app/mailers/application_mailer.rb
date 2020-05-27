# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'service@loan_manager.dakalabs.com'
  layout 'mailer'
end
