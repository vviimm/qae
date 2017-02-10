require "qae_2014_forms/web_development/web_development_step1"

class QAE2014Forms
  class << self
    def web
      @web ||= QAEFormBuilder.build "Web Development Award Application" do
        step "Company Information",
             "Company Information",
             &QAE2014Forms.web_step1
      end
    end
  end
end
