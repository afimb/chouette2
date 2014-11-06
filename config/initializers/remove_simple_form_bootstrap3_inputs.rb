inputs = %w[
  CollectionSelectInput
   DateTimeInput
   FileInput
   GroupedCollectionSelectInput
   NumericInput
   PasswordInput
   RangeInput
   StringInput
  TextInput
]

# Instead of creating top-level custom input classes like TextInput, we wrap it into a module and override
# mapping in SimpleForm::FormBuilder directly
#
SimpleFormBootstrapInputs = Module.new
inputs.each do |input_type|
  superclass = "SimpleForm::Inputs::#{input_type}".constantize

  new_class = SimpleFormBootstrapInputs.const_set(input_type, Class.new(superclass) do
    def input_html_classes
      super.push('form-control')
    end
  end)

  # Now override existing usages of superclass with new_class
  SimpleForm::FormBuilder.mappings.each do |(type, target_class)|
    if target_class == superclass
      SimpleForm::FormBuilder.map_type(type, to: new_class)
    end
  end
end
