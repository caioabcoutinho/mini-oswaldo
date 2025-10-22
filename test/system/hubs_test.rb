require "application_system_test_case"

class HubsTest < ApplicationSystemTestCase
  setup do
    @hub = hubs(:one)
  end

  test "visiting the index" do
    visit hubs_url
    assert_selector "h1", text: "Hubs"
  end

  test "should create hub" do
    visit hubs_url
    click_on "New hub"

    fill_in "Location", with: @hub.location
    fill_in "Name", with: @hub.name
    click_on "Create Hub"

    assert_text "Hub was successfully created"
    click_on "Back"
  end

  test "should update Hub" do
    visit hub_url(@hub)
    click_on "Edit this hub", match: :first

    fill_in "Location", with: @hub.location
    fill_in "Name", with: @hub.name
    click_on "Update Hub"

    assert_text "Hub was successfully updated"
    click_on "Back"
  end

  test "should destroy Hub" do
    visit hub_url(@hub)
    click_on "Destroy this hub", match: :first

    assert_text "Hub was successfully destroyed"
  end
end
