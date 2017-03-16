require 'models/order'
require 'models/crafter'
require 'days'

module Commands
  class GetAllOrders
    def run
      format_response(orders)
    end

    def applies_to(request)
      request == "all orders?"
    end

    def prepare(data)
    end

    private

    def orders
      orders_of_the_week = Order.all(:date => (Days.from_monday_to_friday))

      orders_of_the_week.map { |order|
        "#{full_name(order.user_id)}: #{order.lunch}" if !order.lunch.nil?
      }.compact.sort
    end

    def full_name(user_id)
      Crafter.first(:slack_id => user_id).user_name
    end

    def format_response(orders)
      response = ""
      if orders.empty?
        response = "no orders"
      else
        response = orders.join("\n").strip
      end

      response
    end
  end
end
