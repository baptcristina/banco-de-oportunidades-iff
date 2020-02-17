module DeviseHelper
 def devise_error_messages!
  return '' if resource.errors.empty?

   messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
   sentence = I18n.t('errors.messages.not_saved',
   count: resource.errors.count,
   resource: resource.class.model_name.human.downcase)

   html = <<-HTML
    <span class="error_msgs fade in">
        <p class="alert alert-danger" style="font-size: 11px"> <a class="glyphicon glyphicon-info-sign" style="color: red;"> </a>&nbsp&nbsp
            Email já consta no sistema ou senha não confere <button class="close" data-dismiss="alert">×</button>
        </p>
    </span>
   HTML

   html.html_safe
 end
end