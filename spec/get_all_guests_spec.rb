require 'get_all_guests'
require 'set_order_command'

RSpec.describe GetAllGuests do
  let (:event_data_from_will) { {user_id: "asdf", user_name: "Will" } }
  let (:guest_provider) { GetAllGuests.new }

  it "return list of guest when only one guest" do
    expect(guest_provider.run).to eq("no guest")
  end

  it "return list of guest when only one guest" do
    guest_order_for("james smith")

    expect(guest_provider.run).to eq("james smith")
  end

  it "return the list of the guests when multiple guests" do
    guest_order_for("james smith")
    guest_order_for("jean bon")

    expect(guest_provider.run).to eq("james smith\njean bon")
  end

  it "doesn't return the crafters" do
    SetOrderCommand.new("burger", event_data_from_will).run

    guest_order_for("james smith")
    guest_order_for("jean bon")

    expect(guest_provider.run).to eq("james smith\njean bon")
    expect(Order.last(:user_id => "asdf")).not_to be_nil
  end

  private

  def guest_order_for(name)
    place_order_guest = PlaceOrderGuest.new("burger", name, "host id")
    place_order_guest.run
  end
end
