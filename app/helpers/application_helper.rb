module ApplicationHelper
  def nav_link(text, path, icon_class, controller_path)
    active_class = controller.controller_path == controller_path ? 'active' : ''

    content_tag(:li, class: "nav-item mb-1") do
      link_to(path, class: "nav-link text-white #{active_class}") do
        content_tag(:i, "", class: "bi #{icon_class} me-2") + text
      end
    end
  end

  def link_to_add_fields(name, f, association, **args)
    new_object = f.object.send(association).klass.new
    
    id = new_object.object_id

    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end

    link_to(name, '#',
      class: "btn btn-outline-success #{args[:class]}",
      data: { 
        action: 'click->nested-form#add',
        'nested-form-target': 'template',
        'fields': fields.gsub("\n", "")
      }
    )
  end
end

