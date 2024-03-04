# frozen_string_literal: true

class ActorWithModuleInput < Actor
  input :module_const, type: Module

  output :module_name, type: String

  def call
    self.module_name = module_const.name
  end
end
