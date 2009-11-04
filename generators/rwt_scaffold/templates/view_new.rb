window('New <%= class_name %>',500,250) do
  editform(@<%= file_name %> ,<%= controller_class_name %>Controller,form_authenticity_token) do
<%= attributes.collect {|attribute| "    field('#{attribute.name}')"}.join("\n") %>
  end
end