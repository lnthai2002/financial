require_dependency "financial/application_controller"

module Financial
  class AuthorizableController < ApplicationController
    authorize_resource

    def current_ability
      Financial::Ability.new(@person)
    end
  end
end