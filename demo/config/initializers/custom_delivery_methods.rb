require "microsoft_graph/delivery_method"
require "send_grid_helper/delivery_method"

ActionMailer::Base.add_delivery_method :microsoft_graph_api, MicrosoftGraph::DeliveryMethod
ActionMailer::Base.add_delivery_method :sendgrid_api, SendGridHelper::DeliveryMethod
