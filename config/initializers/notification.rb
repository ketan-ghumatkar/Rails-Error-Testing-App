require "net/http"

ActiveSupport::Notifications.subscribe "process_action.action_controller" do |name, start, finish, id, payload|
  begin
    if payload[:exception].present?
      url = URI.parse('http://localhost:3001/error_requests')
      params = {"error_controller" => payload[:controller], "error_action" => payload[:action],"error_format" => payload[:format], "method" => payload[:method], "path" => payload[:path], "error" => payload[:exception][0], "error_info" => payload[:exception][1]}
    elsif payload[:controller] == "ErrorController"
      url = URI.parse('http://localhost:3001/error_requests')
      params = {"error_controller" => payload[:controller], "error_action" => payload[:action],"error_format" => payload[:format], "method" => payload[:method], "path" => payload[:path], "error" => "routing error", "error_info" => "It may be that the user have misspelled or devs have forgot to ensure the path"}
    end
  resp = Net::HTTP.post_form(url, params)
  rescue => e
    log = Logger.new('log/'+Rails.env+'.log')
    log.error "[Project-106] Error reporting exception to Project-106: #{e}"
  end
end

