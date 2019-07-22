class ApplicationController < ActionController::Base
    include SessionsHelper
    protect_from_forgery with: :exception
    def hello
        render html: "Hello world!"
    end
end
