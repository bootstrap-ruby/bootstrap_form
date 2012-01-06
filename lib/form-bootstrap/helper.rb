module FormBootstrap
  module Helper
    def form_bootstrap_for(object, options = {}, &block)
      options[:builder] = FormBootstrap::Builder
      form_for(object, options, &block)
    end
  end
end
