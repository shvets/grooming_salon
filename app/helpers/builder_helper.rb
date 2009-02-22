#

module BuilderHelper
  def tagged_form_for(name, *args, &block)
    options = args.last.is_a?(Hash) ? args.pop : {}
    options = options.merge(:builder => ValidatingFormBuilder)
    args = (args << options)
    form_for(name, *args, &block)
  end
end
