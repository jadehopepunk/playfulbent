class LabelledBuilder < BaseBuilder
  ACRONYMS = [:url]

  def self.create_labelled_field(method_name)
    define_method(method_name) do |label, *args|
      if args && args.last && args.last.is_a?(Hash)
        hint = args.last[:hint]
        label_override = args.last[:label]
        description = args.last[:description]
        other_validation_fields = args.last[:other_validation_fields]
      end
      
      field_human_name = label_override ? label_override : (ACRONYMS.include?(label) ? label.to_s.upcase : label.to_s.humanize.titleize)
      
      label_inner_text = field_human_name
      if hint
        hint_text = @template.content_tag('span', "(#{hint})", :class => 'hint')
        label_inner_text += ' ' + hint_text
      end
      label_text = @template.content_tag('label', label_inner_text, :for => "#{@object_name}_#{label}")

      field_text = ''
      
      field_text += @template.content_tag('div', description, :class => 'description') if description
      field_text += super
      
      error_fields = [label]
      error_fields += other_validation_fields if other_validation_fields
      error_text = error_fields.map do |error_field|
        @template.error_message_on(@object_name, error_field, :prepend_text => "<strong>Sorry</strong>, #{field_human_name} ")
      end
      error_text = error_text.join(' ')
      
      @template.content_tag('div', label_text + error_text + field_text, :class => 'form_row')
    end
  end
  
  (field_helpers + [:select, :image_selector, :rating_selector, :textile_editor]).uniq.each do |name|
    create_labelled_field(name) unless name == 'hidden_field'
  end

end