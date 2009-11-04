window('<%= class_name %> List',700,350) do
  dbgrid(<%= class_name %> ,<%= controller_class_name %>Controller,form_authenticity_token) do
<%= attributes.collect {|attribute| "    field('#{attribute.name}')"}.join("\n") %>
  end
end
