require 'order'

class GetAllGuests
  def run()
    format_response(guests)
  end

  private

  def guests
    Order.all.map { |order| "#{order.user_name}" if order.host }.compact
  end

  def format_response(guest)
    if guest.empty?
      "no guest"
    else
      guest.join("\n")
    end
  end
end
