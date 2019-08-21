# frozen_string_literal: true

module Workarea
  module AuthorizeCim
    class Engine < ::Rails::Engine
      include Workarea::Plugin
      isolate_namespace Workarea::AuthorizeCim
    end
  end
end
